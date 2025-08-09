import Foundation
import CoreMotion

/// 运动传感器状态
enum MotionServiceState {
    case idle       // 空闲状态
    case monitoring // 监听状态（预览）
    case recording  // 录制状态

    var description: String {
        switch self {
        case .idle: return "空闲"
        case .monitoring: return "监听中"
        case .recording: return "录制中"
        }
    }
}

class MotionService {
    private let motionManager = CMMotionManager()
    private var previousVelocity: (x: Double, y: Double, z: Double) = (0, 0, 0)
    private var previousTimestamp: TimeInterval = 0
    private var referenceAttitude: CMAttitude?
    private var isFirstUpdate = true
    
    // 低通滤波相关
    private var previousSpeed: Double = 0.0
    private let lowPassFilterFactor: Double = 0.1 // 滤波系数，值越小越平滑

    // 动态阻尼相关
    private let motionThreshold: Double = 0.01   // 运动阈值，低于此值认为静止
    private let dampingFactor: Double = 0.95     // 速度衰减因子

    // 状态管理
    private(set) var currentState: MotionServiceState = .idle
    private var stateChangeHandler: ((MotionServiceState) -> Void)?
    
    var isAvailable: Bool {
        return motionManager.isDeviceMotionAvailable
    }
    
    var isActive: Bool {
        return motionManager.isDeviceMotionActive
    }
    
    /// 设置状态变化监听器
    func setStateChangeHandler(_ handler: @escaping (MotionServiceState) -> Void) {
        stateChangeHandler = handler
    }

    /// 启动运动更新（监听模式）
    func startMotionMonitoring(handler: @escaping (FlightDataSnapshot) -> Void) {
        startMotionUpdates(for: .monitoring, handler: handler)
    }

    /// 启动运动更新（录制模式）
    func startMotionRecording(handler: @escaping (FlightDataSnapshot) -> Void) {
        startMotionUpdates(for: .recording, handler: handler)
    }

    /// 通用的启动运动更新方法
    private func startMotionUpdates(for newState: MotionServiceState, handler: @escaping (FlightDataSnapshot) -> Void) {
        guard motionManager.isDeviceMotionAvailable else {
            if AppConfig.Debug.enableVerboseLogging {
                print("Device motion is not available")
            }
            return
        }

        // 状态转换检查
        guard canTransitionTo(newState) else {
            if AppConfig.Debug.enableVerboseLogging {
                print("无法从 \(currentState.description) 转换到 \(newState.description)")
            }
            return
        }

        // 如果已经在运行，先停止
        if motionManager.isDeviceMotionActive {
            motionManager.stopDeviceMotionUpdates()
        }

        // 更新状态
        changeState(to: newState)

        motionManager.deviceMotionUpdateInterval = AppConfig.Recording.motionUpdateInterval
        motionManager.startDeviceMotionUpdates(using: .xArbitraryZVertical, to: .main) { [weak self] (motion, error) in
            guard let motion = motion, let self = self else { return }
            
            if let error = error {
                print("Motion update error: \(error)")
                return
            }
            
            // 如果第一次更新，设置参考姿态
            if self.referenceAttitude == nil {
                self.referenceAttitude = motion.attitude
            }
            
            // 计算相对姿态
            let currentAttitude = motion.attitude.copy() as! CMAttitude
            if let refAttitude = self.referenceAttitude {
                currentAttitude.multiply(byInverseOf: refAttitude)
            }

            let currentTimestamp = motion.timestamp
            let userAcceleration = motion.userAcceleration

            // 计算加速度大小
            let accelerationMagnitude = sqrt(
                userAcceleration.x * userAcceleration.x +
                userAcceleration.y * userAcceleration.y +
                userAcceleration.z * userAcceleration.z
            )

            // 计算速度 (基于加速度积分)
            let speed = self.calculateSpeed(from: userAcceleration, timestamp: currentTimestamp)

            // 转换角度为度数
            let pitch = currentAttitude.pitch * 180.0 / .pi
            let roll = currentAttitude.roll * 180.0 / .pi
            let yaw = currentAttitude.yaw * 180.0 / .pi

            let snapshot = FlightDataSnapshot(
                timestamp: Date(),
                acceleration: accelerationMagnitude,
                speed: speed,
                pitch: pitch,
                roll: roll,
                yaw: yaw
            )
            
            handler(snapshot)
        }
    }
    
    func stopMotionUpdates() {
        motionManager.stopDeviceMotionUpdates()
        changeState(to: .idle)
        resetSensorData()
    }

    func resetSensorData() {
        // 重置所有传感器数据，为新的录制会话做准备
        previousTimestamp = 0
        previousVelocity = (0, 0, 0)
        previousSpeed = 0.0
        referenceAttitude = nil
        isFirstUpdate = true
    }
    
    /// 校准传感器，将当前姿态设为参考基准
    func calibrate() {
        referenceAttitude = motionManager.deviceMotion?.attitude.copy() as? CMAttitude
        print("传感器已校准")
    }
    
    private func calculateSpeed(from acceleration: CMAcceleration, timestamp: TimeInterval) -> Double {
        if isFirstUpdate {
            previousTimestamp = timestamp
            isFirstUpdate = false
            return 0.0
        }

        let deltaTime = timestamp - previousTimestamp
        guard deltaTime > 0 else { return previousSpeed }

        let accelerationMagnitude = sqrt(acceleration.x * acceleration.x + acceleration.y * acceleration.y + acceleration.z * acceleration.z)
        
        var newVelocityX: Double
        var newVelocityY: Double
        var newVelocityZ: Double
        
        if accelerationMagnitude < motionThreshold {
            // 当运动非常微弱时，应用阻尼并重置速度向量
            newVelocityX = previousVelocity.x * dampingFactor
            newVelocityY = previousVelocity.y * dampingFactor
            newVelocityZ = previousVelocity.z * dampingFactor
            // 速度过小则直接归零
            if sqrt(newVelocityX*newVelocityX + newVelocityY*newVelocityY + newVelocityZ*newVelocityZ) < 0.01 {
                newVelocityX = 0
                newVelocityY = 0
                newVelocityZ = 0
            }
        } else {
            // 正常积分
            newVelocityX = previousVelocity.x + acceleration.x * deltaTime
            newVelocityY = previousVelocity.y + acceleration.y * deltaTime
            newVelocityZ = previousVelocity.z + acceleration.z * deltaTime
        }
        
        let speedMagnitude = sqrt(
            newVelocityX * newVelocityX +
            newVelocityY * newVelocityY +
            newVelocityZ * newVelocityZ
        )

        let filteredSpeed = previousSpeed * (1.0 - lowPassFilterFactor) + speedMagnitude * lowPassFilterFactor
        
        previousVelocity = (newVelocityX, newVelocityY, newVelocityZ)
        previousTimestamp = timestamp
        previousSpeed = filteredSpeed

        return filteredSpeed
    }


    // MARK: - 状态管理

    /// 检查是否可以转换到新状态
    private func canTransitionTo(_ newState: MotionServiceState) -> Bool {
        switch (currentState, newState) {
        case (.idle, .monitoring), (.idle, .recording):
            return true
        case (.monitoring, .recording), (.monitoring, .idle):
            return true
        case (.recording, .idle):
            return true
        case (.recording, .monitoring):
            return true // 允许从录制切换到监听
        default:
            return currentState == newState // 允许相同状态
        }
    }

    /// 改变状态
    private func changeState(to newState: MotionServiceState) {
        let oldState = currentState
        currentState = newState

        if AppConfig.Debug.enableVerboseLogging {
            print("MotionService状态变化: \(oldState.description) -> \(newState.description)")
        }

        stateChangeHandler?(newState)
    }
}

// 用于传递实时数据的结构体
struct FlightDataSnapshot: Equatable {
    let timestamp: Date
    let acceleration: Double  // 加速度大小 (m/s²)
    let speed: Double         // 速度大小 (m/s)
    let pitch: Double
    let roll: Double
    let yaw: Double
}

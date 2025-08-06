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
            
            // 计算速度 (基于加速度积分)
            let speed = self.calculateSpeed(from: userAcceleration, timestamp: currentTimestamp)
            
            // 转换角度为度数
            let pitch = currentAttitude.pitch * 180.0 / .pi
            let roll = currentAttitude.roll * 180.0 / .pi
            let yaw = currentAttitude.yaw * 180.0 / .pi
            
            let snapshot = FlightDataSnapshot(
                timestamp: Date(),
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
        referenceAttitude = nil
        isFirstUpdate = true
    }
    
    /// 校准传感器，将当前姿态设为参考基准
    func calibrate() {
        referenceAttitude = motionManager.deviceMotion?.attitude.copy() as? CMAttitude
        print("传感器已校准")
    }
    
    private func calculateSpeed(from acceleration: CMAcceleration, timestamp: TimeInterval) -> Double {
        // 第一次更新时，初始化时间戳
        if isFirstUpdate {
            previousTimestamp = timestamp
            isFirstUpdate = false
            return 0.0
        }

        // 计算时间间隔
        let deltaTime = timestamp - previousTimestamp
        guard deltaTime > 0 else { return 0.0 }

        // 使用梯形积分法计算速度变化
        // v = v0 + a * dt
        let newVelocityX = previousVelocity.x + acceleration.x * deltaTime
        let newVelocityY = previousVelocity.y + acceleration.y * deltaTime
        let newVelocityZ = previousVelocity.z + acceleration.z * deltaTime

        // 计算速度模长
        let speedMagnitude = sqrt(
            newVelocityX * newVelocityX +
            newVelocityY * newVelocityY +
            newVelocityZ * newVelocityZ
        )

        // 更新状态
        previousVelocity = (newVelocityX, newVelocityY, newVelocityZ)
        previousTimestamp = timestamp

        // 应用简单的低通滤波，减少噪声
        let filteredSpeed = speedMagnitude * 0.8 + (speedMagnitude * 0.2)

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
    let speed: Double
    let pitch: Double
    let roll: Double
    let yaw: Double
}

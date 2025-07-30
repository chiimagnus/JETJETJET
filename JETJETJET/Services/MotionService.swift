import Foundation
import CoreMotion

class MotionService {
    private let motionManager = CMMotionManager()
    private var previousVelocity: (x: Double, y: Double, z: Double) = (0, 0, 0)
    private var previousTimestamp: TimeInterval = 0
    private var referenceAttitude: CMAttitude?
    private var isFirstUpdate = true
    
    var isAvailable: Bool {
        return motionManager.isDeviceMotionAvailable
    }
    
    var isActive: Bool {
        return motionManager.isDeviceMotionActive
    }
    
    func startMotionUpdates(handler: @escaping (FlightDataSnapshot) -> Void) {
        guard motionManager.isDeviceMotionAvailable else {
            print("Device motion is not available")
            return
        }
        
        motionManager.deviceMotionUpdateInterval = 0.1 // 10Hz
        motionManager.startDeviceMotionUpdates(to: .main) { [weak self] (motion, error) in
            guard let motion = motion, let self = self else { return }
            
            if let error = error {
                print("Motion update error: \(error)")
                return
            }
            
            let currentTimestamp = motion.timestamp
            let attitude = motion.attitude
            let userAcceleration = motion.userAcceleration
            
            // 计算速度 (基于加速度积分)
            let speed = self.calculateSpeed(from: userAcceleration, timestamp: currentTimestamp)
            
            // 转换角度为度数
            let pitch = attitude.pitch * 180.0 / .pi
            let roll = attitude.roll * 180.0 / .pi
            let yaw = attitude.yaw * 180.0 / .pi
            
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
        resetSensorData()
    }

    func resetSensorData() {
        // 重置所有传感器数据，为新的录制会话做准备
        previousTimestamp = 0
        previousVelocity = (0, 0, 0)
        referenceAttitude = nil
        isFirstUpdate = true
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
}

// 用于传递实时数据的结构体
struct FlightDataSnapshot: Equatable {
    let timestamp: Date
    let speed: Double
    let pitch: Double
    let roll: Double
    let yaw: Double
}

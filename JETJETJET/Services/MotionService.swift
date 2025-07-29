import Foundation
import CoreMotion

class MotionService {
    private let motionManager = CMMotionManager()
    private var previousLocation: (x: Double, y: Double, z: Double) = (0, 0, 0)
    private var previousTimestamp: TimeInterval = 0
    private var referenceAttitude: CMAttitude?
    
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
            
            // 计算速度 (简化版本，基于加速度积分)
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
        previousTimestamp = 0
        previousLocation = (0, 0, 0)
        referenceAttitude = nil
    }

    func resetSensorData() {
        // 重置所有传感器数据，为新的录制会话做准备
        previousTimestamp = 0
        previousLocation = (0, 0, 0)
        referenceAttitude = nil
    }
    
    private func calculateSpeed(from acceleration: CMAcceleration, timestamp: TimeInterval) -> Double {
        // 简化的速度计算 - 使用加速度的模长作为速度指示
        let accelerationMagnitude = sqrt(
            acceleration.x * acceleration.x +
            acceleration.y * acceleration.y +
            acceleration.z * acceleration.z
        )
        
        // 返回加速度模长，作为运动强度的指示
        return accelerationMagnitude
    }
}

// 用于传递实时数据的结构体
struct FlightDataSnapshot {
    let timestamp: Date
    let speed: Double
    let pitch: Double
    let roll: Double
    let yaw: Double
}

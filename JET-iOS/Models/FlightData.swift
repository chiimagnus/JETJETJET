import Foundation
import SwiftData

@Model
final class FlightData {
    var timestamp: Date = Date()
    var acceleration: Double = 0.0  // 加速度大小 (m/s²)
    var speed: Double = 0.0         // 前进速度 (m/s)
    var pitch: Double = 0.0         // 俯仰角 (degrees)
    var roll: Double = 0.0          // 横滚角 (degrees)
    var yaw: Double = 0.0           // 偏航角 (degrees)
    var sessionId: UUID?            // 关联的会话ID

    init(timestamp: Date = Date(), acceleration: Double = 0.0, speed: Double = 0.0, pitch: Double = 0.0, roll: Double = 0.0, yaw: Double = 0.0, sessionId: UUID? = nil) {
        self.timestamp = timestamp
        self.acceleration = acceleration
        self.speed = speed
        self.pitch = pitch
        self.roll = roll
        self.yaw = yaw
        self.sessionId = sessionId
    }
    
    /// 根据用户偏好格式化加速度
    var formattedAcceleration: String {
        return String(format: "%.2f", acceleration)
    }

    /// 根据用户偏好格式化速度
    var formattedSpeed: String {
        let unit = UserPreferences.shared.speedUnit
        let convertedSpeed = convertSpeed(to: unit)
        return String(format: "%.1f", convertedSpeed)
    }

    /// 将速度从 m/s 转换为指定单位
    func convertSpeed(to unit: SpeedUnit) -> Double {
        switch unit {
        case .kilometersPerHour:
            return speed * 3.6 // m/s to km/h
        case .milesPerHour:
            return speed * 2.23694 // m/s to mph
        case .knots:
            return speed * 1.94384 // m/s to knots
        }
    }
}

import Foundation
import SwiftData

@Model
final class FlightSession {
    var id: UUID = UUID()
    var startTime: Date = Date()
    var endTime: Date = Date()
    var dataCount: Int = 0
    var title: String = ""

    init(startTime: Date = Date(), endTime: Date = Date(), dataCount: Int = 0, id: UUID? = nil) {
        self.id = id ?? UUID()
        self.startTime = startTime
        self.endTime = endTime
        self.dataCount = dataCount

        // 自动生成标题
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        self.title = "飞行记录 - \(formatter.string(from: startTime))"
    }
    
    var duration: TimeInterval {
        return endTime.timeIntervalSince(startTime)
    }
    
    var formattedDuration: String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

// MARK: - 飞行统计数据扩展
extension FlightSession {
    /// 获取飞行统计数据
    /// - Parameter flightData: 相关的飞行数据数组
    /// - Returns: 飞行统计数据
    func getFlightStats(from flightData: [FlightData]) -> FlightStats {
        guard !flightData.isEmpty else {
            return FlightStats()
        }

        let maxAcceleration = flightData.map { abs($0.acceleration) }.max() ?? 0.0
        let maxSpeed = flightData.map { abs($0.speed) }.max() ?? 0.0
        let maxPitch = flightData.map { abs($0.pitch) }.max() ?? 0.0
        let maxRoll = flightData.map { abs($0.roll) }.max() ?? 0.0
        let maxYaw = flightData.map { abs($0.yaw) }.max() ?? 0.0

        return FlightStats(
            maxAcceleration: maxAcceleration,
            maxSpeed: maxSpeed,
            maxPitch: maxPitch,
            maxRoll: maxRoll,
            maxYaw: maxYaw
        )
    }

    /// 获取飞行描述
    var flightDescription: String {
        let duration = self.duration
        if duration > 180 { // 3分钟以上
            return "激烈机动"
        } else if duration > 120 { // 2分钟以上
            return "精彩飞行"
        } else {
            return "平稳飞行"
        }
    }
}

// MARK: - 飞行统计数据结构
struct FlightStats {
    let maxAcceleration: Double // 存储为 m/s²
    let maxSpeed: Double        // 存储为 m/s
    let maxPitch: Double
    let maxRoll: Double
    let maxYaw: Double

    init(maxAcceleration: Double = 0.0, maxSpeed: Double = 0.0, maxPitch: Double = 0.0, maxRoll: Double = 0.0, maxYaw: Double = 0.0) {
        self.maxAcceleration = maxAcceleration
        self.maxSpeed = maxSpeed
        self.maxPitch = maxPitch
        self.maxRoll = maxRoll
        self.maxYaw = maxYaw
    }

    /// 格式化最大加速度
    var formattedMaxAcceleration: String {
        return String(format: "%.2f", maxAcceleration)
    }

    /// 根据用户偏好格式化最大速度
    var formattedMaxSpeed: String {
        let unit = UserPreferences.shared.speedUnit
        let convertedSpeed = convertSpeed(maxSpeed, to: unit)
        return String(format: "%.1f", convertedSpeed)
    }

    var formattedMaxPitch: String {
        return String(format: "%.0f°", maxPitch)
    }

    var formattedMaxRoll: String {
        return String(format: "%.0f°", maxRoll)
    }

    var formattedMaxYaw: String {
        return String(format: "%.0f°", maxYaw)
    }
    
    /// 将速度从 m/s 转换为指定单位
    private func convertSpeed(_ speed: Double, to unit: SpeedUnit) -> Double {
        switch unit {
        case .kilometersPerHour:
            return speed * 3.6
        case .milesPerHour:
            return speed * 2.23694
        case .knots:
            return speed * 1.94384
        }
    }
}

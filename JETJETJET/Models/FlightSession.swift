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

        let maxSpeed = flightData.map { abs($0.speed) }.max() ?? 0.0
        let maxPitch = flightData.map { abs($0.pitch) }.max() ?? 0.0
        let maxRoll = flightData.map { abs($0.roll) }.max() ?? 0.0

        // 计算最大G力 (基于加速度数据的近似值)
        let maxG = flightData.map { sqrt($0.speed * $0.speed) / 9.81 }.max() ?? 0.0

        return FlightStats(
            maxSpeed: maxSpeed,
            maxPitch: maxPitch,
            maxRoll: maxRoll,
            maxG: maxG
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
    let maxSpeed: Double
    let maxPitch: Double
    let maxRoll: Double
    let maxG: Double

    init(maxSpeed: Double = 0.0, maxPitch: Double = 0.0, maxRoll: Double = 0.0, maxG: Double = 0.0) {
        self.maxSpeed = maxSpeed
        self.maxPitch = maxPitch
        self.maxRoll = maxRoll
        self.maxG = maxG
    }

    var formattedMaxSpeed: String {
        return String(format: "%.1f", maxSpeed)
    }

    var formattedMaxPitch: String {
        return String(format: "%.0f°", maxPitch)
    }

    var formattedMaxRoll: String {
        return String(format: "%.0f°", maxRoll)
    }

    var formattedMaxG: String {
        return String(format: "%.1fG", maxG)
    }
}

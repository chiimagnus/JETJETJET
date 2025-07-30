import Foundation

@Observable
class FlightDataDetailVM {
    
    init() {}
    
    // 格式化日期时间
    func formatDateTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        return formatter.string(from: date)
    }
    
    // 格式化时间
    func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        return formatter.string(from: date)
    }
    
    // 格式化数值
    func formatValue(_ value: Double) -> String {
        return String(format: "%.2f", value)
    }
    
    // 获取角度说明数据
    func getAngleExplanations() -> [AngleExplanation] {
        return [
            AngleExplanation(
                title: "俯仰角 (Pitch)",
                description: "飞机机头向上或向下的角度",
                emoji: "✈️",
                gesture: "点头动作"
            ),
            AngleExplanation(
                title: "横滚角 (Roll)",
                description: "飞机左右翅膀的倾斜角度",
                emoji: "🔄",
                gesture: "摇头动作"
            ),
            AngleExplanation(
                title: "偏航角 (Yaw)",
                description: "飞机机头左右转向的角度",
                emoji: "↩️",
                gesture: "转头动作"
            )
        ]
    }
}

// MARK: - 数据模型
struct AngleExplanation {
    let title: String
    let description: String
    let emoji: String
    let gesture: String
}

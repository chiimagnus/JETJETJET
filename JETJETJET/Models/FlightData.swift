import Foundation
import SwiftData

@Model
final class FlightData {
    var timestamp: Date = Date()
    var speed: Double = 0.0      // 前进速度 (m/s)
    var pitch: Double = 0.0      // 俯仰角 (degrees)
    var roll: Double = 0.0       // 横滚角 (degrees)
    var yaw: Double = 0.0        // 偏航角 (degrees)
    var sessionId: UUID?         // 关联的会话ID

    init(timestamp: Date = Date(), speed: Double = 0.0, pitch: Double = 0.0, roll: Double = 0.0, yaw: Double = 0.0, sessionId: UUID? = nil) {
        self.timestamp = timestamp
        self.speed = speed
        self.pitch = pitch
        self.roll = roll
        self.yaw = yaw
        self.sessionId = sessionId
    }
}

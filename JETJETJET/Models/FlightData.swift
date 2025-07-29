//
//  FlightData.swift
//  JETJETJET
//
//  Created by chii_magnus on 2025/7/29.
//

import Foundation
import SwiftData

@Model
final class FlightData {
    var timestamp: Date
    var speed: Double      // 前进速度 (m/s)
    var pitch: Double      // 俯仰角 (degrees)
    var roll: Double       // 横滚角 (degrees)
    var yaw: Double        // 偏航角 (degrees)
    var sessionId: UUID?   // 关联的会话ID

    init(timestamp: Date, speed: Double, pitch: Double, roll: Double, yaw: Double, sessionId: UUID? = nil) {
        self.timestamp = timestamp
        self.speed = speed
        self.pitch = pitch
        self.roll = roll
        self.yaw = yaw
        self.sessionId = sessionId
    }
}

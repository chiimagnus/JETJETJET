//
//  FlightSession.swift
//  JETJETJET
//
//  Created by chii_magnus on 2025/7/29.
//

import Foundation
import SwiftData

@Model
final class FlightSession {
    var id: UUID = UUID()
    var startTime: Date = Date()
    var endTime: Date = Date()
    var dataCount: Int = 0
    var title: String = ""

    init(startTime: Date = Date(), endTime: Date = Date(), dataCount: Int = 0) {
        self.id = UUID()
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

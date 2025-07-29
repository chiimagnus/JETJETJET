//
//  FlightRecordingVM.swift
//  JETJETJET
//
//  Created by chii_magnus on 2025/7/29.
//

import Foundation
import SwiftData

@Observable
class FlightRecordingVM {
    private let motionService = MotionService()
    private var modelContext: ModelContext?
    private var recordedData: [FlightDataSnapshot] = []
    
    // 状态属性
    var isRecording = false
    var currentSnapshot: FlightDataSnapshot?
    var recordingDuration: TimeInterval = 0
    var recordingStartTime: Date?
    
    // 错误状态
    var errorMessage: String?
    
    init() {
        checkMotionAvailability()
    }
    
    func setModelContext(_ context: ModelContext) {
        self.modelContext = context
    }
    
    private func checkMotionAvailability() {
        if !motionService.isAvailable {
            errorMessage = "设备不支持运动传感器"
        }
    }
    
    func startRecording() {
        guard !isRecording else { return }
        guard motionService.isAvailable else {
            errorMessage = "运动传感器不可用"
            return
        }
        
        isRecording = true
        recordingStartTime = Date()
        recordedData.removeAll()
        errorMessage = nil
        
        motionService.startMotionUpdates { [weak self] snapshot in
            DispatchQueue.main.async {
                self?.handleMotionUpdate(snapshot)
            }
        }
    }
    
    func stopRecording() {
        guard isRecording else { return }
        
        isRecording = false
        motionService.stopMotionUpdates()
        
        // 保存录制的数据
        saveRecordedData()
        
        // 重置状态
        currentSnapshot = nil
        recordingDuration = 0
        recordingStartTime = nil
    }
    
    private func handleMotionUpdate(_ snapshot: FlightDataSnapshot) {
        currentSnapshot = snapshot
        recordedData.append(snapshot)
        
        // 更新录制时长
        if let startTime = recordingStartTime {
            recordingDuration = Date().timeIntervalSince(startTime)
        }
    }
    
    private func saveRecordedData() {
        guard let modelContext = modelContext else {
            errorMessage = "数据上下文不可用"
            return
        }
        
        // 将录制的数据保存到SwiftData
        for snapshot in recordedData {
            let flightData = FlightData(
                timestamp: snapshot.timestamp,
                speed: snapshot.speed,
                pitch: snapshot.pitch,
                roll: snapshot.roll,
                yaw: snapshot.yaw
            )
            modelContext.insert(flightData)
        }
        
        do {
            try modelContext.save()
            print("成功保存 \(recordedData.count) 条飞行数据")
        } catch {
            errorMessage = "保存数据失败: \(error.localizedDescription)"
        }
    }
    
    // 格式化显示用的辅助方法
    func formattedDuration() -> String {
        let minutes = Int(recordingDuration) / 60
        let seconds = Int(recordingDuration) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

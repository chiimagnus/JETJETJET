import Foundation
import SwiftData

@Observable
class FlightRecordingVM {
    private let motionService = MotionService()
    private var modelContext: ModelContext?
    private var recordedData: [FlightDataSnapshot] = []
    private var currentSessionId: UUID?

    // 状态属性
    var isRecording = false
    var currentSnapshot: FlightDataSnapshot?
    var recordingDuration: TimeInterval = 0
    var recordingStartTime: Date?

    // 移除了倒计时相关属性，现在由CountdownView处理

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

        // 直接开始录制（CountdownView已经处理了倒计时）
        beginActualRecording()
    }

    // 倒计时逻辑已移除，现在由CountdownView处理

    private func beginActualRecording() {
        // 重置所有传感器数据 - 归零
        motionService.resetSensorData()

        isRecording = true
        recordingStartTime = Date()
        recordedData.removeAll()
        currentSessionId = UUID()
        currentSnapshot = nil // 重置当前快照

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
        guard let modelContext = modelContext,
              let sessionId = currentSessionId,
              let startTime = recordingStartTime else {
            errorMessage = "数据上下文不可用"
            return
        }

        // 创建飞行会话
        let session = FlightSession(
            startTime: startTime,
            endTime: Date(),
            dataCount: recordedData.count
        )
        modelContext.insert(session)

        // 将录制的数据保存到SwiftData
        for snapshot in recordedData {
            let flightData = FlightData(
                timestamp: snapshot.timestamp,
                speed: snapshot.speed,
                pitch: snapshot.pitch,
                roll: snapshot.roll,
                yaw: snapshot.yaw,
                sessionId: sessionId
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
    
    // MARK: - 运动监听方法（非录制模式）

    /// 启动运动传感器监听（用于主界面预览）
    func startMotionMonitoring() {
        guard !isRecording else { return } // 如果正在录制，不启动预览监听
        guard motionService.isAvailable else {
            errorMessage = "运动传感器不可用"
            return
        }

        motionService.startMotionUpdates { [weak self] snapshot in
            DispatchQueue.main.async {
                // 只更新当前快照，不记录数据
                self?.currentSnapshot = snapshot
            }
        }
    }

    /// 停止运动传感器监听
    func stopMotionMonitoring() {
        if !isRecording { // 只有在非录制状态下才停止
            motionService.stopMotionUpdates()
            currentSnapshot = nil
        }
    }

    // 格式化显示用的辅助方法
    func formattedDuration() -> String {
        let minutes = Int(recordingDuration) / 60
        let seconds = Int(recordingDuration) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

import Foundation
import SwiftData

// MARK: - Array扩展，用于数据分块
extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
}

@Observable
@MainActor
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

    // 状态验证
    var isStateConsistent: Bool {
        validateState()
    }
    
    init() {
        checkMotionAvailability()
    }
    
    func setModelContext(_ context: ModelContext) {
        self.modelContext = context
    }
    
    private func checkMotionAvailability() {
        if !motionService.isAvailable {
            errorMessage = AppConfig.ErrorMessages.motionNotAvailable
        }
    }
    
    func startRecording() {
        guard !isRecording else { return }
        guard motionService.isAvailable else {
            errorMessage = AppConfig.ErrorMessages.motionNotAccessible
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

        // 启动录制模式的运动传感器
        motionService.startMotionRecording { [weak self] snapshot in
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

        // 录制停止后，重新启动预览监听（如果需要）
        // 这将在返回主界面时由MainView的onAppear处理
    }
    
    private func handleMotionUpdate(_ snapshot: FlightDataSnapshot) {
        currentSnapshot = snapshot
        recordedData.append(snapshot)

        // 更新录制时长
        if let startTime = recordingStartTime {
            recordingDuration = Date().timeIntervalSince(startTime)
        }

        // 内存管理：当数据量过大时，批量保存并清理内存
        if recordedData.count >= AppConfig.Recording.maxInMemoryDataCount {
            savePartialData()
        }
    }

    /// 保存部分数据并清理内存
    private func savePartialData() {
        guard let modelContext = modelContext,
              let sessionId = currentSessionId else { return }

        // 批量保存数据
        let dataToSave = recordedData
        recordedData.removeAll() // 立即清理内存

        // 后台保存数据
        Task.detached {
            await MainActor.run { [weak self] in
                self?.saveBatchData(dataToSave, sessionId: sessionId, context: modelContext)
            }
        }
    }
    
    private func saveRecordedData() {
        guard let modelContext = modelContext,
              let _ = currentSessionId, // sessionId在savePartialData中使用
              let startTime = recordingStartTime else {
            errorMessage = AppConfig.ErrorMessages.dataContextUnavailable
            return
        }

        // 保存剩余的数据
        if !recordedData.isEmpty {
            savePartialData()
        }

        // 创建飞行会话
        let session = FlightSession(
            startTime: startTime,
            endTime: Date(),
            dataCount: recordedData.count
        )

        do {
            modelContext.insert(session)
            try modelContext.save()

            if AppConfig.Debug.enableVerboseLogging {
                print("成功保存飞行会话，总数据条数: \(recordedData.count)")
            }
        } catch {
            errorMessage = "\(AppConfig.ErrorMessages.dataSaveFailed): \(error.localizedDescription)"
        }
    }

    /// 批量保存数据
    private func saveBatchData(_ data: [FlightDataSnapshot], sessionId: UUID, context: ModelContext) {
        let chunks = data.chunked(into: AppConfig.Recording.batchSaveSize)

        for chunk in chunks {
            // 创建新的后台上下文
            let backgroundContext = ModelContext(context.container)

            // 批量插入数据
            for snapshot in chunk {
                let flightData = FlightData(
                    timestamp: snapshot.timestamp,
                    speed: snapshot.speed,
                    pitch: snapshot.pitch,
                    roll: snapshot.roll,
                    yaw: snapshot.yaw,
                    sessionId: sessionId
                )
                backgroundContext.insert(flightData)
            }

            // 保存批次
            do {
                try backgroundContext.save()
                if AppConfig.Debug.enableVerboseLogging {
                    print("批量保存 \(chunk.count) 条数据成功")
                }
            } catch {
                self.errorMessage = "\(AppConfig.ErrorMessages.dataSaveFailed): \(error.localizedDescription)"
            }
        }
    }
    
    // MARK: - 运动监听方法（非录制模式）

    /// 启动运动传感器监听（用于主界面预览）
    func startMotionMonitoring() {
        guard !isRecording else { return } // 如果正在录制，不启动预览监听
        guard motionService.isAvailable else {
            errorMessage = AppConfig.ErrorMessages.motionNotAccessible
            return
        }

        motionService.startMotionMonitoring { [weak self] snapshot in
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

    // MARK: - 状态管理和验证

    /// 验证当前状态是否一致
    private func validateState() -> Bool {
        guard AppConfig.Debug.enableStateValidation else { return true }

        // 检查录制状态一致性
        if isRecording {
            // 录制状态下必须有开始时间和会话ID
            guard recordingStartTime != nil, currentSessionId != nil else {
                if AppConfig.Debug.enableVerboseLogging {
                    print("状态不一致：录制中但缺少开始时间或会话ID")
                }
                return false
            }

            // 录制状态下传感器应该是活跃的
            guard motionService.isActive else {
                if AppConfig.Debug.enableVerboseLogging {
                    print("状态不一致：录制中但传感器未活跃")
                }
                return false
            }
        } else {
            // 非录制状态下不应该有录制相关数据
            if recordingStartTime != nil || currentSessionId != nil {
                if AppConfig.Debug.enableVerboseLogging {
                    print("状态不一致：未录制但存在录制数据")
                }
                return false
            }
        }

        return true
    }

    /// 尝试恢复状态一致性
    func recoverState() {
        if !validateState() {
            if AppConfig.Debug.enableVerboseLogging {
                print("检测到状态不一致，尝试恢复...")
            }

            if isRecording {
                // 如果标记为录制但状态不一致，停止录制
                forceStopRecording()
            } else {
                // 如果标记为未录制但有残留数据，清理状态
                cleanupState()
            }
        }
    }

    /// 强制停止录制并清理状态
    private func forceStopRecording() {
        isRecording = false
        motionService.stopMotionUpdates()

        // 尝试保存已有数据
        if !recordedData.isEmpty {
            saveRecordedData()
        }

        cleanupState()

        errorMessage = AppConfig.ErrorMessages.inconsistentRecordingState
    }

    /// 清理状态
    private func cleanupState() {
        currentSnapshot = nil
        recordingDuration = 0
        recordingStartTime = nil
        currentSessionId = nil
        recordedData.removeAll()
    }

    // 格式化显示用的辅助方法
    func formattedDuration() -> String {
        let minutes = Int(recordingDuration) / 60
        let seconds = Int(recordingDuration) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

import Foundation
import SwiftData

@Observable
class AirplaneModelVM {
    private var modelContext: ModelContext?
    private var playbackTimer: Timer?
    private var sessionStartTime: Date?

    // 状态属性
    var isPlaying = false
    var currentDataIndex = 0
    var sessionFlightData: [FlightData] = []
    var playbackSpeed: Double = 1.0 // 播放速度倍率

    // 错误状态
    var errorMessage: String?

    init() {}
    
    func setModelContext(_ context: ModelContext) {
        self.modelContext = context
    }
    
    func loadSessionData(for session: FlightSession) {
        guard let modelContext = modelContext else {
            errorMessage = "数据上下文不可用"
            return
        }

        // 保存会话开始时间用于时间计算
        sessionStartTime = session.startTime

        let sessionId = session.id
        let request = FetchDescriptor<FlightData>(
            predicate: #Predicate<FlightData> { data in
                data.sessionId == sessionId
            },
            sortBy: [SortDescriptor(\.timestamp)]
        )

        do {
            sessionFlightData = try modelContext.fetch(request)
            errorMessage = nil
            // 重置播放状态
            currentDataIndex = 0
            isPlaying = false
        } catch {
            print("加载会话数据失败: \(error)")
            errorMessage = "加载数据失败: \(error.localizedDescription)"
            sessionFlightData = []
        }
    }
    
    func togglePlayback() {
        if isPlaying {
            stopPlayback()
        } else {
            startPlayback()
        }
    }
    
    func startPlayback() {
        guard !sessionFlightData.isEmpty else { return }

        isPlaying = true
        let interval = 0.1 / playbackSpeed // 根据播放速度调整间隔
        playbackTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
            guard let self = self else { return }

            if self.currentDataIndex < self.sessionFlightData.count - 1 {
                self.currentDataIndex += 1
            } else {
                self.stopPlayback()
            }
        }
    }
    
    func stopPlayback() {
        isPlaying = false
        playbackTimer?.invalidate()
        playbackTimer = nil
    }
    
    func seekToIndex(_ index: Int) {
        currentDataIndex = max(0, min(index, sessionFlightData.count - 1))
    }
    
    func getCurrentFlightData() -> FlightData? {
        guard currentDataIndex < sessionFlightData.count else { return nil }
        return sessionFlightData[currentDataIndex]
    }
    
    // MARK: - 播放速度控制
    func setPlaybackSpeed(_ speed: Double) {
        playbackSpeed = max(0.1, min(5.0, speed)) // 限制在0.1x到5x之间

        // 如果正在播放，重新启动定时器以应用新速度
        if isPlaying {
            stopPlayback()
            startPlayback()
        }
    }

    // MARK: - 时间格式化
    var currentPlaybackTime: String {
        guard !sessionFlightData.isEmpty, currentDataIndex < sessionFlightData.count else {
            return "00:00"
        }

        let currentData = sessionFlightData[currentDataIndex]
        guard let startTime = sessionStartTime else {
            return "00:00"
        }

        let elapsed = currentData.timestamp.timeIntervalSince(startTime)
        return formatTime(elapsed)
    }

    var totalPlaybackTime: String {
        guard !sessionFlightData.isEmpty,
              let startTime = sessionStartTime,
              let lastData = sessionFlightData.last else {
            return "00:00"
        }

        let total = lastData.timestamp.timeIntervalSince(startTime)
        return formatTime(total)
    }

    var formattedCurrentTime: String {
        return currentPlaybackTime
    }

    var formattedTotalTime: String {
        return totalPlaybackTime
    }

    private func formatTime(_ timeInterval: TimeInterval) -> String {
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    // MARK: - 播放进度
    var playbackProgress: Double {
        guard !sessionFlightData.isEmpty else { return 0.0 }
        return Double(currentDataIndex) / Double(sessionFlightData.count - 1)
    }

    // MARK: - 数据统计
    var dataPointsRemaining: Int {
        return max(0, sessionFlightData.count - currentDataIndex - 1)
    }

    var estimatedTimeRemaining: String {
        guard !sessionFlightData.isEmpty, isPlaying else { return "00:00" }

        let remainingPoints = dataPointsRemaining
        let timePerPoint = 0.1 / playbackSpeed
        let remainingTime = Double(remainingPoints) * timePerPoint

        return formatTime(remainingTime)
    }

    deinit {
        stopPlayback()
    }
}

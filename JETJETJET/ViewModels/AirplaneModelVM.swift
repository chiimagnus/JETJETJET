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

        let sessionId: UUID? = session.id
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

            // 调试信息
            print("成功加载会话数据:")
            print("- 会话ID: \(sessionId)")
            print("- 数据条数: \(sessionFlightData.count)")
            print("- 会话dataCount: \(session.dataCount)")
            if let firstData = sessionFlightData.first {
                print("- 第一条数据时间: \(firstData.timestamp)")
                print("- 第一条数据sessionId: \(firstData.sessionId?.uuidString ?? "nil")")
            }
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

    // MARK: - 调试方法
    func debugDataLoad() {
        guard let modelContext = modelContext else {
            print("❌ ModelContext 不可用")
            return
        }

        // 查询所有FlightSession
        let sessionRequest = FetchDescriptor<FlightSession>(
            sortBy: [SortDescriptor(\.startTime, order: .reverse)]
        )

        do {
            let allSessions = try modelContext.fetch(sessionRequest)
            print("📊 数据库中的所有会话:")
            for (index, session) in allSessions.enumerated() {
                print("  \(index + 1). ID: \(session.id)")
                print("     标题: \(session.title)")
                print("     数据条数: \(session.dataCount)")
                print("     开始时间: \(session.startTime)")

                // 查询该会话的FlightData
                let sessionId: UUID? = session.id
                let dataRequest = FetchDescriptor<FlightData>(
                    predicate: #Predicate<FlightData> { data in
                        data.sessionId == sessionId
                    }
                )

                let sessionData = try modelContext.fetch(dataRequest)
                print("     实际数据条数: \(sessionData.count)")
                print("     ---")
            }
        } catch {
            print("❌ 查询数据失败: \(error)")
        }
    }

    deinit {
        stopPlayback()
    }
}

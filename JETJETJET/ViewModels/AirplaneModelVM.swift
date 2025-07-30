import Foundation
import SwiftData

@Observable
class AirplaneModelVM {
    private var modelContext: ModelContext?
    private var playbackTimer: Timer?
    
    // 状态属性
    var isPlaying = false
    var currentDataIndex = 0
    var sessionFlightData: [FlightData] = []
    
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
        playbackTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
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
    
    deinit {
        stopPlayback()
    }
}

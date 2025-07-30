import SwiftUI
import SceneKit
import SwiftData

struct AirplaneModelView: View {
    let session: FlightSession
    @Environment(\.modelContext) private var modelContext
    @State private var showingDataSheet = false
    @State private var isPlaying = false
    @State private var currentDataIndex = 0
    @State private var playbackTimer: Timer?
    
    @State private var sessionFlightData: [FlightData] = []
    @State private var airplane3DModel = Airplane3DModel()
    
    var body: some View {
        VStack {
            // 3D场景视图
            SceneView(
                scene: airplane3DModel.getScene(),
                options: [.allowsCameraControl, .autoenablesDefaultLighting]
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onChange(of: currentDataIndex) { _, newIndex in
                updateAirplaneAttitude()
            }
            
            // 播放控制
            PlaybackControlsView(
                isPlaying: isPlaying,
                currentIndex: currentDataIndex,
                totalCount: sessionFlightData.count,
                onPlayPause: togglePlayback,
                onSeek: seekToIndex
            )
            .padding()
        }
        .navigationTitle(session.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("数据详情") {
                    showingDataSheet = true
                }
            }
        }
        .sheet(isPresented: $showingDataSheet) {
            FlightDataDetailView(session: session, flightData: sessionFlightData)
        }
        .onAppear {
            loadSessionData()
        }
        .onDisappear {
            stopPlayback()
        }
    }
    
    private func updateAirplaneAttitude() {
        guard currentDataIndex < sessionFlightData.count else { return }
        let data = sessionFlightData[currentDataIndex]
        airplane3DModel.updateAirplaneAttitude(pitch: data.pitch, roll: data.roll, yaw: data.yaw)
    }
    
    private func togglePlayback() {
        if isPlaying {
            stopPlayback()
        } else {
            startPlayback()
        }
    }
    
    private func startPlayback() {
        guard !sessionFlightData.isEmpty else { return }
        
        isPlaying = true
        playbackTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            if currentDataIndex < sessionFlightData.count - 1 {
                currentDataIndex += 1
            } else {
                stopPlayback()
            }
        }
    }
    
    private func stopPlayback() {
        isPlaying = false
        playbackTimer?.invalidate()
        playbackTimer = nil
    }
    
    private func seekToIndex(_ index: Int) {
        currentDataIndex = max(0, min(index, sessionFlightData.count - 1))
    }

    private func loadSessionData() {
        let sessionId = session.id
        let request = FetchDescriptor<FlightData>(
            predicate: #Predicate<FlightData> { data in
                data.sessionId == sessionId
            },
            sortBy: [SortDescriptor(\.timestamp)]
        )

        do {
            sessionFlightData = try modelContext.fetch(request)
        } catch {
            print("加载会话数据失败: \(error)")
            sessionFlightData = []
        }
    }
}

// 播放控制组件
struct PlaybackControlsView: View {
    let isPlaying: Bool
    let currentIndex: Int
    let totalCount: Int
    let onPlayPause: () -> Void
    let onSeek: (Int) -> Void
    
    var body: some View {
        VStack(spacing: 10) {
            // 进度条
            if totalCount > 0 {
                HStack {
                    Text("0")
                        .font(.caption)
                    
                    Slider(
                        value: Binding(
                            get: { Double(currentIndex) },
                            set: { onSeek(Int($0)) }
                        ),
                        in: 0...Double(max(0, totalCount - 1)),
                        step: 1
                    )
                    
                    Text("\(totalCount - 1)")
                        .font(.caption)
                }
            }
            
            // 播放控制按钮
            HStack(spacing: 20) {
                Button(action: { onSeek(0) }) {
                    Image(systemName: "backward.end.fill")
                        .font(.title2)
                }
                .disabled(totalCount == 0)
                
                Button(action: onPlayPause) {
                    Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .font(.title)
                }
                .disabled(totalCount == 0)
                
                Button(action: { onSeek(totalCount - 1) }) {
                    Image(systemName: "forward.end.fill")
                        .font(.title2)
                }
                .disabled(totalCount == 0)
            }
            
            // 当前数据信息
            if totalCount > 0 && currentIndex < totalCount {
                Text("数据点: \(currentIndex + 1) / \(totalCount)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

#Preview {
    let session = FlightSession(startTime: Date(), endTime: Date().addingTimeInterval(60), dataCount: 100)
    return AirplaneModelView(session: session)
        .modelContainer(for: [FlightData.self, FlightSession.self], inMemory: true)
}

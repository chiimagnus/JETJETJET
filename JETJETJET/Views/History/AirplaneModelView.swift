import SwiftUI
import SceneKit
import SwiftData

struct AirplaneModelView: View {
    let session: FlightSession
    @Environment(\.modelContext) private var modelContext
    @State private var showingDataSheet = false
    @State private var viewModel = AirplaneModelVM()
    @State private var airplane3DModel = Airplane3DModel()
    @State private var modelService = AirplaneModelService.shared

    var body: some View {
        VStack {
            // 3D场景视图
            Airplane3DSceneView(
                airplane3DModel: airplane3DModel,
                height: nil,
                showControls: true
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onChange(of: viewModel.currentDataIndex) { _, newIndex in
                updateAirplaneAttitude()
            }

            // 播放控制
            PlaybackControlsView(
                isPlaying: viewModel.isPlaying,
                currentIndex: viewModel.currentDataIndex,
                totalCount: viewModel.sessionFlightData.count,
                onPlayPause: viewModel.togglePlayback,
                onSeek: viewModel.seekToIndex
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
            FlightDataDetailView(session: session, flightData: viewModel.sessionFlightData)
        }
        .onAppear {
            viewModel.setModelContext(modelContext)
            viewModel.loadSessionData(for: session)
            // 使用当前选择的模型类型初始化3D模型
            airplane3DModel = Airplane3DModel(modelType: modelService.currentModelType)
        }
        .onChange(of: modelService.currentModelType) { _, newModelType in
            // 当模型类型改变时，重新创建3D模型
            airplane3DModel = Airplane3DModel(modelType: newModelType)
        }
        .onDisappear {
            viewModel.stopPlayback()
        }

        // 错误信息显示
        if let errorMessage = viewModel.errorMessage {
            Text(errorMessage)
                .foregroundColor(.red)
                .padding()
        }
    }

    private func updateAirplaneAttitude() {
        guard let data = viewModel.getCurrentFlightData() else { return }
        airplane3DModel.updateAirplaneAttitude(pitch: data.pitch, roll: data.roll, yaw: data.yaw)
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

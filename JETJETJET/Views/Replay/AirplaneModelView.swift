import SwiftUI
import SceneKit
import SwiftData

struct AirplaneModelView: View {
    let session: FlightSession
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var showingDataSheet = false
    @State private var viewModel = AirplaneModelVM()
    @State private var airplane3DModel: Airplane3DModel
    @State private var lightSettings = LightSourceSettings()
    private var userPreferences = UserPreferences.shared

    init(session: FlightSession) {
        self.session = session
        // 使用用户选择的模型类型初始化
        self._airplane3DModel = State(initialValue: Airplane3DModel(modelType: UserPreferences.shared.selectedAirplaneModelType))
    }

    var body: some View {
        ZStack {
            // 星空背景
            StarfieldBackgroundView()
                .environment(lightSettings)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // 顶部导航栏
                topNavigationBar

                // 3D回放场景
                replay3DScene
                    .padding(.horizontal, 20)
                    .padding(.top, 20)

                // 播放控制条
                ModernPlaybackControlsView(
                    isPlaying: viewModel.isPlaying,
                    currentIndex: viewModel.currentDataIndex,
                    totalCount: viewModel.sessionFlightData.count,
                    currentTime: viewModel.currentPlaybackTime,
                    totalTime: viewModel.totalPlaybackTime,
                    onPlayPause: viewModel.togglePlayback,
                    onSeek: viewModel.seekToIndex,
                    onSkipBackward: { viewModel.seekToIndex(0) },
                    onSkipForward: { viewModel.seekToIndex(viewModel.sessionFlightData.count - 1) }
                )
                .padding(.horizontal, 20)
                .padding(.top, 20)

                // 当前时刻飞行数据
                if let currentData = viewModel.getCurrentFlightData() {
                    RealtimeFlightDataView(flightData: currentData)
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                }

                Spacer()
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showingDataSheet) {
            FlightDataDetailView(session: session, flightData: viewModel.sessionFlightData)
        }
        .onAppear {
            viewModel.setModelContext(modelContext)
            viewModel.loadSessionData(for: session)
        }
        .onDisappear {
            viewModel.stopPlayback()
        }
        .onChange(of: viewModel.currentDataIndex) { _, newIndex in
            updateAirplaneAttitude()
        }
        .onChange(of: userPreferences.selectedAirplaneModelType) { _, newModelType in
            // 当用户更改模型类型时，重新创建3D模型
            airplane3DModel = Airplane3DModel(modelType: newModelType)
        }

        // 错误信息显示
        if let errorMessage = viewModel.errorMessage {
            VStack {
                Spacer()
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                    .padding()
                Spacer()
            }
        }
    }

    private func updateAirplaneAttitude() {
        guard let data = viewModel.getCurrentFlightData() else { return }
        airplane3DModel.updateAirplaneAttitude(pitch: data.pitch, roll: data.roll, yaw: data.yaw)
    }
}

// MARK: - 视图组件扩展
extension AirplaneModelView {

    // 顶部导航栏
    private var topNavigationBar: some View {
        GlassCard {
            HStack {
                // 返回按钮
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "arrow.left")
                        .font(.system(.title3, weight: .medium))
                        .foregroundColor(.cyan)
                }

                Spacer()

                // 标题
                Text("REPLAY")
                    .font(.system(.title2, design: .rounded, weight: .bold))
                    .foregroundColor(.white)
                    .tracking(1)
                    .frame(maxWidth: .infinity)

                // 数据详情按钮
                Button(action: {
                    showingDataSheet = true
                }) {
                    Image(systemName: "list.bullet.clipboard")
                        .font(.system(.title3, weight: .medium))
                        .foregroundColor(.cyan)
                }
            }
            .padding()
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }

    // 3D回放场景
    private var replay3DScene: some View {
        // 3D飞机模型
        Airplane3DSceneView(
            airplane3DModel: airplane3DModel,
            height: 280,
            showControls: true
        )
        // .padding(.horizontal, horizontalPadding)
    }
}

#Preview {
    let session = FlightSession(startTime: Date(), endTime: Date().addingTimeInterval(60), dataCount: 100)
    return AirplaneModelView(session: session)
        .modelContainer(for: [FlightData.self, FlightSession.self], inMemory: true)
}

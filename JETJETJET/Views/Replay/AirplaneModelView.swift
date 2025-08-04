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
                    .padding(.horizontal, 20)
                    .padding(.top, 10)

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
        HStack {
            // 返回按钮
            Button(action: {
                dismiss()
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .medium))
                    Text("返回")
                        .font(.system(size: 16, weight: .medium))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.ultraThinMaterial)
                )
            }

            Spacer()

            // 标题
            Text("REPLAY")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.white)

            Spacer()

            // 数据详情按钮
            Button(action: {
                showingDataSheet = true
            }) {
                HStack(spacing: 6) {
                    Image(systemName: "doc.text")
                        .font(.system(size: 14, weight: .medium))
                    Text("数据")
                        .font(.system(size: 14, weight: .medium))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.ultraThinMaterial)
                )
            }
        }
    }

    // 3D回放场景
    private var replay3DScene: some View {
        ZStack {
            // 3D场景容器
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.1, green: 0.1, blue: 0.18),
                            Color(red: 0.09, green: 0.13, blue: 0.24),
                            Color(red: 0.06, green: 0.2, blue: 0.38),
                            Color(red: 0.33, green: 0.2, blue: 0.51)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(height: 350)

            // 3D飞机模型
            Airplane3DSceneView(
                airplane3DModel: airplane3DModel,
                height: 350,
                showControls: true
            )
            .clipShape(RoundedRectangle(cornerRadius: 20))

            // 实时数据覆盖层
            VStack {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("实时回放数据")
                            .font(.caption)
                            .foregroundColor(.blue)
                        Text("时间: \(viewModel.formattedCurrentTime) / \(viewModel.formattedTotalTime)")
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }
                    .padding(12)
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)

                    Spacer()
                }

                Spacer()
            }
            .padding(16)
        }
    }
}

#Preview {
    let session = FlightSession(startTime: Date(), endTime: Date().addingTimeInterval(60), dataCount: 100)
    return AirplaneModelView(session: session)
        .modelContainer(for: [FlightData.self, FlightSession.self], inMemory: true)
}

import SwiftUI
import SwiftData

struct MainView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = FlightRecordingVM()
    @State private var airplane3DModel: Airplane3DModel?
    @State private var showingRecordingView = false
    @State private var showingCountdownView = false
    @State private var lightSettings = LightSourceSettings()
    private var userPreferences = UserPreferences.shared
    
    var body: some View {
        NavigationStack {
            ZStack {
                // 动态星空背景 - 根据飞机姿态调整
                StarfieldBackgroundView(
                    pitch: viewModel.currentSnapshot?.pitch ?? 0.0,
                    roll: viewModel.currentSnapshot?.roll ?? 0.0,
                    yaw: viewModel.currentSnapshot?.yaw ?? 0.0
                )

                // 主要内容 - 使用均匀分散布局
                VStack(spacing: 0) {
                    // 顶部标题栏
                    NavigationHeaderView(titleType: .main, showRecordingBorder: false)
                        .padding(.horizontal, horizontalPadding)
                        .padding(.top, 8)

                    Spacer()

                    // 3D飞机显示区域
                    if let airplane3DModel = airplane3DModel {
                        Airplane3DSceneView(
                            airplane3DModel: airplane3DModel,
                            height: 280,
                            showControls: true
                        )
                        .padding(.horizontal, horizontalPadding)
                    } else {
                        // 3D模型加载占位符
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.ultraThinMaterial)
                            .frame(height: 300)
                            .overlay(
                                VStack(spacing: 12) {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .cyan))
                                    Text("加载3D模型...")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            )
                            .padding(.horizontal, horizontalPadding)
                    }

                    Spacer()

                    // HUD数据条
                    HUDDataBarView(snapshot: viewModel.currentSnapshot)
                        .padding(.horizontal, horizontalPadding)

                    Spacer()

                    // 主要操作按钮
                    MainActionButtonView {
                        // 显示倒计时界面
                        showingCountdownView = true
                    }
                    .padding(.horizontal, horizontalPadding)

                    Spacer()

                    // 底部功能区
                    BottomFunctionView()
                        .padding(.horizontal, horizontalPadding)
                        .padding(.bottom, 20)
                }
            }
            .preferredColorScheme(.dark)
        }
        .environment(lightSettings)
        .onAppear {
            viewModel.setModelContext(modelContext)
            // 延迟初始化3D模型，避免阻塞UI
            DispatchQueue.main.asyncAfter(deadline: .now() + AppConfig.Model3D.initializationDelay) {
                if airplane3DModel == nil {
                    airplane3DModel = Airplane3DModel(modelType: userPreferences.selectedAirplaneModelType)
                }
            }
            // 启动运动传感器监听（非录制模式）
            viewModel.startMotionMonitoring()
        }
        .onDisappear {
            // 停止运动传感器监听
            viewModel.stopMotionMonitoring()
        }
        .onChange(of: viewModel.currentSnapshot) { _, snapshot in
            // 使用异步更新避免多次更新警告
            Task { @MainActor in
                updateAirplaneAttitude()
            }
        }
        .onChange(of: userPreferences.selectedAirplaneModelType) { _, newModelType in
            // 当用户更改模型类型时，重新创建3D模型
            Task { @MainActor in
                airplane3DModel = Airplane3DModel(modelType: newModelType)
            }
        }
        .simplePageTransition(showSecondPage: $showingCountdownView) {
            CountdownView(
                onAbort: {
                    // 点击abort按钮时回退到MainView
                    showingCountdownView = false
                },
                onRecordingComplete: {
                    // 录制完成时直接退回到MainView
                    showingCountdownView = false
                },
                viewModel: viewModel,
                lightSettings: lightSettings
            )
        }
    }

    // 响应式布局计算属性 - 参考RecordingActiveView
    private var horizontalPadding: CGFloat {
        UIScreen.main.bounds.width > 400 ? 24 : 16
    }

    private var verticalPadding: CGFloat {
        UIScreen.main.bounds.height > 800 ? 32 : 24
    }

    private func updateAirplaneAttitude() {
        guard let snapshot = viewModel.currentSnapshot,
              let airplane3DModel = airplane3DModel else { return }
        airplane3DModel.updateAirplaneAttitude(
            pitch: snapshot.pitch,
            roll: snapshot.roll,
            yaw: snapshot.yaw
        )
    }
}

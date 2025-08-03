import SwiftUI
import SwiftData

struct MainView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = FlightRecordingVM()
    @State private var airplane3DModel: Airplane3DModel?
    @State private var showingRecordingView = false
    @State private var showingCountdownView = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // 星空背景
                StarfieldBackgroundView()

                // 主要内容 - 使用VStack固定布局，不可滚动
                VStack(spacing: 0) {
                    // 顶部标题栏 - 固定在顶部
                    HeaderView()
                        .adaptiveHorizontalPadding()
                        .padding(.top, 8)

                    // 主要内容区域
                    VStack(spacing: LayoutUtils.adaptiveSpacing) {
                        // 3D飞机显示区域 - 占据主要空间
                        if let airplane3DModel = airplane3DModel {
                            Airplane3DDisplayView(airplane3DModel: airplane3DModel)
                                .adaptiveHorizontalPadding()
                                .frame(maxHeight: .infinity)
                        } else {
                            // 3D模型加载占位符
                            RoundedRectangle(cornerRadius: 16)
                                .fill(.ultraThinMaterial)
                                .frame(maxHeight: .infinity)
                                .overlay(
                                    VStack(spacing: 12) {
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle(tint: .cyan))
                                        Text("加载3D模型...")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                )
                                .adaptiveHorizontalPadding()
                        }

                        // HUD数据条 - 与录制界面一致
                        HUDDataBarView(snapshot: viewModel.currentSnapshot)
                            .adaptiveHorizontalPadding()

                        // 主要操作按钮 - 只负责启动录制
                        MainActionButtonView {
                            // 显示倒计时界面
                            showingCountdownView = true
                        }
                        .adaptiveHorizontalPadding()
                    }
                    .padding(.vertical, 16)

                    // 底部功能区 - 固定在底部
                    BottomFunctionView()
                        .adaptiveHorizontalPadding()
                        .padding(.bottom, 20)
                }
            }
            .preferredColorScheme(.dark)
        }
        .onAppear {
            viewModel.setModelContext(modelContext)
            // 延迟初始化3D模型，避免阻塞UI
            DispatchQueue.main.asyncAfter(deadline: .now() + AppConfig.Model3D.initializationDelay) {
                if airplane3DModel == nil {
                    airplane3DModel = Airplane3DModel()
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
        .fullScreenCover(isPresented: $showingCountdownView) {
            CountdownView {
                // 倒计时完成后的处理
                showingCountdownView = false
                viewModel.startRecording()

                // 开始录制后跳转到录制界面
                DispatchQueue.main.asyncAfter(deadline: .now() + AppConfig.Recording.transitionDelay) {
                    if viewModel.isRecording {
                        showingRecordingView = true
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $showingRecordingView) {
            RecordingActiveView(viewModel: viewModel)
        }
    }
    
    // 布局计算已移至LayoutUtils

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

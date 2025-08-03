import SwiftUI
import SwiftData

struct MainView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = FlightRecordingVM()
    @State private var airplane3DModel: Airplane3DModel?
    @State private var showingRecordingView = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // 星空背景
                StarfieldBackgroundView()

                // 主要内容 - 使用VStack固定布局，不可滚动
                VStack(spacing: 0) {
                    // 顶部标题栏 - 固定在顶部
                    HeaderView()
                        .padding(.horizontal, horizontalPadding)
                        .padding(.top, 8)

                    // 主要内容区域
                    VStack(spacing: adaptiveSpacing) {
                        // 3D飞机显示区域 - 占据主要空间
                        if let airplane3DModel = airplane3DModel {
                            Airplane3DDisplayView(airplane3DModel: airplane3DModel)
                                .padding(.horizontal, horizontalPadding)
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
                                .padding(.horizontal, horizontalPadding)
                        }

                        // 仪表盘 - 紧凑布局
                        InstrumentPanelView(snapshot: viewModel.currentSnapshot)
                            .padding(.horizontal, horizontalPadding)

                        // 状态指示器 - 紧凑显示
                        MainStatusIndicatorView(
                            isRecording: viewModel.isRecording,
                            isCountingDown: viewModel.isCountingDown,
                            countdownValue: viewModel.countdownValue
                        )
                        .padding(.horizontal, horizontalPadding)

                        // 主要操作按钮
                        MainActionButtonView(
                            isRecording: viewModel.isRecording,
                            isCountingDown: viewModel.isCountingDown,
                            onStart: {
                                viewModel.startRecording()
                                // 开始录制后跳转到录制界面
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                                    if viewModel.isRecording {
                                        showingRecordingView = true
                                    }
                                }
                            },
                            onStop: { viewModel.stopRecording() }
                        )
                        .padding(.horizontal, horizontalPadding)
                    }
                    .padding(.vertical, 16)

                    // 底部功能区 - 固定在底部
                    BottomFunctionView()
                        .padding(.horizontal, horizontalPadding)
                        .padding(.bottom, 20)
                }
            }
            .preferredColorScheme(.dark)
        }
        .onAppear {
            viewModel.setModelContext(modelContext)
            // 延迟初始化3D模型，避免阻塞UI
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                if airplane3DModel == nil {
                    airplane3DModel = Airplane3DModel()
                }
            }
        }
        .onChange(of: viewModel.currentSnapshot) { _, snapshot in
            updateAirplaneAttitude()
        }
        .fullScreenCover(isPresented: $showingRecordingView) {
            RecordingActiveView()
        }
    }
    
    // 响应式布局计算属性
    private var horizontalPadding: CGFloat {
        // iPhone 16 Pro Max 和其他大屏设备使用更大的边距
        UIScreen.main.bounds.width > 400 ? 24 : 16
    }

    private var verticalPadding: CGFloat {
        UIScreen.main.bounds.height > 800 ? 32 : 24
    }

    private var adaptiveSpacing: CGFloat {
        UIScreen.main.bounds.height > 800 ? 28 : 24
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

#Preview {
    // 简化的预览版本，避免复杂依赖
    NavigationStack {
        ZStack {
            StarfieldBackgroundView()

            VStack(spacing: 0) {
                // 简化的头部
                Text("JETJETJET")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding()

                Spacer()

                // 占位符内容
                VStack(spacing: 20) {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.ultraThinMaterial)
                        .frame(height: 200)
                        .overlay(Text("3D Display").foregroundColor(.white))

                    RoundedRectangle(cornerRadius: 12)
                        .fill(.ultraThinMaterial)
                        .frame(height: 100)
                        .overlay(Text("Instruments").foregroundColor(.white))

                    RoundedRectangle(cornerRadius: 12)
                        .fill(.green)
                        .frame(height: 60)
                        .overlay(Text("START").foregroundColor(.white))
                }
                .padding()

                Spacer()

                // 简化的底部
                HStack {
                    Text("LOGS")
                    Spacer()
                    Text("SETUP")
                }
                .padding()
                .foregroundColor(.white)
            }
        }
        .preferredColorScheme(.dark)
    }
}

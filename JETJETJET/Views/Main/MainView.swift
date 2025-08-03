import SwiftUI
import SwiftData

struct MainView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = FlightRecordingVM()
    @State private var airplane3DModel = Airplane3DModel()
    @State private var showingRecordingView = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // 星空背景
                StarfieldBackgroundView()
                
                // 主要内容 - 所有内容都在ScrollView内，可以一起滚动
                ScrollView {
                    VStack(spacing: adaptiveSpacing) {
                        // 顶部标题栏 - 现在会随着滚动移动
                        HeaderView()
                            .padding(.horizontal, horizontalPadding)
                            .padding(.top, 8)

                        // 3D飞机显示区域
                        Airplane3DDisplayView(airplane3DModel: airplane3DModel)
                            .padding(.horizontal, horizontalPadding)

                        // 仪表盘
                        InstrumentPanelView(snapshot: viewModel.currentSnapshot)
                            .padding(.horizontal, horizontalPadding)

                        // 状态指示器
                        MainStatusIndicatorView(
                            isRecording: viewModel.isRecording,
                            isCountingDown: viewModel.isCountingDown,
                            countdownValue: viewModel.countdownValue
                        )

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

                        // 底部功能区
                        BottomFunctionView()
                            .padding(.horizontal, horizontalPadding)
                    }
                    .padding(.vertical, verticalPadding)
                }
            }
            .preferredColorScheme(.dark)
        }
        .onAppear {
            viewModel.setModelContext(modelContext)
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
        guard let snapshot = viewModel.currentSnapshot else { return }
        airplane3DModel.updateAirplaneAttitude(
            pitch: snapshot.pitch,
            roll: snapshot.roll,
            yaw: snapshot.yaw
        )
    }
}

#Preview {
    MainView()
        .modelContainer(for: FlightData.self, inMemory: true)
}

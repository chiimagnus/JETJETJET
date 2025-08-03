import SwiftUI
import SwiftData

struct MainView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = FlightRecordingVM()
    @State private var airplane3DModel = Airplane3DModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                // 星空背景
                StarfieldBackgroundView()
                
                // 主要内容
                VStack(spacing: 0) {
                    // 顶部标题栏
                    HeaderView()
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                    
                    ScrollView {
                        VStack(spacing: 24) {
                            // 3D飞机显示区域
                            Airplane3DDisplayView(airplane3DModel: airplane3DModel)
                                .padding(.horizontal, 16)
                            
                            // 仪表盘
                            InstrumentPanelView(snapshot: viewModel.currentSnapshot)
                                .padding(.horizontal, 16)
                            
                            // 状态指示器
                            StatusIndicatorView(
                                isRecording: viewModel.isRecording,
                                isCountingDown: viewModel.isCountingDown,
                                countdownValue: viewModel.countdownValue
                            )
                            
                            // 主要操作按钮
                            MainActionButtonView(
                                isRecording: viewModel.isRecording,
                                isCountingDown: viewModel.isCountingDown,
                                onStart: { viewModel.startRecording() },
                                onStop: { viewModel.stopRecording() }
                            )
                            
                            // 底部功能区
                            BottomFunctionView()
                                .padding(.horizontal, 16)
                        }
                        .padding(.vertical, 24)
                    }
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

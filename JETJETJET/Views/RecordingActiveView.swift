import SwiftUI
import SwiftData

struct RecordingActiveView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = FlightRecordingVM()
    @State private var airplane3DModel = Airplane3DModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            // 星空背景
            StarfieldBackgroundView()
            
            // 主要内容
            VStack(spacing: 0) {
                // 录制状态栏
                RecordingStatusBarView(
                    isRecording: viewModel.isRecording,
                    duration: viewModel.formattedDuration()
                )
                .padding(.horizontal, horizontalPadding)
                .padding(.top, 8)
                
                ScrollView {
                    VStack(spacing: adaptiveSpacing) {
                        // 飞行场景
                        FlightSceneView(airplane3DModel: airplane3DModel)
                            .padding(.horizontal, horizontalPadding)
                        
                        // HUD数据条
                        HUDDataBarView(snapshot: viewModel.currentSnapshot)
                            .padding(.horizontal, horizontalPadding)
                        
                        // 关键指标
                        KeyMetricsView(snapshot: viewModel.currentSnapshot)
                            .padding(.horizontal, horizontalPadding)
                        
                        // 停止按钮
                        StopRecordingButtonView {
                            viewModel.stopRecording()
                            dismiss()
                        }
                    }
                    .padding(.vertical, verticalPadding)
                }
            }
        }
        .preferredColorScheme(.dark)
        .navigationBarHidden(true)
        .onAppear {
            viewModel.setModelContext(modelContext)
        }
        .onChange(of: viewModel.currentSnapshot) { _, snapshot in
            updateAirplaneAttitude()
        }
    }
    
    // 响应式布局计算属性
    private var horizontalPadding: CGFloat {
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
    RecordingActiveView()
        .modelContainer(for: FlightData.self, inMemory: true)
}

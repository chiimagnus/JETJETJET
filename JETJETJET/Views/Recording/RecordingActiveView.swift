import SwiftUI
import SwiftData

struct RecordingActiveView: View {
    @Environment(\.modelContext) private var modelContext
    let viewModel: FlightRecordingVM
    @State private var airplane3DModel = Airplane3DModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            // 星空背景
            StarfieldBackgroundView()
            
            // 主要内容 - 所有内容都在ScrollView内，可以一起滚动
            ScrollView {
                VStack(spacing: adaptiveSpacing) {
                    // 录制状态栏 - 现在会随着滚动移动
                    RecordingStatusBarView(
                        isRecording: viewModel.isRecording,
                        duration: viewModel.formattedDuration()
                    )
                    .padding(.horizontal, horizontalPadding)
                    .padding(.top, 8)

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
        .preferredColorScheme(.dark)
        .navigationBarHidden(true)
        .onAppear {
            // ViewModel已经在MainView中设置了modelContext，这里不需要重复设置
            // 验证和恢复录制状态
            validateAndRecoverRecordingState()
        }
        .onChange(of: viewModel.currentSnapshot) { _, snapshot in
            // 使用异步更新避免多次更新警告
            Task { @MainActor in
                updateAirplaneAttitude()
            }
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

    /// 验证和恢复录制状态
    private func validateAndRecoverRecordingState() {
        if !viewModel.isRecording {
            // 状态不一致，尝试恢复
            viewModel.recoverState()

            // 如果仍然不是录制状态，返回主界面
            if !viewModel.isRecording {
                dismiss()
            }
        } else if !viewModel.isStateConsistent {
            // 状态不一致，尝试恢复
            viewModel.recoverState()
        }
    }
}

#Preview {
    RecordingActiveView(viewModel: FlightRecordingVM())
        .modelContainer(for: FlightData.self, inMemory: true)
}

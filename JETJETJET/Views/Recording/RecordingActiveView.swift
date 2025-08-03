import SwiftUI
import SwiftData

struct RecordingActiveView: View {
    @Environment(\.modelContext) private var modelContext
    let viewModel: FlightRecordingVM
    @State private var airplane3DModel = Airplane3DModel()
    @Environment(\.dismiss) private var dismiss
    let onStopRecording: (() -> Void)?
    
    var body: some View {
        ZStack {
            // 动态星空背景 - 根据飞机姿态调整
            StarfieldBackgroundView(
                pitch: viewModel.currentSnapshot?.pitch ?? 0.0,
                roll: viewModel.currentSnapshot?.roll ?? 0.0,
                yaw: viewModel.currentSnapshot?.yaw ?? 0.0
            )
            
            // 主要内容 - 使用均匀分散布局
            VStack(spacing: 0) {
                // 录制状态栏
                RecordingStatusBarView(
                    isRecording: viewModel.isRecording,
                    duration: viewModel.formattedDuration()
                )
                .padding(.horizontal, horizontalPadding)
                .padding(.top, 8)

                Spacer()

                // 飞行场景
                Airplane3DSceneView(
                    airplane3DModel: airplane3DModel,
                    height: 280,
                    showControls: false
                )
                .padding(.horizontal, horizontalPadding)

                Spacer()

                // HUD数据条
                HUDDataBarView(snapshot: viewModel.currentSnapshot)
                    .padding(.horizontal, horizontalPadding)

                Spacer()

                // 停止按钮
                StopRecordingButtonView {
                    viewModel.stopRecording()
                    // 使用回调通知上层关闭
                    onStopRecording?()
                }
                .padding(.horizontal, horizontalPadding)
                .padding(.bottom, 20)
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
                onStopRecording?()
            }
        } else if !viewModel.isStateConsistent {
            // 状态不一致，尝试恢复
            viewModel.recoverState()
        }
    }
}

#Preview {
    RecordingActiveView(
        viewModel: FlightRecordingVM(),
        onStopRecording: {
            print("停止录制")
        }
    )
    .modelContainer(for: FlightData.self, inMemory: true)
}

import SwiftUI
import SwiftData
import SceneKit

struct FlightRecordingView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = FlightRecordingVM()
    @State private var airplane3DModel = Airplane3DModel()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // 标题
                Text("JET!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                // 状态指示器
                StatusIndicatorView(
                    isRecording: viewModel.isRecording,
                    isCountingDown: viewModel.isCountingDown,
                    countdownValue: viewModel.countdownValue
                )

                // 倒计时显示
                if viewModel.isCountingDown {
                    CountdownView(countdownValue: viewModel.countdownValue)
                }
                // 传感器数据显示
                else if let snapshot = viewModel.currentSnapshot {
                    SensorDataView(snapshot: snapshot)
                        .onAppear {
                            updateAirplaneAttitude()
                        }
                        .onChange(of: snapshot) {
                            updateAirplaneAttitude()
                        }
                } else if !viewModel.isCountingDown {
                    Text("等待传感器数据...")
                        .foregroundColor(.secondary)
                        .padding()
                }
                
                // 录制时长
                if viewModel.isRecording {
                    Text("录制时长: \(viewModel.formattedDuration())")
                        .font(.headline)
                        .foregroundColor(.blue)
                }
                
                // 3D飞机模型显示
                Airplane3DSceneView(
                    airplane3DModel: airplane3DModel,
                    height: 200,
                    showControls: true
                )

                Spacer()
                
                // 录制控制按钮
                RecordingControlButton(
                    isRecording: viewModel.isRecording,
                    isCountingDown: viewModel.isCountingDown,
                    onStart: { viewModel.startRecording() },
                    onStop: { viewModel.stopRecording() }
                )

                // 使用提示
                if !viewModel.isRecording && !viewModel.isCountingDown {
                    Text("💡 将手机顶部对着飞机头方向，平放在桌子上开始录制")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                } else if viewModel.isCountingDown {
                    Text("📱 请将手机平放在桌子上\n手机顶部对着飞机头方向")
                        .font(.caption)
                        .foregroundColor(.orange)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                
                // 错误信息
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
                
                Spacer()
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: FlightHistoryView()) {
                        Image(systemName: "clock.arrow.circlepath")
                    }
                }
            }
        }
        .onAppear {
            viewModel.setModelContext(modelContext)
        }
    }
    
    private func updateAirplaneAttitude() {
        guard let snapshot = viewModel.currentSnapshot else { return }
        airplane3DModel.updateAirplaneAttitude(pitch: snapshot.pitch, roll: snapshot.roll, yaw: snapshot.yaw)
    }
}

// 状态指示器组件
struct StatusIndicatorView: View {
    let isRecording: Bool
    let isCountingDown: Bool
    let countdownValue: Int

    var body: some View {
        HStack {
            Circle()
                .fill(statusColor)
                .frame(width: 12, height: 12)
                .scaleEffect(isRecording || isCountingDown ? 1.2 : 1.0)
                .animation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true), value: isRecording || isCountingDown)

            Text(statusText)
                .font(.headline)
                .foregroundColor(statusColor)
        }
    }

    private var statusColor: Color {
        if isCountingDown {
            return .orange
        } else if isRecording {
            return .red
        } else {
            return .secondary
        }
    }

    private var statusText: String {
        if isCountingDown {
            return "准备录制"
        } else if isRecording {
            return "正在录制"
        } else {
            return "待机中"
        }
    }
}

// 倒计时显示组件
struct CountdownView: View {
    let countdownValue: Int

    var body: some View {
        VStack(spacing: 20) {
            Text("倒计时")
                .font(.headline)
                .foregroundColor(.orange)

            Text("\(countdownValue)")
                .font(.system(size: 80, weight: .bold, design: .rounded))
                .foregroundColor(.orange)
                .scaleEffect(1.2)
                .animation(.easeInOut(duration: 0.3), value: countdownValue)
        }
        .padding()
        .background(Color.orange.opacity(0.1))
        .cornerRadius(20)
    }
}

// 传感器数据显示组件
struct SensorDataView: View {
    let snapshot: FlightDataSnapshot
    
    var body: some View {
        VStack(spacing: 15) {
            Text("实时传感器数据")
                .font(.headline)
                .padding(.bottom, 10)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 15) {
                DataCard(title: "速度", value: String(format: "%.2f", snapshot.speed), unit: "m/s²")
                DataCard(title: "俯仰角", value: String(format: "%.1f", snapshot.pitch), unit: "°")
                DataCard(title: "横滚角", value: String(format: "%.1f", snapshot.roll), unit: "°")
                DataCard(title: "偏航角", value: String(format: "%.1f", snapshot.yaw), unit: "°")
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

// 数据卡片组件
struct DataCard: View {
    let title: String
    let value: String
    let unit: String
    
    var body: some View {
        VStack {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(value)
                .font(.title2)
                .fontWeight(.semibold)
            Text(unit)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(8)
    }
}

// 录制控制按钮组件
struct RecordingControlButton: View {
    let isRecording: Bool
    let isCountingDown: Bool
    let onStart: () -> Void
    let onStop: () -> Void

    var body: some View {
        Button(action: {
            if isRecording || isCountingDown {
                onStop()
            } else {
                onStart()
            }
        }) {
            HStack {
                Image(systemName: buttonIcon)
                    .font(.title2)
                Text(buttonText)
                    .font(.headline)
            }
            .foregroundColor(Color(.systemBackground))
            .padding(.horizontal, 30)
            .padding(.vertical, 15)
            .background(buttonColor)
            .cornerRadius(25)
        }
    }

    private var buttonIcon: String {
        if isCountingDown {
            return "xmark.circle.fill"
        } else if isRecording {
            return "stop.circle.fill"
        } else {
            return "record.circle"
        }
    }

    private var buttonText: String {
        if isCountingDown {
            return "取消"
        } else if isRecording {
            return "停止录制"
        } else {
            return "开始录制"
        }
    }

    private var buttonColor: Color {
        if isCountingDown {
            return .orange
        } else if isRecording {
            return .red
        } else {
            return .blue
        }
    }
}

#Preview {
    FlightRecordingView()
        .modelContainer(for: FlightData.self, inMemory: true)
}

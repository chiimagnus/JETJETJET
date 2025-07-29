//
//  FlightRecordingView.swift
//  JETJETJET
//
//  Created by chii_magnus on 2025/7/29.
//

import SwiftUI
import SwiftData

struct FlightRecordingView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = FlightRecordingVM()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // 标题
                Text("JETJETJET")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                // 状态指示器
                StatusIndicatorView(isRecording: viewModel.isRecording)
                
                // 传感器数据显示
                if let snapshot = viewModel.currentSnapshot {
                    SensorDataView(snapshot: snapshot)
                } else {
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
                
                Spacer()
                
                // 录制控制按钮
                RecordingControlButton(
                    isRecording: viewModel.isRecording,
                    onStart: { viewModel.startRecording() },
                    onStop: { viewModel.stopRecording() }
                )
                
                // 错误信息
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("飞行记录")
            .navigationBarTitleDisplayMode(.inline)
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
}

// 状态指示器组件
struct StatusIndicatorView: View {
    let isRecording: Bool
    
    var body: some View {
        HStack {
            Circle()
                .fill(isRecording ? Color.red : Color.gray)
                .frame(width: 12, height: 12)
                .scaleEffect(isRecording ? 1.2 : 1.0)
                .animation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true), value: isRecording)
            
            Text(isRecording ? "正在录制" : "待机中")
                .font(.headline)
                .foregroundColor(isRecording ? .red : .secondary)
        }
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
        .background(Color.white)
        .cornerRadius(8)
    }
}

// 录制控制按钮组件
struct RecordingControlButton: View {
    let isRecording: Bool
    let onStart: () -> Void
    let onStop: () -> Void
    
    var body: some View {
        Button(action: {
            if isRecording {
                onStop()
            } else {
                onStart()
            }
        }) {
            HStack {
                Image(systemName: isRecording ? "stop.circle.fill" : "record.circle")
                    .font(.title2)
                Text(isRecording ? "停止录制" : "开始录制")
                    .font(.headline)
            }
            .foregroundColor(.white)
            .padding(.horizontal, 30)
            .padding(.vertical, 15)
            .background(isRecording ? Color.red : Color.blue)
            .cornerRadius(25)
        }
    }
}

#Preview {
    FlightRecordingView()
        .modelContainer(for: FlightData.self, inMemory: true)
}

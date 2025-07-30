import SwiftUI

struct FlightDataDetailView: View {
    let session: FlightSession
    let flightData: [FlightData]
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel = FlightDataDetailVM()

    var body: some View {
        NavigationView {
            List {
                // 会话信息
                Section("会话信息") {
                    HStack {
                        Text("开始时间")
                        Spacer()
                        Text(viewModel.formatDateTime(session.startTime))
                            .foregroundColor(.secondary)
                    }

                    HStack {
                        Text("结束时间")
                        Spacer()
                        Text(viewModel.formatDateTime(session.endTime))
                            .foregroundColor(.secondary)
                    }

                    HStack {
                        Text("持续时间")
                        Spacer()
                        Text(session.formattedDuration)
                            .foregroundColor(.secondary)
                    }

                    HStack {
                        Text("数据点数")
                        Spacer()
                        Text("\(flightData.count) 条")
                            .foregroundColor(.secondary)
                    }
                }

                // 角度含义说明
                Section("角度说明") {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(viewModel.getAngleExplanations(), id: \.title) { explanation in
                            AngleExplanationRow(
                                title: explanation.title,
                                description: explanation.description,
                                emoji: explanation.emoji,
                                gesture: explanation.gesture
                            )
                        }
                    }
                    .padding(.vertical, 4)
                }

                // 详细数据
                Section("详细数据") {
                    ForEach(Array(flightData.enumerated()), id: \.offset) { index, data in
                        FlightDataDetailRow(data: data, index: index + 1, viewModel: viewModel)
                    }
                }
            }
            .navigationTitle("数据详情")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("完成") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct AngleExplanationRow: View {
    let title: String
    let description: String
    let emoji: String
    let gesture: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text(emoji)
                .font(.title2)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.headline)
                
                Text(description)
                    .font(.body)
                    .foregroundColor(.primary)
                
                Text("类似: \(gesture)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
    }
}

struct FlightDataDetailRow: View {
    let data: FlightData
    let index: Int
    let viewModel: FlightDataDetailVM

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("#\(index)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .frame(width: 30, alignment: .leading)

                Spacer()

                Text(viewModel.formatTime(data.timestamp))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 8) {
                DataDetailCard(title: "速度", value: data.speed, unit: "m/s²", color: .blue, viewModel: viewModel)
                DataDetailCard(title: "俯仰角", value: data.pitch, unit: "°", color: .green, viewModel: viewModel)
                DataDetailCard(title: "横滚角", value: data.roll, unit: "°", color: .orange, viewModel: viewModel)
                DataDetailCard(title: "偏航角", value: data.yaw, unit: "°", color: .purple, viewModel: viewModel)
            }
        }
        .padding(.vertical, 4)
    }
}

struct DataDetailCard: View {
    let title: String
    let value: Double
    let unit: String
    let color: Color
    let viewModel: FlightDataDetailVM

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.caption2)
                .foregroundColor(.secondary)

            HStack(alignment: .firstTextBaseline, spacing: 2) {
                Text(viewModel.formatValue(value))
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(color)

                Text(unit)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(8)
        .background(color.opacity(0.1))
        .cornerRadius(6)
    }
}

#Preview {
    let session = FlightSession(startTime: Date(), endTime: Date().addingTimeInterval(60), dataCount: 3)
    let sampleData = [
        FlightData(timestamp: Date(), speed: 1.2, pitch: 15.0, roll: -5.0, yaw: 30.0),
        FlightData(timestamp: Date().addingTimeInterval(1), speed: 1.5, pitch: 10.0, roll: 2.0, yaw: 25.0),
        FlightData(timestamp: Date().addingTimeInterval(2), speed: 0.8, pitch: 5.0, roll: -8.0, yaw: 35.0)
    ]

    return FlightDataDetailView(session: session, flightData: sampleData)
}

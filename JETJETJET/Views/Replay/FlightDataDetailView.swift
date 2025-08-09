import SwiftUI

struct FlightDataDetailView: View {
    let session: FlightSession
    let flightData: [FlightData]
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel = FlightDataDetailVM()

    var body: some View {
        ZStack {
            NavigationView {
                ScrollView {
                    LazyVStack(spacing: 20) {
                        // 会话信息卡片
                        sessionInfoCard

                        // 角度说明卡片
                        angleExplanationCard

                        // 详细数据卡片
                        flightDataCard
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
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

    // MARK: - 会话信息卡片
    private var sessionInfoCard: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Image(systemName: "info.circle.fill")
                        .font(.title2)
                        .foregroundColor(.blue)

                    Text("会话信息")
                        .font(.system(.title3, design: .rounded, weight: .bold))
                        .foregroundColor(.white)

                    Spacer()
                }

                VStack(spacing: 12) {
                    InfoRow(title: "开始时间", value: viewModel.formatDateTime(session.startTime))
                    InfoRow(title: "结束时间", value: viewModel.formatDateTime(session.endTime))
                    InfoRow(title: "持续时间", value: session.formattedDuration)
                    InfoRow(title: "数据点数", value: "\(flightData.count) 条")
                }
            }
            .padding(20)
        }
    }

    // MARK: - 角度说明卡片
    private var angleExplanationCard: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Image(systemName: "gyroscope")
                        .font(.title2)
                        .foregroundColor(.orange)

                    Text("角度说明")
                        .font(.system(.title3, design: .rounded, weight: .bold))
                        .foregroundColor(.white)

                    Spacer()
                }

                VStack(alignment: .leading, spacing: 12) {
                    ForEach(viewModel.getAngleExplanations(), id: \.title) { explanation in
                        // 直接内联角度说明行，无需单独组件
                        HStack(alignment: .top, spacing: 12) {
                            Text(explanation.emoji)
                                .font(.title2)

                            VStack(alignment: .leading, spacing: 2) {
                                Text(explanation.title)
                                    .font(.headline)

                                Text(explanation.description)
                                    .font(.body)
                                    .foregroundColor(.primary)

                                Text("类似: \(explanation.gesture)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }

                            Spacer()
                        }
                    }
                }
            }
            .padding(20)
        }
    }

    // MARK: - 详细数据卡片 (直接内联HUD样式数据行)
    private var flightDataCard: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .font(.title2)
                        .foregroundColor(.green)

                    Text("详细数据")
                        .font(.system(.title3, design: .rounded, weight: .bold))
                        .foregroundColor(.white)

                    Spacer()

                    Text("\(flightData.count) 条")
                        .font(.system(.caption, design: .rounded))
                        .foregroundColor(.gray)
                }

                LazyVStack(spacing: 16) {
                    ForEach(Array(flightData.enumerated()), id: \.offset) { index, data in
                        // 直接内联HUD样式数据行，无需单独组件
                        VStack(spacing: 12) {
                            // 时间戳和索引
                            HStack {
                                Text("#\(index + 1)")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                    .fontWeight(.medium)
                                    .tracking(1)

                                Spacer()

                                Text(viewModel.formatTime(data.timestamp))
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                    .monospacedDigit()
                            }

                            // 复用HUDDataBarView的数据显示逻辑
                            HUDDataBarView(snapshot: FlightDataSnapshot(
                                timestamp: data.timestamp,
                                acceleration: data.acceleration,
                                speed: data.speed,
                                pitch: data.pitch,
                                roll: data.roll,
                                yaw: data.yaw
                            ))
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white.opacity(0.05))
                        )
                    }
                }
            }
            .padding(20)
        }
    }
}

// MARK: - 信息行组件
struct InfoRow: View {
    let title: String
    let value: String

    var body: some View {
        HStack {
            Text(title)
                .font(.system(.body, design: .rounded))
                .foregroundColor(.white)
            Spacer()
            Text(value)
                .font(.system(.body, design: .rounded, weight: .medium))
                .foregroundColor(.cyan)
        }
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
        .environment(LightSourceSettings())
}

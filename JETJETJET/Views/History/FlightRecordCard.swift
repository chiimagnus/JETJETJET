import SwiftUI

struct FlightRecordCard: View {
    let session: FlightSession
    let viewModel: FlightHistoryVM

    var body: some View {
        let stats = viewModel.getFlightStats(for: session)

        NavigationLink(destination: AirplaneModelView(session: session)) {
            ZStack {
                // 登机牌背景
                BoardingPassBackground()

                VStack(spacing: 0) {
                // 上半部分：航班信息
                VStack(spacing: 8) {
                    // 日期和状态行
                    HStack {
                        Text(formatChineseDate(session.startTime))
                            .font(.system(.body, design: .rounded, weight: .semibold))
                            .foregroundColor(.white)

                        Spacer()

                        // 飞行状态指示器
                        FlightStatusIndicator()
                    }

                    // 飞行路径
                    HStack {
                        // 起点代码
                        Text("JET")
                            .font(.system(.title, design: .rounded, weight: .black))
                            .foregroundColor(.white)
                            .shadow(color: Color(red: 0, green: 0.83, blue: 1).opacity(0.6), radius: 2)

                        // 飞行路径线
                        ZStack {
                            Rectangle()
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            Color(red: 0, green: 0.83, blue: 1),
                                            Color(red: 0, green: 1, blue: 0.53)
                                        ],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(height: 2)

                            // 飞机图标
                            Image(systemName: "airplane")
                                .font(.system(.body, weight: .bold))
                                .foregroundColor(Color(red: 0, green: 0.83, blue: 1))
                                .offset(x: 20) // 稍微偏右

                            // 终点圆点
                            Circle()
                                .fill(Color(red: 0, green: 1, blue: 0.53))
                                .frame(width: 8, height: 8)
                                .shadow(color: Color(red: 0, green: 1, blue: 0.53).opacity(0.6), radius: 4)
                                .offset(x: 50)
                        }
                        .frame(maxWidth: .infinity)

                        // 终点代码
                        Text("SKY")
                            .font(.system(.title, design: .rounded, weight: .black))
                            .foregroundColor(.white)
                            .shadow(color: Color(red: 0, green: 0.83, blue: 1).opacity(0.6), radius: 2)
                    }

                    // 城市名称和飞行时间
                    HStack {
                        Text("起飞点")
                            .font(.system(.caption, design: .rounded))
                            .foregroundColor(.gray)

                        Spacer()

                        Text(session.formattedDuration)
                            .font(.system(.body, design: .rounded, weight: .bold))
                            .foregroundColor(Color(red: 0, green: 0.83, blue: 1))
                            .shadow(color: Color(red: 0, green: 0.83, blue: 1).opacity(0.6), radius: 2)

                        Spacer()

                        Text("降落点")
                            .font(.system(.caption, design: .rounded))
                            .foregroundColor(.gray)
                    }
                }
                .padding(.bottom, 12)

                // 虚线分隔
                DashedDivider()

                // 下半部分：飞行数据
                HStack(spacing: 6) {
                    // Max Pitch
                    FlightDataItem(
                        label: "Max Pitch",
                        value: stats.formattedMaxPitch,
                        color: Color(red: 0, green: 0.83, blue: 1)
                    )

                    // Max Roll
                    FlightDataItem(
                        label: "Max Roll",
                        value: stats.formattedMaxRoll,
                        color: Color(red: 0, green: 1, blue: 0.53)
                    )

                    // Max Yaw
                    FlightDataItem(
                        label: "Max Yaw",
                        value: stats.formattedMaxYaw,
                        color: Color(red: 1, green: 0.42, blue: 0.21)
                    )

                    // Max Speed
                    FlightDataItem(
                        label: "Max Speed",
                        value: stats.formattedMaxSpeed,
                        color: Color(red: 0.55, green: 0.36, blue: 0.96)
                    )
                }
                .padding(.top, 16)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
            }
            .frame(width: 350, height: 200) // 固定卡片尺寸
        }
        .buttonStyle(PlainButtonStyle()) // 移除默认的按钮样式
    }

    private func formatChineseDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年M月d日"
        return formatter.string(from: date)
    }
}

// MARK: - 登机牌背景组件
struct BoardingPassBackground: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(Color.white.opacity(0.05))
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.ultraThinMaterial)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
            )
            .mask(
                // 创建半圆缺口效果
                RoundedRectangle(cornerRadius: 20)
                    .overlay(
                        HStack {
                            Circle()
                                .frame(width: 24, height: 24)
                                .offset(x: -12)

                            Spacer()

                            Circle()
                                .frame(width: 24, height: 24)
                                .offset(x: 12)
                        }
                        .offset(y: 23)
                        .blendMode(.destinationOut)
                    )
            )
            .shadow(color: Color.black.opacity(0.3), radius: 8, x: 0, y: 4)
            .overlay(
                // 悬停时的霓虹边框效果
                RoundedRectangle(cornerRadius: 20)
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color(red: 0, green: 0.83, blue: 1),
                                Color(red: 0, green: 1, blue: 0.53),
                                Color(red: 0.55, green: 0.36, blue: 0.96)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 2
                    )
                    .opacity(0)
            )
    }
}

// MARK: - 虚线分隔组件
struct DashedDivider: View {
    var body: some View {
        Rectangle()
            .fill(Color.clear)
            .frame(height: 1)
            .overlay(
                Rectangle()
                    .fill(Color.white.opacity(0.4))
                    .frame(height: 1)
                    .mask(
                        HStack(spacing: 8) {
                            ForEach(0..<20, id: \.self) { _ in
                                Rectangle()
                                    .frame(width: 8, height: 1)
                            }
                        }
                    )
            )
    }
}

// MARK: - 飞行数据项组件
struct FlightDataItem: View {
    let label: String
    let value: String
    let color: Color

    var body: some View {
        VStack(spacing: 2) {
            Text(label.uppercased())
                .font(.system(.caption2, design: .rounded, weight: .medium))
                .foregroundColor(.gray)
                .tracking(0.5)
                .lineLimit(1)
                .minimumScaleFactor(0.8)

            Text(value)
                .font(.system(.callout, design: .rounded, weight: .bold))
                .foregroundColor(color)
                .shadow(color: color.opacity(0.6), radius: 1)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 6)
        .padding(.horizontal, 4)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white.opacity(0.03))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
        )
    }
}

#Preview {
    ZStack {
        // 星空背景
        Color.black
            .ignoresSafeArea()

        VStack(spacing: 20) {
            FlightRecordCard(
                session: FlightSession(
                    startTime: Date(),
                    endTime: Date().addingTimeInterval(154),
                    dataCount: 100
                ),
                viewModel: FlightHistoryVM()
            )

            FlightRecordCard(
                session: FlightSession(
                    startTime: Date().addingTimeInterval(-3600),
                    endTime: Date().addingTimeInterval(-3400),
                    dataCount: 200
                ),
                viewModel: FlightHistoryVM()
            )
        }
        .padding()
    }
    .preferredColorScheme(.dark)
}

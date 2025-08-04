import SwiftUI

struct FlightRecordCard: View {
    let session: FlightSession
    let viewModel: FlightHistoryVM
    @State private var isHovered = false
    @State private var isPressed = false

    var body: some View {
        let stats = viewModel.getFlightStats(for: session)

        VStack(spacing: 16) {
            // 日期和状态行
            HStack {
                HStack(spacing: 12) {
                    Text("📅")
                        .font(.title2)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(formatDate(session.startTime))
                            .font(.system(.body, design: .rounded, weight: .semibold))
                            .foregroundColor(.white)
                        
                        Text(formatTime(session.startTime))
                            .font(.system(.caption, design: .rounded))
                            .foregroundColor(.gray)
                    }
                }
                
                Spacer()
                
                // 飞行状态指示器
                FlightStatusIndicator()
            }
                
            // 飞行时长和描述
            HStack(spacing: 16) {
                HStack(spacing: 8) {
                    Text("⏱️")
                        .font(.body)
                    Text(session.formattedDuration)
                        .font(.system(.body, design: .rounded, weight: .bold))
                        .foregroundColor(Color(red: 0, green: 0.83, blue: 1)) // 霓虹青色
                        .shadow(color: Color(red: 0, green: 0.83, blue: 1).opacity(0.6), radius: 2) // 发光效果
                }
                
                HStack(spacing: 8) {
                    Text("🛫")
                        .font(.body)
                    Text(session.flightDescription)
                        .font(.system(.caption, design: .rounded))
                        .foregroundColor(.gray)
                }
                
                Spacer()
            }
                
            // 数据标签网格
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 4), spacing: 12) {
                DataTag(value: stats.formattedMaxSpeed, label: "Max Speed", color: Color(red: 0, green: 0.83, blue: 1)) // 霓虹青色
                DataTag(value: stats.formattedMaxPitch, label: "Max Pitch", color: Color(red: 0, green: 1, blue: 0.53)) // 霓虹绿色
                DataTag(value: stats.formattedMaxRoll, label: "Max Roll", color: Color(red: 1, green: 0.42, blue: 0.21)) // 霓虹橙色
                DataTag(value: stats.formattedMaxG, label: "Max G", color: Color(red: 0.55, green: 0.36, blue: 0.96)) // 霓虹紫色
            }
                
            // 回放按钮
            ReplayButton {
                // 回放动作
                print("回放飞行记录: \(session.id)")
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            isHovered || isPressed ?
                            Color(red: 0, green: 0.83, blue: 1) : // 霓虹青色
                            Color.white.opacity(0.1),
                            lineWidth: isHovered || isPressed ? 1.5 : 1
                        )
                )
                .shadow(
                    color: isHovered || isPressed ?
                    Color(red: 0, green: 0.83, blue: 1).opacity(0.4) : // 霓虹青色发光
                    Color.black.opacity(0.3),
                    radius: isHovered || isPressed ? 16 : 8,
                    x: 0,
                    y: isHovered || isPressed ? 8 : 4
                )
        )
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .onHover { hovering in
            isHovered = hovering
        }
        .onTapGesture {
            // 简化的点击反馈效果
            isPressed = true
            HapticService.shared.light()

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isPressed = false
            }
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
    

}

#Preview {
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
    .background(Color.black)
    .preferredColorScheme(.dark)
}

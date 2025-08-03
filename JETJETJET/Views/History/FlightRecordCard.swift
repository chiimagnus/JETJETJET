import SwiftUI

struct FlightRecordCard: View {
    let session: FlightSession
    @State private var isHovered = false
    
    var body: some View {
        VStack(spacing: 0) {
            // 顶部彩色渐变条
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [.cyan, .green, .purple],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 3)
                .opacity(isHovered ? 1 : 0)
                .animation(.easeInOut(duration: 0.3), value: isHovered)
            
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
                            .foregroundColor(.cyan)
                    }
                    
                    HStack(spacing: 8) {
                        Text("🛫")
                            .font(.body)
                        Text(getFlightDescription())
                            .font(.system(.caption, design: .rounded))
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                }
                
                // 数据标签网格
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 4), spacing: 12) {
                    DataTag(value: "15.2", label: "Max Speed", color: .cyan)
                    DataTag(value: "45°", label: "Max Pitch", color: .green)
                    DataTag(value: "30°", label: "Max Roll", color: .orange)
                    DataTag(value: "3.2G", label: "Max G", color: .purple)
                }
                
                // 回放按钮
                ReplayButton {
                    // 回放动作
                    print("回放飞行记录: \(session.id)")
                }
            }
            .padding(20)
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            isHovered ? Color.cyan : Color.white.opacity(0.1),
                            lineWidth: 1
                        )
                )
                .shadow(
                    color: isHovered ? Color.cyan.opacity(0.2) : Color.black.opacity(0.3),
                    radius: isHovered ? 12 : 8,
                    x: 0,
                    y: isHovered ? 8 : 4
                )
        )
        .scaleEffect(isHovered ? 1.02 : 1.0)
        .offset(y: isHovered ? -4 : 0)
        .animation(.easeInOut(duration: 0.3), value: isHovered)
        .onHover { hovering in
            isHovered = hovering
        }
        .onTapGesture {
            // 模拟悬停效果
            withAnimation(.easeInOut(duration: 0.15)) {
                isHovered = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                withAnimation(.easeInOut(duration: 0.15)) {
                    isHovered = false
                }
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
    
    private func getFlightDescription() -> String {
        // 根据飞行时长和数据量生成描述
        let duration = session.duration
        if duration > 180 { // 3分钟以上
            return "激烈机动"
        } else if duration > 120 { // 2分钟以上
            return "精彩飞行"
        } else {
            return "平稳飞行"
        }
    }
}

// FlightStatusIndicator 已移动到单独的文件中

#Preview {
    VStack(spacing: 20) {
        FlightRecordCard(session: FlightSession(
            startTime: Date(),
            endTime: Date().addingTimeInterval(154),
            dataCount: 100
        ))
        
        FlightRecordCard(session: FlightSession(
            startTime: Date().addingTimeInterval(-3600),
            endTime: Date().addingTimeInterval(-3400),
            dataCount: 200
        ))
    }
    .padding()
    .background(Color.black)
    .preferredColorScheme(.dark)
}

import SwiftUI

struct InstrumentPanelView: View {
    let snapshot: FlightDataSnapshot?
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 4), spacing: 12) {
            InstrumentView(
                icon: "⬆️",
                value: String(format: "%.0f°", snapshot?.pitch ?? 0),
                label: "PITCH",
                color: .cyan
            )
            
            InstrumentView(
                icon: "🔄",
                value: String(format: "%.0f°", snapshot?.roll ?? 0),
                label: "ROLL",
                color: .green
            )
            
            InstrumentView(
                icon: "↔️",
                value: String(format: "%.0f°", snapshot?.yaw ?? 0),
                label: "YAW",
                color: .purple
            )
            
            InstrumentView(
                icon: "⚡",
                value: String(format: "%.0f", snapshot?.speed ?? 0),
                label: "SPEED",
                color: .orange
            )
        }
    }
}

struct InstrumentView: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    
    @State private var isAnimating = false
    
    var body: some View {
        GlassCard {
            VStack(spacing: 8) {
                // 图标
                Text(icon)
                    .font(.title2)
                    .scaleEffect(isAnimating ? 1.1 : 1.0)
                
                // 数值
                Text(value)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(color)
                    .shadow(color: color.opacity(0.5), radius: 8)
                    .monospacedDigit()
                
                // 标签
                Text(label)
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                    .tracking(1)
                
                // HUD风格进度条
                HUDProgressBar(color: color)
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 8)
        }
        .onAppear {
            withAnimation(
                .easeInOut(duration: 2.0)
                .repeatForever(autoreverses: true)
            ) {
                isAnimating = true
            }
        }
    }
}

struct HUDProgressBar: View {
    let color: Color
    @State private var animationOffset: CGFloat = 0
    
    var body: some View {
        ZStack(alignment: .leading) {
            // 背景条
            RoundedRectangle(cornerRadius: 2)
                .fill(color.opacity(0.2))
                .frame(height: 4)
            
            // 进度条
            RoundedRectangle(cornerRadius: 2)
                .fill(
                    LinearGradient(
                        colors: [color, color.opacity(0.3)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 4)
                .mask(
                    RoundedRectangle(cornerRadius: 2)
                        .frame(width: 30)
                        .offset(x: animationOffset)
                )
        }
        .onAppear {
            withAnimation(
                .linear(duration: 1.5)
                .repeatForever(autoreverses: false)
            ) {
                animationOffset = 60
            }
        }
    }
}

#Preview {
    InstrumentPanelView(snapshot: FlightDataSnapshot(
        timestamp: Date(),
        speed: 120.5,
        pitch: 15.5,
        roll: -8.2,
        yaw: 45.0
    ))
    .preferredColorScheme(.dark)
    .padding()
}

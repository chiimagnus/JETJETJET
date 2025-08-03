import SwiftUI

struct KeyMetricsView: View {
    let snapshot: FlightDataSnapshot?
    @State private var batteryLevel: Int = 89
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 4), spacing: 12) {
            // G力指标
            MetricCard(
                value: String(format: "%.1f", calculateGForce()),
                unit: "G",
                color: .green,
                isActive: true
            )
            
            // 速度指标 (转换为KMH)
            MetricCard(
                value: String(format: "%.0f", (snapshot?.speed ?? 0) * 3.6),
                unit: "KMH",
                color: .blue,
                isActive: snapshot != nil
            )
            
            // 电池指标
            MetricCard(
                value: "\(batteryLevel)%",
                unit: "BAT",
                color: batteryLevel > 20 ? .green : .red,
                isActive: true
            )
            
            // GPS状态
            MetricCard(
                value: "GPS",
                unit: "ON",
                color: .green,
                isActive: true
            )
        }
    }
    
    private func calculateGForce() -> Double {
        // 简化的G力计算，基于速度变化
        guard let snapshot = snapshot else { return 0.0 }
        return max(0.5, min(5.0, abs(snapshot.speed) / 10.0 + 1.0))
    }
}

struct MetricCard: View {
    let value: String
    let unit: String
    let color: Color
    let isActive: Bool
    
    @State private var isAnimating = false
    
    var body: some View {
        GlassCard {
            VStack(spacing: 8) {
                // 数值
                Text(value)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(isActive ? color : .gray)
                    .shadow(color: isActive ? color.opacity(0.5) : .clear, radius: 6)
                    .monospacedDigit()
                    .scaleEffect(isAnimating ? 1.05 : 1.0)
                
                // 单位
                Text(unit)
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                    .tracking(1)
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 8)
        }
        .opacity(isActive ? 1.0 : 0.6)
        .onAppear {
            if isActive {
                withAnimation(
                    .easeInOut(duration: 2.0)
                    .repeatForever(autoreverses: true)
                ) {
                    isAnimating = true
                }
            }
        }
    }
}

struct StopRecordingButtonView: View {
    let action: () -> Void
    
    @State private var isPressed = false
    @State private var glowIntensity: Double = 0.5
    
    var body: some View {
        Button(action: {
            // 使用统一的震动服务 - 重要操作使用重度震动
            HapticService.shared.heavy()
            action()
        }) {
            HStack(spacing: 12) {
                Image(systemName: "stop.fill")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text("STOP FLIGHT")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .tracking(1)
            }
            .foregroundColor(isPressed ? .black : .red)
            .padding(.horizontal, 32)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(isPressed ? Color.red : Color.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.red, lineWidth: 2)
                    )
            )
            .shadow(color: Color.red.opacity(glowIntensity), radius: isPressed ? 20 : 10)
            .scaleEffect(isPressed ? 0.95 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
        .onAppear {
            withAnimation(
                .easeInOut(duration: 2.0)
                .repeatForever(autoreverses: true)
            ) {
                glowIntensity = 1.0
            }
        }
    }
}

#Preview {
    VStack(spacing: 30) {
        KeyMetricsView(snapshot: FlightDataSnapshot(
            timestamp: Date(),
            speed: 120.5,
            pitch: 15.5,
            roll: -8.2,
            yaw: 45.0
        ))
        
        StopRecordingButtonView {
            print("Stop recording")
        }
    }
    .preferredColorScheme(.dark)
    .padding()
}

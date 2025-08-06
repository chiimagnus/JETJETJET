import SwiftUI

struct HUDDataBarView: View {
    let snapshot: FlightDataSnapshot?
    private let userPreferences = UserPreferences.shared

    var body: some View {
        VStack(spacing: 16) {
            // HUD数据条 - 飞行数据
            HStack(spacing: 12) {
                HUDDataItem(
                    label: "PITCH",
                    value: String(format: "%.0f°", snapshot?.pitch ?? 0),
                    progress: normalizedProgress(snapshot?.pitch ?? 0, range: -90...90),
                    color: .green
                )

                HUDDataItem(
                    label: "ROLL",
                    value: String(format: "%.0f°", snapshot?.roll ?? 0),
                    progress: normalizedProgress(snapshot?.roll ?? 0, range: -90...90),
                    color: .blue
                )

                HUDDataItem(
                    label: "YAW",
                    value: String(format: "%.0f°", snapshot?.yaw ?? 0),
                    progress: normalizedProgress(snapshot?.yaw ?? 0, range: -180...180),
                    color: .purple
                )

                // 根据用户设置显示加速度或速度
                HUDDataItem(
                    label: userPreferences.dataDisplayType == .acceleration ? "ACCEL" : "SPEED",
                    value: userPreferences.dataDisplayType == .acceleration ?
                        String(format: "%.2f", snapshot?.acceleration ?? 0) :
                        String(format: "%.1f", snapshot?.speed ?? 0),
                    progress: userPreferences.dataDisplayType == .acceleration ?
                        normalizedProgress(snapshot?.acceleration ?? 0, range: 0...30) :
                        normalizedProgress(snapshot?.speed ?? 0, range: 0...50),
                    color: .orange
                )
            }
        }
    }
    
    private func normalizedProgress(_ value: Double, range: ClosedRange<Double>) -> Double {
        let normalizedValue = (value - range.lowerBound) / (range.upperBound - range.lowerBound)
        return max(0, min(1, normalizedValue))
    }


}

struct HUDDataItem: View {
    let label: String
    let value: String
    let progress: Double
    let color: Color

    @State private var animatedProgress: Double = 0
    
    var body: some View {
        VStack(spacing: 8) {
            // 标签和数值
            HStack {
                Text(label)
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .fontWeight(.medium)
                    .tracking(1)

                Spacer()

                Text(value)
                    .font(.caption)
                    .foregroundColor(color)
                    .fontWeight(.bold)
                    .monospacedDigit()
            }

            // 进度条
            HUDProgressBarView(progress: animatedProgress, color: color)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.5)) {
                animatedProgress = progress
            }
        }
        .onChange(of: progress) { _, newValue in
            withAnimation(.easeInOut(duration: 0.3)) {
                animatedProgress = newValue
            }
        }
    }
}

struct HUDProgressBarView: View {
    let progress: Double
    let color: Color
    
    @State private var glowIntensity: Double = 0.5
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // 背景条
                RoundedRectangle(cornerRadius: 3)
                    .fill(Color.white.opacity(0.1))
                    .frame(height: 6)
                
                // 进度条
                RoundedRectangle(cornerRadius: 3)
                    .fill(
                        LinearGradient(
                            colors: [color, color.opacity(0.6)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: geometry.size.width * progress, height: 6)
                    .shadow(color: color.opacity(glowIntensity), radius: 4)
                    .animation(.easeInOut(duration: 0.3), value: progress)
            }
        }
        .frame(height: 6)
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
    VStack(spacing: 20) {
        HUDDataBarView(snapshot: FlightDataSnapshot(
            timestamp: Date(),
            acceleration: 9.8,
            speed: 25.5,
            pitch: 45.0,
            roll: 12.0,
            yaw: -3.0
        ))

        HUDDataBarView(snapshot: nil)
    }
    .preferredColorScheme(.dark)
    .padding()
}

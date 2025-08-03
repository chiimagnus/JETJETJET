import SwiftUI

struct MainStatusIndicatorView: View {
    var body: some View {
        HStack(spacing: 12) {
            // 状态点 - 始终显示准备状态
            StatusDotView()

            // 状态文本 - 始终显示准备状态
            StatusTextView()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(
            Capsule()
                .fill(.ultraThinMaterial)
                .overlay(
                    Capsule()
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
        )
    }
}

struct StatusDotView: View {
    @State private var isPulsing = false

    var body: some View {
        Circle()
            .fill(.green)
            .frame(width: 8, height: 8)
            .shadow(color: .green, radius: isPulsing ? 8 : 4)
            .scaleEffect(isPulsing ? 1.2 : 1.0)
            .onAppear {
                withAnimation(
                    .easeInOut(duration: 2.0)
                    .repeatForever(autoreverses: true)
                ) {
                    isPulsing = true
                }
            }
    }
}

struct StatusTextView: View {
    var body: some View {
        Text("🚀 READY")
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundColor(.green)
            .tracking(1)
    }
}

#Preview {
    VStack(spacing: 20) {
        MainStatusIndicatorView()
    }
    .preferredColorScheme(.dark)
    .padding()
}

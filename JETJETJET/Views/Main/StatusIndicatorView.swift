import SwiftUI

struct MainStatusIndicatorView: View {
    let isRecording: Bool

    var body: some View {
        HStack(spacing: 12) {
            // 状态点
            StatusDotView(isRecording: isRecording)

            // 状态文本
            StatusTextView(isRecording: isRecording)
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
    let isRecording: Bool

    @State private var isPulsing = false

    private var dotColor: Color {
        isRecording ? .red : .green
    }

    private var shouldPulse: Bool {
        isRecording
    }
    
    var body: some View {
        Circle()
            .fill(dotColor)
            .frame(width: 8, height: 8)
            .shadow(color: dotColor, radius: isPulsing ? 8 : 4)
            .scaleEffect(isPulsing ? 1.3 : 1.0)
            .onAppear {
                if shouldPulse {
                    withAnimation(
                        .easeInOut(duration: 1.0)
                        .repeatForever(autoreverses: true)
                    ) {
                        isPulsing = true
                    }
                }
            }
            .onChange(of: shouldPulse) { _, newValue in
                if newValue {
                    withAnimation(
                        .easeInOut(duration: 1.0)
                        .repeatForever(autoreverses: true)
                    ) {
                        isPulsing = true
                    }
                } else {
                    withAnimation(.easeOut(duration: 0.3)) {
                        isPulsing = false
                    }
                }
            }
    }
}

struct StatusTextView: View {
    let isRecording: Bool

    private var statusText: String {
        isRecording ? "🔴 RECORDING" : "🚀 READY"
    }

    private var textColor: Color {
        isRecording ? .red : .green
    }

    var body: some View {
        Text(statusText)
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundColor(textColor)
            .tracking(1)
    }
}

#Preview {
    VStack(spacing: 20) {
        MainStatusIndicatorView(isRecording: false)
        MainStatusIndicatorView(isRecording: true)
    }
    .preferredColorScheme(.dark)
    .padding()
}

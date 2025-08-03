import SwiftUI

struct MainStatusIndicatorView: View {
    let isRecording: Bool
    let isCountingDown: Bool
    let countdownValue: Int
    
    var body: some View {
        HStack(spacing: 12) {
            // 状态点
            StatusDotView(
                isRecording: isRecording,
                isCountingDown: isCountingDown
            )
            
            // 状态文本
            StatusTextView(
                isRecording: isRecording,
                isCountingDown: isCountingDown,
                countdownValue: countdownValue
            )
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
    let isCountingDown: Bool
    
    @State private var isPulsing = false
    
    private var dotColor: Color {
        if isRecording {
            return .red
        } else if isCountingDown {
            return .orange
        } else {
            return .green
        }
    }
    
    private var shouldPulse: Bool {
        isRecording || isCountingDown
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
    let isCountingDown: Bool
    let countdownValue: Int
    
    private var statusText: String {
        if isRecording {
            return "🔴 RECORDING"
        } else if isCountingDown {
            return "⏱️ PREPARING"
        } else {
            return "🚀 READY"
        }
    }
    
    private var textColor: Color {
        if isRecording {
            return .red
        } else if isCountingDown {
            return .orange
        } else {
            return .green
        }
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
        MainStatusIndicatorView(
            isRecording: false,
            isCountingDown: false,
            countdownValue: 0
        )

        MainStatusIndicatorView(
            isRecording: false,
            isCountingDown: true,
            countdownValue: 3
        )

        MainStatusIndicatorView(
            isRecording: true,
            isCountingDown: false,
            countdownValue: 0
        )
    }
    .preferredColorScheme(.dark)
    .padding()
}

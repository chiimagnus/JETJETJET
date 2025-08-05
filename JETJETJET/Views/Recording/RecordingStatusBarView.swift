import SwiftUI

struct RecordingStatusBarView: View {
    let isRecording: Bool

    @State private var isBlinking = false
    
    var body: some View {
        GlassCard {
            VStack(spacing: 8) {
                HStack {
                    // 主标题 - 居中显示，采用和MainView HeaderView一样的样式
                    HStack(spacing: 4) {
                        Text("✈️")
                            .font(.title2)
                        Text("J E T I N G")
                            .font(.custom("Orbitron", size: 24))
                            .fontWeight(.bold)
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.cyan, .blue],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .shadow(color: .cyan.opacity(0.5), radius: 10)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
        .overlay(
            // 录制状态边框
            RoundedRectangle(cornerRadius: 12)
                .stroke(
                    LinearGradient(
                        colors: [Color.red.opacity(0.6), Color.red.opacity(0.2)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
        .background(
            // 录制状态背景
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.red.opacity(0.05))
        )
    }
}

#Preview {
    VStack(spacing: 20) {
        RecordingStatusBarView(
            isRecording: true
        )

        RecordingStatusBarView(
            isRecording: false
        )
    }
    .preferredColorScheme(.dark)
    .padding()
}

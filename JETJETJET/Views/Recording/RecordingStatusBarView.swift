import SwiftUI

struct RecordingStatusBarView: View {
    let isRecording: Bool
    let duration: String
    
    @State private var isBlinking = false
    
    var body: some View {
        GlassCard {
            HStack {
                // 左侧标题
                HStack(spacing: 12) {
                    Text("✈️")
                        .font(.title2)
                    Text("JETING")
                        .font(.custom("Orbitron", size: 18))
                        .fontWeight(.bold)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.cyan, .blue],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .shadow(color: .cyan.opacity(0.5), radius: 8)
                }
                
                Spacer()
                
                // 右侧录制信息
                HStack(spacing: 12) {                    
                    // 时间显示
                    Text(duration)
                        .font(.system(.caption, design: .monospaced))
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.black.opacity(0.3))
                        )
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
            isRecording: true,
            duration: "01:23"
        )
        
        RecordingStatusBarView(
            isRecording: false,
            duration: "00:00"
        )
    }
    .preferredColorScheme(.dark)
    .padding()
}

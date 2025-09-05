import SwiftUI

struct CompactRecordingTimeView: View {
    let duration: String
    let isRecording: Bool
    
    @State private var isBlinking = false
    
    var body: some View {
        HStack(spacing: 6) {
            // 录制指示器
            if isRecording {
                Circle()
                    .fill(Color.red)
                    .frame(width: 6, height: 6)
                    .opacity(isBlinking ? 0.3 : 1.0)
                    .animation(
                        .easeInOut(duration: 1.0)
                        .repeatForever(autoreverses: true),
                        value: isBlinking
                    )
            }
            
            // 时长显示
            Text(duration)
                .font(.system(.caption, design: .monospaced))
                .fontWeight(.medium)
                .foregroundColor(.red)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(
            RoundedRectangle(cornerRadius: 6)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.red.opacity(0.4), lineWidth: 1)
                )
        )
        .onAppear {
            if isRecording {
                isBlinking = true
            }
        }
        .onChange(of: isRecording) { _, newValue in
            isBlinking = newValue
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        CompactRecordingTimeView(
            duration: "01:23",
            isRecording: true
        )
        
        CompactRecordingTimeView(
            duration: "00:00",
            isRecording: false
        )
        
        // 模拟在按钮旁边的效果
        HStack(spacing: 16) {
            Button("STOP") {
                // 模拟停止按钮
            }
            .padding()
            .background(Color.red)
            .foregroundColor(.white)
            .cornerRadius(8)
            
            CompactRecordingTimeView(
                duration: "02:45",
                isRecording: true
            )
        }
    }
    .preferredColorScheme(.dark)
    .padding()
}

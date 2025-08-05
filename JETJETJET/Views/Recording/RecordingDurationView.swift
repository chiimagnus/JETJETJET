import SwiftUI

struct RecordingDurationView: View {
    let duration: String
    let isRecording: Bool
    
    @State private var isBlinking = false
    
    var body: some View {
        HStack {
            Spacer()
            
            VStack(spacing: 4) {
                Text("RECORDING TIME")
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .fontWeight(.medium)
                    .tracking(1)
                
                HStack(spacing: 8) {
                    // 录制指示器
                    if isRecording {
                        Circle()
                            .fill(Color.red)
                            .frame(width: 8, height: 8)
                            .opacity(isBlinking ? 0.3 : 1.0)
                            .animation(
                                .easeInOut(duration: 1.0)
                                .repeatForever(autoreverses: true),
                                value: isBlinking
                            )
                    }
                    
                    Text(duration)
                        .font(.system(.title3, design: .monospaced))
                        .foregroundColor(.red)
                        .fontWeight(.bold)
                        .shadow(color: .red.opacity(0.5), radius: 4)
                }
            }
            
            Spacer()
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
                .overlay(
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
        )
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.red.opacity(0.05))
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
        RecordingDurationView(
            duration: "01:23",
            isRecording: true
        )
        
        RecordingDurationView(
            duration: "00:00",
            isRecording: false
        )
    }
    .preferredColorScheme(.dark)
    .padding()
}

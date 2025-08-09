import SwiftUI

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
                
                Text(NSLocalizedString("stop_recording_button_title", comment: "Stop recording button title"))
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
        StopRecordingButtonView {
            print("Stop recording")
        }
        
        StopRecordingButtonView {
            print("Another stop button")
        }
    }
    .preferredColorScheme(.dark)
    .padding()
    .background(Color.black)
}

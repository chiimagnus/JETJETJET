import SwiftUI

struct ReplayButton: View {
    let action: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            // 使用统一的震动服务
            HapticService.shared.medium()

            // 按压动画
            withAnimation(.easeInOut(duration: 0.15)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                withAnimation(.easeInOut(duration: 0.15)) {
                    isPressed = false
                }
            }
            action()
        }) {
            HStack(spacing: 8) {
                Image(systemName: "play.fill")
                    .font(.system(.body, weight: .semibold))
                
                Text("REPLAY")
                    .font(.system(.body, design: .rounded, weight: .bold))
                    .tracking(1)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        LinearGradient(
                            colors: [.purple, .cyan],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(
                        color: .purple.opacity(0.4),
                        radius: isPressed ? 4 : 8,
                        x: 0,
                        y: isPressed ? 2 : 4
                    )
            )
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: isPressed)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    VStack(spacing: 20) {
        ReplayButton {
            print("回放按钮被点击")
        }
        
        ReplayButton {
            print("另一个回放按钮")
        }
        .disabled(true)
    }
    .padding()
    .background(Color.black)
    .preferredColorScheme(.dark)
}

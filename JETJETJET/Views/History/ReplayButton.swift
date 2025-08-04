import SwiftUI

struct ReplayButton: View {
    let action: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            // 使用统一的震动服务
            HapticService.shared.medium()

            // 简化的按压反馈
            isPressed = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isPressed = false
            }
            action()
        }) {
            HStack(spacing: 8) {
                Image(systemName: "play.fill")
                    .font(.system(.body, weight: .semibold))
                
                Text("REJET")
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
                            colors: [
                                Color(red: 0.55, green: 0.36, blue: 0.96), // 霓虹紫色 #8b5cf6
                                Color(red: 0, green: 0.83, blue: 1) // 霓虹青色 #00d4ff
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(
                        color: Color(red: 0.55, green: 0.36, blue: 0.96).opacity(0.6), // 增强紫色发光
                        radius: isPressed ? 6 : 12,
                        x: 0,
                        y: isPressed ? 2 : 4
                    )
                    .shadow(
                        color: Color(red: 0, green: 0.83, blue: 1).opacity(0.4), // 青色发光
                        radius: isPressed ? 4 : 8,
                        x: 0,
                        y: 0
                    )
            )
            .scaleEffect(isPressed ? 0.95 : 1.0)
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

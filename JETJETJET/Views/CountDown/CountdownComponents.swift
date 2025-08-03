import SwiftUI

// MARK: - 手机位置指示器
struct PhonePositionIndicator: View { 
    var body: some View {
        Text("手机顶部指向飞行方向")
            .font(.system(.caption, design: .rounded))
            .foregroundColor(.gray)
    }
}

// MARK: - 准备状态指示器
struct PreparationStatusView: View {
    @State private var rotationAngle: Double = 0
    
    var body: some View {
        GlassCard {
            HStack(spacing: 16) {
                // 旋转环
                ZStack {
                    Circle()
                        .stroke(Color.orange.opacity(0.3), lineWidth: 3)
                        .frame(width: 60, height: 60)
                    
                    Circle()
                        .trim(from: 0, to: 0.25)
                        .stroke(Color.orange, lineWidth: 3)
                        .frame(width: 60, height: 60)
                        .rotationEffect(.degrees(rotationAngle))
                }
                
                // 状态文字
                VStack(alignment: .leading, spacing: 4) {
                    Text("系统准备中...")
                        .font(.system(.body, design: .rounded, weight: .bold))
                        .foregroundColor(.orange)
                    
                    Text("传感器校准")
                        .font(.system(.caption, design: .rounded))
                        .foregroundColor(.gray)
                }
                
                Spacer()
            }
            .padding(.vertical, 8)
        }
        .onAppear {
            withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: false)) {
                rotationAngle = 360
            }
        }
    }
}

// MARK: - 取消按钮
struct AbortButton: View {
    let action: () -> Void
    @State private var isPressed = false
    @State private var glowIntensity: Double = 0.5
    
    var body: some View {
        Button(action: {
            HapticService.shared.warning()
            action()
        }) {
            HStack(spacing: 12) {
                Image(systemName: "xmark")
                    .font(.system(.title3, weight: .bold))
                
                Text("ABORT")
                    .font(.system(.title3, design: .rounded, weight: .bold))
                    .tracking(2)
            }
            .foregroundColor(isPressed ? .black : .orange)
            .padding(.horizontal, 32)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(isPressed ? Color.orange : Color.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.orange, lineWidth: 2)
                    )
            )
            .shadow(color: Color.orange.opacity(glowIntensity), radius: isPressed ? 20 : 10)
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
        PhonePositionIndicator()
        PreparationStatusView()
        AbortButton {
            print("Abort pressed")
        }
    }
    .padding()
    .background(Color.black)
    .preferredColorScheme(.dark)
}

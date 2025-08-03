import SwiftUI

struct NeonButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    @State private var isPressed = false
    @State private var glowIntensity: Double = 0.5
    
    var body: some View {
        Button(action: {
            // 使用统一的震动服务
            HapticService.shared.medium()
            action()
        }) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .tracking(1)
            }
            .foregroundColor(isPressed ? .black : color)
            .padding(.horizontal, 32)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(isPressed ? color : Color.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(color, lineWidth: 2)
                    )
            )
            .shadow(color: color.opacity(glowIntensity), radius: isPressed ? 20 : 10)
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

struct MainActionButtonView: View {
    let onStart: () -> Void

    var body: some View {
        NeonButton(
            title: "START FLIGHT",
            icon: "play.circle.fill",
            color: .cyan
        ) {
            onStart()
        }
    }
}

struct BottomFunctionView: View {
    @State private var showingFlightHistory = false
    @State private var showingSettings = false
    @Environment(LightSourceSettings.self) private var lightSettings

    var body: some View {
        HStack(spacing: 40) {
            // 日志按钮 - 使用Button + 手动导航
            Button(action: {
                // 先触发震动
                HapticService.shared.light()
                // 然后导航
                showingFlightHistory = true
            }) {
                VStack(spacing: 8) {
                    Image(systemName: "chart.bar.fill")
                        .font(.title2)
                        .foregroundColor(.blue)

                    Text("LOGS")
                        .font(.caption2)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                        .tracking(1)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.ultraThinMaterial)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white.opacity(0.1), lineWidth: 1)
                        )
                )
            }
            .buttonStyle(PlainButtonStyle())

            // 设置按钮 - 使用Button + 手动导航
            Button(action: {
                // 先触发震动
                HapticService.shared.light()
                // 然后导航
                showingSettings = true
            }) {
                VStack(spacing: 8) {
                    Image(systemName: "gearshape.fill")
                        .font(.title2)
                        .foregroundColor(.blue)

                    Text("SETUP")
                        .font(.caption2)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                        .tracking(1)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.ultraThinMaterial)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white.opacity(0.1), lineWidth: 1)
                        )
                )
            }
            .buttonStyle(PlainButtonStyle())
        }
        .navigationDestination(isPresented: $showingFlightHistory) {
            FlightHistoryView()
                .environment(lightSettings)
        }
        .navigationDestination(isPresented: $showingSettings) {
            SettingsView()
                .environment(lightSettings)
        }
    }
}

// 用于普通按钮的组件（带手势处理）
struct FunctionButtonView: View {
    let icon: String
    let label: String
    let color: Color

    @State private var isPressed = false

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)

            Text(label)
                .font(.caption2)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
                .tracking(1)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
        )
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
            if pressing {
                // 使用统一的震动服务
                HapticService.shared.light()
            }
        }, perform: {})
    }
}

#Preview {
    VStack(spacing: 30) {
        MainActionButtonView {
            print("Start flight")
        }

        BottomFunctionView()
    }
    .preferredColorScheme(.dark)
    .padding()
}

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(LightSourceSettings.self) private var lightSettings
    @State private var userPreferences = UserPreferences.shared
    @State private var showingModelSelection = false
    
    var body: some View {
        ZStack {
            // 背景
            StarfieldBackgroundView()
            
            VStack(spacing: 0) {
                // 顶部导航栏
                topNavigationBar
                    .padding(.top, 10)
                
                // 设置内容
                ScrollView {
                    VStack(spacing: 24) {
                        // 飞机模型设置区域
                        airplaneModelSection

                        // 光源设置区域
                        lightSourceSection
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
                
                Spacer()
            }
        }
        .preferredColorScheme(.dark)
        .navigationBarHidden(true)
        .sheet(isPresented: $showingModelSelection) {
            AirplaneModelSelectionView(selectedModelType: $userPreferences.selectedAirplaneModelType)
        }
    }
    
    // MARK: - 顶部导航栏
    private var topNavigationBar: some View {
        GlassCard {
            HStack {
                Button(action: {
                    HapticService.shared.light()
                    dismiss()
                }) {
                    Image(systemName: "arrow.left")
                        .font(.system(.title3, weight: .medium))
                        .foregroundColor(.cyan)
                }
                
                Spacer()
                
                Text("SETTINGS")
                    .font(.system(.title2, design: .rounded, weight: .bold))
                    .foregroundColor(.white)
                    .tracking(1)
                
                Spacer()
                
                // 占位符保持对称
                Image(systemName: "arrow.left")
                    .font(.system(.title3, weight: .medium))
                    .foregroundColor(.clear)
            }
            .padding()
        }
        .padding(.horizontal, 20)
    }

    // MARK: - 飞机模型设置区域
    private var airplaneModelSection: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 20) {
                // 标题
                HStack {
                    Image(systemName: "airplane")
                        .font(.title2)
                        .foregroundColor(.cyan)

                    Text("飞机模型")
                        .font(.system(.title3, design: .rounded, weight: .bold))
                        .foregroundColor(.white)

                    Spacer()
                }

                // 当前选择的模型
                HStack {
                    Text("当前模型:")
                        .font(.system(.body, design: .rounded))
                        .foregroundColor(.gray)

                    Spacer()

                    Text(userPreferences.selectedAirplaneModelType.displayName)
                        .font(.system(.body, design: .rounded, weight: .semibold))
                        .foregroundColor(.white)
                }

                // 选择按钮
                Button(action: {
                    HapticService.shared.light()
                    showingModelSelection = true
                }) {
                    HStack {
                        Text("选择模型")
                            .font(.system(.body, design: .rounded, weight: .medium))
                            .foregroundColor(.white)

                        Spacer()

                        Image(systemName: "chevron.right")
                            .font(.system(.caption, weight: .medium))
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 12)
                    .padding(.horizontal, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.ultraThinMaterial)
                    )
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(20)
        }
        .padding(.horizontal, 20)
    }

    // MARK: - 光源设置区域
    private var lightSourceSection: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 20) {
                // 标题
                HStack {
                    Image(systemName: "lightbulb.fill")
                        .font(.title2)
                        .foregroundColor(.yellow)
                    
                    Text("光源模式")
                        .font(.system(.title3, design: .rounded, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                }
                
                // 光源选项
                VStack(spacing: 12) {
                    ForEach(LightSourceMode.allCases, id: \.self) { mode in
                        LightSourceOptionView(
                            mode: mode,
                            isSelected: lightSettings.currentMode == mode
                        ) {
                            // 切换光源模式
                            HapticService.shared.medium()
                            lightSettings.switchMode(to: mode)
                        }
                    }
                }
            }
            .padding(20)
        }
    }
}

// MARK: - 光源选项视图
struct LightSourceOptionView: View {
    let mode: LightSourceMode
    let isSelected: Bool
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
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
            HStack(spacing: 16) {
                // 图标
                Image(systemName: mode.icon)
                    .font(.title2)
                    .foregroundColor(isSelected ? .white : .gray)
                    .frame(width: 30)
                
                // 名称
                Text(mode.displayName)
                    .font(.system(.body, design: .rounded, weight: .medium))
                    .foregroundColor(isSelected ? .white : .gray)
                
                Spacer()
                
                // 选中指示器
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title3)
                        .foregroundColor(.green)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.white.opacity(0.1) : Color.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                isSelected ? Color.cyan.opacity(0.5) : Color.white.opacity(0.1),
                                lineWidth: isSelected ? 2 : 1
                            )
                    )
            )
            .scaleEffect(isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: isPressed)
            .animation(.easeInOut(duration: 0.3), value: isSelected)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    SettingsView()
        .environment(LightSourceSettings())
}

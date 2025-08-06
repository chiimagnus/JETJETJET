import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(LightSourceSettings.self) private var lightSettings
    @Bindable private var userPreferences = UserPreferences.shared
    
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

                        // 数据显示类型设置区域
                        dataDisplayTypeSection

                        // 速度单位设置区域
                        speedUnitSection

                        // 版权信息区域
                        copyrightSection
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
                
                Spacer()
            }
        }
        .preferredColorScheme(.dark)
        .navigationBarHidden(true)
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

                // 模型选项
                VStack(spacing: 12) {
                    ForEach(AirplaneModelType.allCases, id: \.self) { modelType in
                        AirplaneModelOptionView(
                            modelType: modelType,
                            isSelected: userPreferences.selectedAirplaneModelType == modelType
                        ) {
                            // 切换飞机模型
                            HapticService.shared.medium()
                            userPreferences.selectedAirplaneModelType = modelType
                        }
                    }
                }
            }
            .padding(20)
        }
    }

    // MARK: - 数据显示类型设置区域
    private var dataDisplayTypeSection: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 20) {
                // 标题
                HStack {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .font(.title2)
                        .foregroundColor(.cyan)

                    Text("数据显示类型")
                        .font(.system(.title3, design: .rounded, weight: .bold))
                        .foregroundColor(.white)

                    Spacer()
                }

                // 数据类型选择器
                Picker("数据显示类型", selection: $userPreferences.dataDisplayType) {
                    ForEach(DataDisplayType.allCases) { type in
                        Text(type.localized).tag(type)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .colorScheme(.dark)
            }
            .padding(20)
        }
    }

    // MARK: - 速度单位设置区域
    private var speedUnitSection: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 16) {
                // 标题
                HStack {
                    Image(systemName: "gauge.with.dots.needle.bottom.50percent")
                        .font(.title2)
                        .foregroundColor(.orange)

                    Text("速度单位")
                        .font(.system(.title3, design: .rounded, weight: .bold))
                        .foregroundColor(.white)
                }

                // 单位选择器
                Picker("速度单位", selection: $userPreferences.speedUnit) {
                    ForEach(SpeedUnit.allCases) { unit in
                        Text(unit.localized).tag(unit)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .background(Color.black.opacity(0.2))
                .cornerRadius(8)
            }
            .padding(20)
        }
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

    // MARK: - 版权信息区域
    private var copyrightSection: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 20) {
                // 标题
                HStack {
                    Image(systemName: "info.circle.fill")
                        .font(.title2)
                        .foregroundColor(.blue)

                    Text("版权信息")
                        .font(.system(.title3, design: .rounded, weight: .bold))
                        .foregroundColor(.white)

                    Spacer()
                }

                // 版权信息内容
                VStack(alignment: .leading, spacing: 16) {
                    // 3D模型版权信息
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "cube.fill")
                                .font(.body)
                                .foregroundColor(.cyan)

                            Text("3D 模型资源")
                                .font(.system(.body, design: .rounded, weight: .semibold))
                                .foregroundColor(.white)
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            Text("模型名称：Little Jet Plane")
                                .font(.system(.caption, design: .rounded))
                                .foregroundColor(.gray)

                            Text("作者：macouno")
                                .font(.system(.caption, design: .rounded))
                                .foregroundColor(.gray)

                            Text("许可：CC BY (Creative Commons - Attribution)")
                                .font(.system(.caption, design: .rounded))
                                .foregroundColor(.gray)

                            HStack {
                                Text("来源：")
                                    .font(.system(.caption, design: .rounded))
                                    .foregroundColor(.gray)

                                Button("Thingiverse") {
                                    if let url = URL(string: "https://www.thingiverse.com/thing:222309") {
                                        UIApplication.shared.open(url)
                                    }
                                }
                                .font(.system(.caption, design: .rounded))
                                .foregroundColor(.blue)
                            }
                        }
                        .padding(.leading, 24)
                    }

                    Divider()
                        .background(Color.white.opacity(0.2))

                    // 音效资源版权信息
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "speaker.wave.2.fill")
                                .font(.body)
                                .foregroundColor(.orange)

                            Text("音效资源")
                                .font(.system(.body, design: .rounded, weight: .semibold))
                                .foregroundColor(.white)
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            Text("来源：Pixabay")
                                .font(.system(.caption, design: .rounded))
                                .foregroundColor(.gray)

                            Text("许可：Pixabay Content License")
                                .font(.system(.caption, design: .rounded))
                                .foregroundColor(.gray)

                            Text("免费商用，无需署名")
                                .font(.system(.caption, design: .rounded))
                                .foregroundColor(.gray)

                            HStack {
                                Text("详情：")
                                    .font(.system(.caption, design: .rounded))
                                    .foregroundColor(.gray)

                                Button("Pixabay License") {
                                    if let url = URL(string: "https://pixabay.com/service/license-summary/") {
                                        UIApplication.shared.open(url)
                                    }
                                }
                                .font(.system(.caption, design: .rounded))
                                .foregroundColor(.blue)
                            }
                        }
                        .padding(.leading, 24)
                    }

                    Divider()
                        .background(Color.white.opacity(0.2))

                    // 应用版权信息
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "app.fill")
                                .font(.body)
                                .foregroundColor(.green)

                            Text("应用信息")
                                .font(.system(.body, design: .rounded, weight: .semibold))
                                .foregroundColor(.white)
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            Text("JETJETJET")
                                .font(.system(.caption, design: .rounded))
                                .foregroundColor(.gray)

                            Text("© 2025 Chii Magnus")
                                .font(.system(.caption, design: .rounded))
                                .foregroundColor(.gray)
                        }
                        .padding(.leading, 24)
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

// MARK: - 飞机模型选项视图
struct AirplaneModelOptionView: View {
    let modelType: AirplaneModelType
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
                Image(systemName: modelType == .defaultModel ? "airplane" : "airplane.circle")
                    .font(.title2)
                    .foregroundColor(isSelected ? .white : .gray)
                    .frame(width: 30)

                // 名称
                Text(modelType.displayName)
                    .font(.system(.body, design: .rounded, weight: .medium))
                    .foregroundColor(isSelected ? .white : .gray)

                Spacer()

                // 选中状态指示器
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title3)
                        .foregroundColor(.cyan)
                }
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? .cyan.opacity(0.15) : .clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(isSelected ? .cyan.opacity(0.3) : .gray.opacity(0.2), lineWidth: 1)
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

import SwiftUI

/// 布局工具类 - 提供统一的布局计算和样式
struct LayoutUtils {
    
    // MARK: - 响应式布局计算
    
    /// 获取自适应水平边距
    static var horizontalPadding: CGFloat {
        AppConfig.horizontalPadding()
    }
    
    /// 获取自适应垂直边距
    static var verticalPadding: CGFloat {
        AppConfig.verticalPadding()
    }
    
    /// 获取自适应间距
    static var adaptiveSpacing: CGFloat {
        AppConfig.adaptiveSpacing()
    }
    
    /// 获取3D场景自适应高度
    static var sceneHeight: CGFloat {
        AppConfig.sceneHeight()
    }
    
    // MARK: - 设备类型判断
    
    /// 是否为大屏设备
    static var isLargeScreen: Bool {
        UIScreen.main.bounds.width > AppConfig.Layout.largeScreenWidthThreshold
    }
    
    /// 是否为高屏设备
    static var isTallScreen: Bool {
        UIScreen.main.bounds.height > AppConfig.Layout.tallScreenHeightThreshold
    }
    
    /// 获取屏幕尺寸类型
    static var screenSizeType: ScreenSizeType {
        switch (isLargeScreen, isTallScreen) {
        case (true, true): return .largeTall
        case (true, false): return .largeShort
        case (false, true): return .smallTall
        case (false, false): return .smallShort
        }
    }
}

// MARK: - 屏幕尺寸类型
enum ScreenSizeType {
    case largeTall    // iPhone 16 Pro Max, iPhone 15 Plus等
    case largeShort   // iPad mini等
    case smallTall    // iPhone 14, iPhone 13等
    case smallShort   // iPhone SE等
    
    var description: String {
        switch self {
        case .largeTall: return "大屏高分辨率"
        case .largeShort: return "大屏标准分辨率"
        case .smallTall: return "标准屏高分辨率"
        case .smallShort: return "小屏标准分辨率"
        }
    }
}

// MARK: - 通用样式修饰符
extension View {
    /// 应用自适应水平边距
    func adaptiveHorizontalPadding() -> some View {
        self.padding(.horizontal, LayoutUtils.horizontalPadding)
    }
    
    /// 应用自适应垂直边距
    func adaptiveVerticalPadding() -> some View {
        self.padding(.vertical, LayoutUtils.verticalPadding)
    }
    
    /// 应用自适应边距
    func adaptivePadding() -> some View {
        self.padding(.horizontal, LayoutUtils.horizontalPadding)
            .padding(.vertical, LayoutUtils.verticalPadding)
    }
    
    /// 应用玻璃卡片样式
    func glassCardStyle() -> some View {
        self.background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
        )
    }
    
    /// 应用霓虹发光效果
    func neonGlow(color: Color, radius: CGFloat = 8) -> some View {
        self.shadow(color: color.opacity(0.5), radius: radius)
            .shadow(color: color.opacity(0.3), radius: radius * 2)
    }
    
    /// 应用HUD样式背景
    func hudBackground() -> some View {
        self.background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.black.opacity(0.7))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.cyan.opacity(0.3), lineWidth: 1)
                )
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.ultraThinMaterial)
                )
        )
    }
}

// MARK: - 动画工具
struct AnimationUtils {
    /// 标准按钮按压动画
    static var buttonPress: Animation {
        .easeInOut(duration: AppConfig.Animation.buttonPressDuration)
    }
    
    /// 状态切换动画
    static var stateTransition: Animation {
        .easeOut(duration: AppConfig.Animation.stateTransitionDuration)
    }
    
    /// 脉冲动画
    static var pulse: Animation {
        .easeInOut(duration: AppConfig.Animation.pulseDuration)
            .repeatForever(autoreverses: true)
    }
    
    /// 发光动画
    static var glow: Animation {
        .easeInOut(duration: AppConfig.Animation.glowDuration)
            .repeatForever(autoreverses: true)
    }
    
    /// 倒计时动画
    static var countdown: Animation {
        .easeInOut(duration: AppConfig.Animation.countdownDuration)
    }
}

// MARK: - 颜色工具
struct ColorUtils {
    /// 录制状态颜色
    static let recordingRed = Color.red
    static let readyGreen = Color.green
    static let warningOrange = Color.orange
    
    /// HUD颜色
    static let hudCyan = Color.cyan
    static let hudBlue = Color.blue
    static let hudPurple = Color.purple
    
    /// 渐变色
    static let neonGradient = LinearGradient(
        colors: [.purple, .cyan],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let recordingGradient = LinearGradient(
        colors: [Color.red.opacity(0.6), Color.red.opacity(0.2)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

// MARK: - 字体工具
struct FontUtils {
    /// HUD字体
    static let hudTitle = Font.custom("Orbitron", size: 18).weight(.bold)
    static let hudValue = Font.system(.title3, design: .monospaced, weight: .bold)
    static let hudLabel = Font.system(.caption2, design: .rounded, weight: .medium)
    
    /// 倒计时字体
    static let countdownNumber = Font.system(size: 120, weight: .black, design: .rounded)
    static let countdownTitle = Font.system(.title2, design: .rounded, weight: .bold)
    
    /// 状态字体
    static let statusText = Font.caption.weight(.semibold)
    static let statusTitle = Font.system(.title2, design: .rounded, weight: .bold)
}

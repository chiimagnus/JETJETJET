import SwiftUI

// MARK: - 设计系统工具类
// 提供统一的动画、颜色、字体和样式修饰符

// MARK: - 通用样式修饰符
extension View {
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

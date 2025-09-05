import UIKit

/// 震动反馈服务
class HapticService {
    static let shared = HapticService()
    
    private init() {}
    
    /// 震动强度级别
    enum HapticIntensity {
        case light      // 轻微震动 - 用于普通按钮、功能按钮
        case medium     // 中等震动 - 用于主要操作按钮
        case heavy      // 重度震动 - 用于重要操作（如停止录制）
        case selection  // 选择震动 - 用于选择器、开关
        case success    // 成功震动 - 用于操作成功
        case warning    // 警告震动 - 用于警告提示
        case error      // 错误震动 - 用于错误提示
        
        var feedbackGenerator: UIFeedbackGenerator {
            switch self {
            case .light:
                return UIImpactFeedbackGenerator(style: .light)
            case .medium:
                return UIImpactFeedbackGenerator(style: .medium)
            case .heavy:
                return UIImpactFeedbackGenerator(style: .heavy)
            case .selection:
                return UISelectionFeedbackGenerator()
            case .success:
                let generator = UINotificationFeedbackGenerator()
                return generator
            case .warning:
                let generator = UINotificationFeedbackGenerator()
                return generator
            case .error:
                let generator = UINotificationFeedbackGenerator()
                return generator
            }
        }
    }
    
    /// 触发震动反馈
    /// - Parameter intensity: 震动强度
    func trigger(_ intensity: HapticIntensity) {
        switch intensity {
        case .light, .medium, .heavy:
            if let impactGenerator = intensity.feedbackGenerator as? UIImpactFeedbackGenerator {
                impactGenerator.impactOccurred()
            }
        case .selection:
            if let selectionGenerator = intensity.feedbackGenerator as? UISelectionFeedbackGenerator {
                selectionGenerator.selectionChanged()
            }
        case .success:
            if let notificationGenerator = intensity.feedbackGenerator as? UINotificationFeedbackGenerator {
                notificationGenerator.notificationOccurred(.success)
            }
        case .warning:
            if let notificationGenerator = intensity.feedbackGenerator as? UINotificationFeedbackGenerator {
                notificationGenerator.notificationOccurred(.warning)
            }
        case .error:
            if let notificationGenerator = intensity.feedbackGenerator as? UINotificationFeedbackGenerator {
                notificationGenerator.notificationOccurred(.error)
            }
        }
    }
    
    /// 预准备震动反馈（提前准备可以减少延迟）
    /// - Parameter intensity: 震动强度
    func prepare(_ intensity: HapticIntensity) {
        intensity.feedbackGenerator.prepare()
    }
}

// MARK: - 便捷方法
extension HapticService {
    /// 轻微震动 - 用于普通按钮
    func light() {
        trigger(.light)
    }
    
    /// 中等震动 - 用于主要操作
    func medium() {
        trigger(.medium)
    }
    
    /// 重度震动 - 用于重要操作
    func heavy() {
        trigger(.heavy)
    }
    
    /// 选择震动 - 用于选择器
    func selection() {
        trigger(.selection)
    }
    
    /// 成功震动
    func success() {
        trigger(.success)
    }
    
    /// 警告震动
    func warning() {
        trigger(.warning)
    }
    
    /// 错误震动
    func error() {
        trigger(.error)
    }
}

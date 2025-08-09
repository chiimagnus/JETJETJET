import SwiftUI
import Foundation
#if canImport(UIKit)
import UIKit
#endif

/// 光源模式枚举
enum LightSourceMode: String, CaseIterable {
    case `default` = "default"
    case sun = "sun"
    case moon = "moon"
    case custom = "custom"

    var displayName: String {
        switch self {
        case .default:
            return "星光"
        case .sun:
            return "太阳"
        case .moon:
            return "月亮"
        case .custom:
            return "自定义"
        }
    }

    var icon: String {
        switch self {
        case .default:
            return "sparkles"
        case .sun:
            return "sun.max.fill"
        case .moon:
            return "moon.stars.fill"
        case .custom:
            return "paintpalette.fill"
        }
    }
    
    /// 光源颜色配置
    var lightColor: Color {
        switch self {
        case .default:
            // 原始的蓝色光源 - 基于git提交记录的配置
            return Color(red: 0.2, green: 0.3, blue: 0.5)
        case .sun:
            // 温暖的金黄色光源
            return Color(red: 1.0, green: 0.8, blue: 0.4)
        case .moon:
            // 冷色调的银蓝色光源
            return Color(red: 0.7, green: 0.8, blue: 1.0)
        case .custom:
            // 占位默认值，自定义实际颜色由 LightSourceSettings 提供
            return Color(red: 0.2, green: 0.3, blue: 0.5)
        }
    }

    /// 中等亮度颜色
    var mediumColor: Color {
        switch self {
        case .default:
            // 原始的中等亮度颜色
            return Color(red: 0.08, green: 0.12, blue: 0.20)
        case .sun:
            return Color(red: 0.15, green: 0.12, blue: 0.08)
        case .moon:
            return Color(red: 0.08, green: 0.12, blue: 0.20)
        case .custom:
            // 占位默认值
            return Color(red: 0.08, green: 0.12, blue: 0.20)
        }
    }

    /// 深色背景
    var darkColor: Color {
        switch self {
        case .default:
            // 原始的深色背景
            return Color(red: 0.01, green: 0.01, blue: 0.03)
        case .sun:
            return Color(red: 0.03, green: 0.02, blue: 0.01)
        case .moon:
            return Color(red: 0.01, green: 0.01, blue: 0.03)
        case .custom:
            // 占位默认值
            return Color(red: 0.01, green: 0.01, blue: 0.03)
        }
    }
}

/// 光源设置管理类
@Observable
class LightSourceSettings {
    var currentMode: LightSourceMode = .default
    
    // 自定义模式的基础色（中间和深色由此计算）
    var customBaseColor: Color = Color(red: 0.2, green: 0.3, blue: 0.5) {
        didSet { saveCustomColor() }
    }
    
    // 由基础色推导的中间与深色（不单独存储）
    var customMediumColor: Color {
        derivedMediumColor(from: customBaseColor)
    }
    
    var customDarkColor: Color {
        derivedDarkColor(from: customBaseColor)
    }
    
    init() {
        loadSettings()
    }
    
    /// 切换光源模式
    func switchMode(to mode: LightSourceMode) {
        currentMode = mode
        saveSettings()
    }
    
    /// 保存设置到UserDefaults
    private func saveSettings() {
        UserDefaults.standard.set(currentMode.rawValue, forKey: "LightSourceMode")
        saveCustomColor()
    }
    
    /// 从UserDefaults加载设置
    private func loadSettings() {
        if let savedMode = UserDefaults.standard.string(forKey: "LightSourceMode"),
           let mode = LightSourceMode(rawValue: savedMode) {
            currentMode = mode
        }
        loadCustomColor()
    }

    // MARK: - 自定义颜色持久化
    private func saveCustomColor() {
        #if canImport(UIKit)
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        UIColor(customBaseColor).getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgba: [Double] = [Double(r), Double(g), Double(b), Double(a)]
        UserDefaults.standard.set(rgba, forKey: "LightCustomBaseColor")
        #endif
    }

    private func loadCustomColor() {
        if let rgba = UserDefaults.standard.array(forKey: "LightCustomBaseColor") as? [Double], rgba.count == 4 {
            let r = max(0.0, min(1.0, rgba[0]))
            let g = max(0.0, min(1.0, rgba[1]))
            let b = max(0.0, min(1.0, rgba[2]))
            let a = max(0.0, min(1.0, rgba[3]))
            customBaseColor = Color(red: r, green: g, blue: b, opacity: a)
        }
    }

    // MARK: - 颜色推导
    private func derivedMediumColor(from base: Color) -> Color {
        #if canImport(UIKit)
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        UIColor(base).getRed(&r, green: &g, blue: &b, alpha: &a)
        // 略微降低亮度，形成中间色
        let factor: CGFloat = 0.4
        return Color(red: Double(r * factor), green: Double(g * factor), blue: Double(b * factor), opacity: Double(a))
        #else
        return base
        #endif
    }

    private func derivedDarkColor(from base: Color) -> Color {
        #if canImport(UIKit)
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        UIColor(base).getRed(&r, green: &g, blue: &b, alpha: &a)
        // 进一步降低亮度，形成深色
        let factor: CGFloat = 0.08
        return Color(red: Double(max(0, r * factor)), green: Double(max(0, g * factor)), blue: Double(max(0, b * factor)), opacity: Double(a))
        #else
        return base
        #endif
    }
}

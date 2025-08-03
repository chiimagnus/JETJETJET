import SwiftUI
import Foundation

/// 光源模式枚举
enum LightSourceMode: String, CaseIterable {
    case `default` = "default"
    case sun = "sun"
    case moon = "moon"

    var displayName: String {
        switch self {
        case .default:
            return "星光"
        case .sun:
            return "太阳"
        case .moon:
            return "月亮"
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
        }
    }
}

/// 光源设置管理类
@Observable
class LightSourceSettings {
    var currentMode: LightSourceMode = .default
    
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
    }
    
    /// 从UserDefaults加载设置
    private func loadSettings() {
        if let savedMode = UserDefaults.standard.string(forKey: "LightSourceMode"),
           let mode = LightSourceMode(rawValue: savedMode) {
            currentMode = mode
        }
    }
}

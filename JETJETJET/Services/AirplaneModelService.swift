import Foundation
import SwiftUI

// MARK: - 飞机模型选择服务
@Observable
class AirplaneModelService {
    // 当前选择的模型类型
    private(set) var currentModelType: AirplaneModelType = .defaultModel
    
    // 用户偏好存储键
    private let userDefaultsKey = "SelectedAirplaneModel"
    
    init() {
        loadSelectedModel()
    }
    
    // 切换模型类型
    func selectModel(_ type: AirplaneModelType) {
        currentModelType = type
        saveSelectedModel()
    }
    
    // 获取当前模型配置
    func getCurrentModelConfig() -> AirplaneModelConfig {
        return AirplaneModelConfig(type: currentModelType)
    }
    
    // 获取所有可用模型
    func getAllModelConfigs() -> [AirplaneModelConfig] {
        return AirplaneModelConfig.allConfigs
    }
    
    // 保存选择的模型到UserDefaults
    private func saveSelectedModel() {
        UserDefaults.standard.set(currentModelType.rawValue, forKey: userDefaultsKey)
    }
    
    // 从UserDefaults加载选择的模型
    private func loadSelectedModel() {
        if let savedModelRawValue = UserDefaults.standard.string(forKey: userDefaultsKey),
           let savedModelType = AirplaneModelType(rawValue: savedModelRawValue) {
            currentModelType = savedModelType
        }
    }
}

// MARK: - 全局模型服务实例
extension AirplaneModelService {
    static let shared = AirplaneModelService()
}

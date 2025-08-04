import Foundation

// MARK: - 飞机模型类型枚举
enum AirplaneModelType: String, CaseIterable, Identifiable {
    case defaultModel = "default"
    case jet1 = "jet1"
    
    var id: String { rawValue }
    
    // 显示名称
    var displayName: String {
        switch self {
        case .defaultModel:
            return "默认"
        case .jet1:
            return "Jet1"
        }
    }
    
    // 模型文件名（如果是外部文件）
    var fileName: String? {
        switch self {
        case .defaultModel:
            return nil // 使用代码生成的模型
        case .jet1:
            return "jet.scn"
        }
    }
    
    // 模型描述
    var description: String {
        switch self {
        case .defaultModel:
            return "代码生成的简约飞机模型"
        case .jet1:
            return "外部导入的喷气式飞机模型"
        }
    }
    
    // 是否为外部文件模型
    var isExternalFile: Bool {
        return fileName != nil
    }
}

// MARK: - 飞机模型配置
struct AirplaneModelConfig {
    let type: AirplaneModelType
    let displayName: String
    let description: String
    let fileName: String?
    
    init(type: AirplaneModelType) {
        self.type = type
        self.displayName = type.displayName
        self.description = type.description
        self.fileName = type.fileName
    }
    
    // 获取所有可用的模型配置
    static var allConfigs: [AirplaneModelConfig] {
        return AirplaneModelType.allCases.map { AirplaneModelConfig(type: $0) }
    }
}

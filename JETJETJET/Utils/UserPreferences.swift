import Foundation

// MARK: - 用户偏好设置管理
@Observable
class UserPreferences {
    static let shared = UserPreferences()

    // MARK: - 飞机模型设置
    var selectedAirplaneModelType: AirplaneModelType {
        didSet {
            UserDefaults.standard.set(selectedAirplaneModelType.rawValue, forKey: "selectedAirplaneModelType")
        }
    }

    private init() {
        // 从UserDefaults加载初始值
        let rawValue = UserDefaults.standard.string(forKey: "selectedAirplaneModelType") ?? AirplaneModelType.defaultModel.rawValue
        self.selectedAirplaneModelType = AirplaneModelType(rawValue: rawValue) ?? .defaultModel
    }
    
    // MARK: - 其他设置可以在这里添加
    // 例如：音效开关、震动开关等
}

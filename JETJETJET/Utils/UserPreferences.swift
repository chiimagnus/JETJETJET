import Foundation

// MARK: - 用户偏好设置管理
@Observable
class UserPreferences {
    static let shared = UserPreferences()
    
    private init() {}
    
    // MARK: - 飞机模型设置
    var selectedAirplaneModelType: AirplaneModelType {
        get {
            let rawValue = UserDefaults.standard.string(forKey: "selectedAirplaneModelType") ?? AirplaneModelType.defaultModel.rawValue
            return AirplaneModelType(rawValue: rawValue) ?? .defaultModel
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: "selectedAirplaneModelType")
        }
    }
    
    // MARK: - 其他设置可以在这里添加
    // 例如：音效开关、震动开关等
}

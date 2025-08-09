import Foundation

// MARK: - 数据显示类型
enum DataDisplayType: String, CaseIterable, Identifiable {
    case acceleration = "acceleration"
    case speed = "speed"

    var id: Self { self }

    var localized: String {
        switch self {
        case .acceleration:
            return String(localized: "加速度")
        case .speed:
            return String(localized: "速度")
        }
    }

    var unit: String {
        switch self {
        case .acceleration:
            return "m/s²"
        case .speed:
            return String(localized: "速度单位")  // 这里不能直接引用UserPreferences.shared，会造成循环引用
        }
    }
}

// MARK: - 速度单位
enum SpeedUnit: String, CaseIterable, Identifiable {
    case kilometersPerHour = "km/h"
    case milesPerHour = "mph"
    case knots = "knots"

    var id: Self { self }

    var localized: String {
        switch self {
        case .kilometersPerHour:
            return "km/h"
        case .milesPerHour:
            return "mph"
        case .knots:
            return "Knots"
        }
    }
}


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

    // MARK: - 数据显示类型设置
    var dataDisplayType: DataDisplayType {
        didSet {
            UserDefaults.standard.set(dataDisplayType.rawValue, forKey: "dataDisplayType")
        }
    }

    // MARK: - 速度单位设置
    var speedUnit: SpeedUnit {
        didSet {
            UserDefaults.standard.set(speedUnit.rawValue, forKey: "speedUnit")
        }
    }

    private init() {
        // 从UserDefaults加载飞机模型初始值
        let airplaneRawValue = UserDefaults.standard.string(forKey: "selectedAirplaneModelType") ?? AirplaneModelType.defaultModel.rawValue
        self.selectedAirplaneModelType = AirplaneModelType(rawValue: airplaneRawValue) ?? .defaultModel

        // 从UserDefaults加载数据显示类型初始值
        let dataDisplayTypeRawValue = UserDefaults.standard.string(forKey: "dataDisplayType") ?? DataDisplayType.acceleration.rawValue
        self.dataDisplayType = DataDisplayType(rawValue: dataDisplayTypeRawValue) ?? .acceleration

        // 从UserDefaults加载速度单位初始值
        let speedUnitRawValue = UserDefaults.standard.string(forKey: "speedUnit") ?? SpeedUnit.kilometersPerHour.rawValue
        self.speedUnit = SpeedUnit(rawValue: speedUnitRawValue) ?? .kilometersPerHour
    }
    
    // MARK: - 其他设置可以在这里添加
    // 例如：音效开关、震动开关等
}

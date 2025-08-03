import Foundation
import UIKit

/// 应用程序配置管理
struct AppConfig {
    
    // MARK: - 录制配置
    struct Recording {
        /// 运动传感器更新频率 (Hz)
        static let motionUpdateInterval: TimeInterval = 0.1
        
        /// 录制界面跳转延迟 (秒)
        static let transitionDelay: TimeInterval = 0.5
        
        /// 最大内存中数据条数（超过后批量保存）
        static let maxInMemoryDataCount = 1000
        
        /// 批量保存数据大小
        static let batchSaveSize = 100
        
        /// 低通滤波系数
        static let lowPassFilterAlpha: Double = 0.8
        
        /// 速度计算的最小时间间隔
        static let minTimeInterval: TimeInterval = 0.001
    }
    

    
    // MARK: - 动画配置
    struct Animation {
        /// 倒计时动画持续时间
        static let countdownDuration: TimeInterval = 1.0
        
        /// 按钮按压动画持续时间
        static let buttonPressDuration: TimeInterval = 0.15
        
        /// 状态切换动画持续时间
        static let stateTransitionDuration: TimeInterval = 0.3
        
        /// 脉冲动画持续时间
        static let pulseDuration: TimeInterval = 2.0
        
        /// 发光动画持续时间
        static let glowDuration: TimeInterval = 1.5
    }
    
    // MARK: - 3D模型配置
    struct Model3D {
        /// 3D模型初始化延迟
        static let initializationDelay: TimeInterval = 0.1
        
        /// 飞行场景自适应高度（小屏）
        static let smallScreenSceneHeight: CGFloat = 300
        
        /// 飞行场景自适应高度（大屏）
        static let largeScreenSceneHeight: CGFloat = 320
    }
    
    // MARK: - 数据配置
    struct Data {
        /// 角度转换系数（弧度转度）
        static let radiansToDegreesMultiplier = 180.0 / Double.pi
        
        /// 姿态角度范围
        static let pitchRange: ClosedRange<Double> = -90...90
        static let rollRange: ClosedRange<Double> = -90...90
        static let yawRange: ClosedRange<Double> = -180...180
        
        /// 数据格式化精度
        static let angleDecimalPlaces = 0
        static let speedDecimalPlaces = 1
    }
    
    // MARK: - 错误消息
    struct ErrorMessages {
        static let motionNotAvailable = "设备不支持运动传感器"
        static let motionNotAccessible = "运动传感器不可用"
        static let dataContextUnavailable = "数据上下文不可用"
        static let dataSaveFailed = "保存数据失败"
        static let inconsistentRecordingState = "录制状态不一致"
    }
    
    // MARK: - 调试配置
    struct Debug {
        /// 是否启用详细日志
        static let enableVerboseLogging = false
        
        /// 是否启用性能监控
        static let enablePerformanceMonitoring = false
        
        /// 是否启用状态验证
        static let enableStateValidation = true
    }
}

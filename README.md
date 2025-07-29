# JETJETJET!!!

## Idea

- 我想到一个很好玩的点。手机上有个飞机模型，持续记录手机的运动状态：速度、前后角度、侧向角度等信息。
  最后交付的就是整个手机运动状态的动画！
- 我这个则是展示手机运动状态的。

## MVP 技术实现

### 1. 3D飞机模型
- **方案A**: SceneKit内置箭头 (`SCNArrow`) - 最简单
- **方案B**: 免费飞机模型从Sketchfab下载 (.obj/.dae格式)
- **当前选择**: 先用简单箭头，后期升级

### 2. iOS传感器API
- **CoreMotion框架**: 设备姿态、加速度、陀螺仪
  - `CMMotionManager` - 主要传感器管理
  - `CMAttitude` - 获取俯仰角、横滚角、偏航角
  - `CMDeviceMotion` - 获取设备运动数据

### 3. 数据记录结构
```swift
FlightData {
  timestamp: Date      // 时间戳
  speed: Double       // 前进速度 (m/s)
  pitch: Double       // 俯仰角 (degrees)
  roll: Double        // 横滚角 (degrees)
  yaw: Double         // 偏航角 (degrees)
}
```

### 4. 开发阶段
1. **阶段1**: 传感器数据收集 + 简单存储
2. **阶段2**: 历史记录列表
3. **阶段3**: 3D回放功能
4. **阶段4**: 美化界面 + 真实飞机模型

### 5. 技术栈
- **3D渲染**: SceneKit
- **数据存储**: SwiftData
- **传感器**: CoreMotion
- **UI**: SwiftUI 
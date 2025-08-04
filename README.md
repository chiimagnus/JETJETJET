<div align="center">

# JETJETJET✈︎✈︎✈︎

### *将您的iPhone变成一架虚拟战斗机*

[![Swift 5.9](https://img.shields.io/badge/Swift-5.9-orange.svg)](https://swift.org)
[![iOS 17+](https://img.shields.io/badge/iOS-17+-blue.svg)](https://developer.apple.com/ios)
[![SwiftUI](https://img.shields.io/badge/SwiftUI-5-green.svg)](https://developer.apple.com/swiftui)
[![SceneKit](https://img.shields.io/badge/3D-SceneKit-purple.svg)](https://developer.apple.com/scenekit)

</div>

## 🌟 项目亮点

**JETJETJET** 不仅仅是一个应用，它是您口袋里的**私人飞行模拟器**！通过先进的iOS传感器技术，将您的手机运动实时转化为震撼的3D飞行动画。

### ✨ 核心体验
- 🎮 **沉浸式飞行**：挥动手机，3D飞机实时响应您的每一个动作
- 🎬 **时光倒流**：记录完整飞行轨迹，随时回放精彩瞬间  
- 🌌 **科幻界面**：动态星空背景，随飞机姿态变换的霓虹光效
- 📊 **实时数据**：俯仰、横滚、偏航、速度，一目了然

## 🎯 用户指南

### 快速开始
1. **启动应用** → 进入主界面，3D飞机悬浮在星空中
2. **开始记录** → 点击"开始飞行"，挥动您的手机
3. **体验飞行** → 上下俯冲、左右翻滚、旋转机头
4. **回放精彩** → 在历史记录中重温您的飞行表演

### 飞行数据解读
- **⬆️ 俯仰角 (Pitch)**：机头上下 - 正值爬升，负值俯冲
- **🔄 横滚角 (Roll)**：左右倾斜 - 正值右倾，负值左倾  
- **↔️ 偏航角 (Yaw)**：机头转向 - 正值右转，负值左转
- **⚡ 速度 (Speed)**：前进速率 - 实时计算

## 🛠️ 技术架构

### 核心技术栈
```swift
// 纯Swift技术栈，零第三方依赖
📱 UI框架: SwiftUI + Combine
🎮 3D引擎: SceneKit (原生)
📊 数据存储: SwiftData (iOS 17+)
🎯 传感器: CoreMotion框架
☁️ 云同步: CloudKit (可选)
```

### 架构特色
- **MVVM架构**：清晰的关注点分离
- **响应式编程**：Combine框架实现数据流
- **模块化设计**：视图、模型、服务完全解耦
- **零依赖**：仅使用系统框架，轻量高效

## 🎨 设计亮点

### 动态星空背景
- **实时响应**：根据飞机姿态动态调整光源位置
- **渐变光效**：从深蓝到霓虹蓝的梦幻过渡
- **粒子动画**：星星闪烁营造太空氛围

### 玻璃拟态界面
- **毛玻璃效果**：iOS风格的半透明卡片
- **霓虹边框**：脉冲动画增强科技感
- **全息投影**：3D飞机仿佛悬浮在星空中

### 沉浸式交互
- **手势控制**：自然直观的手机操作
- **触觉反馈**：Haptic Engine提供物理反馈
- **音效系统**：引擎轰鸣增强真实感

## 🚀 开发者指南

### 环境要求
- **Xcode 15.0+**
- **iOS 17.0+**
- **Swift 5.9+**
- **真机测试** (需要CoreMotion传感器)

### 项目结构
```
JETJETJET/
├── Models/           # 数据模型 (SwiftData)
├── ViewModels/       # 业务逻辑 (MVVM)
├── Views/           # SwiftUI视图
│   ├── 3D/          # SceneKit 3D组件
│   ├── Common/      # 通用UI组件
│   ├── Main/        # 主界面
│   ├── Recording/   # 录制界面
│   └── History/     # 历史记录
├── Services/        # 传感器服务
└── Utils/          # 工具类
```

### 快速运行
```bash
# 克隆项目
git clone https://github.com/ChiiMagnus/JETJETJET.git
# 在Xcode中打开
# 选择真机运行 (CoreMotion需要真机)
# 点击运行 ▶️
```

### 贡献指南

我们欢迎所有形式的贡献！

#### 🐛 问题报告
- 使用GitHub Issues报告bug
- 提供详细的复现步骤
- 附上设备型号和iOS版本

#### ✨ 功能建议
- 在Issues中标记为"enhancement"
- 描述清楚使用场景
- 欢迎UI/UX改进建议

#### 🔧 代码贡献
1. Fork本项目
2. 创建功能分支
3. 提交更改
4. 推送到分支
5. 创建Pull Request

### 开发路线图

#### ✅ 已完成
- [x] 基础3D飞机模型
- [x] CoreMotion传感器集成
- [x] SwiftData数据存储
- [x] 动态星空背景
- [x] 历史记录功能

#### 🚧 进行中
- [ ] 3D轨迹回放
- [ ] 真实飞机模型替换
- [ ] 飞行数据导出

#### 🎯 未来计划
- [ ] Apple Vision Pro支持
- [ ] AR增强现实模式
- [ ] 自定义飞机涂装

## 📱 兼容性

| 设备类型 | 最低版本 | 功能支持 |
|---------|----------|----------|
| iPhone | iOS 17.0 | ✅ 完整支持 |
| iPad | iPadOS 17.0 | ✅ 完整支持 |
| Vision Pro | visionOS 1.0 | 🎯 TODO |

## 📄 许可证

本项目采用 **GPL-3.0许可证** - 详见 [LICENSE](LICENSE) 文件

## 🙏 致谢

- **Apple**: 提供强大的CoreMotion和SceneKit框架
- **Sketchfab**: 3D模型资源平台
- **开源社区**: 灵感和技术支持

---

<div align="center">

**[⬆️ 回到顶部](#-jetjetjet-) | [📱 下载测试版](https://testflight.apple.com/join/yourapp) | [🐛 报告问题](../../issues)**

*Made with ❤️ by ChiiMagnus*

</div> 
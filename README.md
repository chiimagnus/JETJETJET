<div align="center">

# JETJETJET✈︎✈︎✈︎

### *将你的iPhone变成专业飞行数据记录仪*

[中文](README.md) | [English](README_EN.md)

[![Swift 5.9](https://img.shields.io/badge/Swift-5.9-orange.svg)](https://swift.org) [![SwiftUI](https://img.shields.io/badge/SwiftUI-5-green.svg)](https://developer.apple.com/swiftui)
[![SceneKit](https://img.shields.io/badge/3D-SceneKit-purple.svg)](https://developer.apple.com/scenekit) [![CoreMotion](https://img.shields.io/badge/Sensors-CoreMotion-red.svg)](https://developer.apple.com/coremotion)
[![iOS 17+](https://img.shields.io/badge/iOS-17+-blue.svg)](https://developer.apple.com/ios) [![License](https://img.shields.io/badge/License-GPL--3.0-yellow.svg)](./LICENSE)

</div>

## 🎯 一句话介绍

**JETJETJET** = 把你的iPhone变成飞机 + 实时3D飞行回放

## ✨ 核心功能一览

| 功能 | 效果 | 技术亮点 |
|------|------|----------|
| **🎮 实时飞行** | 手机=战斗机，每个动作实时3D显示 | CoreMotion 10Hz采样 |
| **🎬 时光倒流** | 完整飞行轨迹，360°回放 | SceneKit 3D渲染 |
| **🌌 科幻界面** | 动态星空+霓虹光效 | SwiftUI+粒子动画 |

## 🛠️ 技术架构

### 🏗️ 极简技术栈
```swift
// 纯Apple原生，零第三方依赖
📱 UI: SwiftUI + Combine
🎮 3D: SceneKit (原生)
📊 数据: SwiftData (iOS 17+)
🎯 传感器: CoreMotion
```

### 📁 项目结构
```
JETJETJET/
├── Models/          # 数据模型
├── ViewModels/      # 业务逻辑
├── Views/           # SwiftUI界面
│   ├── 3D/          # SceneKit 3D
│   ├── Recording/   # 录制界面
│   └── History/     # 历史记录
├── Services/        # 传感器服务
└── .superdesign/    # ✅ 完整设计稿已包含！
    ├── jetjet_main_1.html      # 主界面设计
    ├── jetjet_recording_1.html # 录制界面
    ├── jetjet_replay_1.html    # 回放界面
    └── jetjet_theme.css        # 完整主题系统
```

## 🎨 设计稿展示

<div align="center">

### 📂 项目中已包含完整设计稿！

**🎨 5个精美HTML设计稿 + 完整CSS主题**

| 界面 | 预览 | 特色 |
|------|------|------|
| **主界面** | [🚀 主界面设计稿](./.superdesign/design_iterations/jetjet_main_1.html) | 动态星空+3D飞机 |
| **录制界面** | [📹 录制界面设计稿](./.superdesign/design_iterations/jetjet_recording_1.html) | HUD风格+实时数据 |
| **倒计时界面** | [⏰ 倒计时设计稿](./.superdesign/design_iterations/jetjet_countdown_1.html) | 沉浸式准备体验 |
| **历史记录** | [📊 历史记录设计稿](./.superdesign/design_iterations/jetjet_history_1.html) | 玻璃拟态卡片 |
| **3D回放** | [🎮 3D回放设计稿](./.superdesign/design_iterations/jetjet_replay_1.html) | 完整轨迹重现 |

</div>

## 🚀 立即开始

### 📱 环境要求
- **iOS 17.0+** (iPhone/iPad)
- **Xcode 15.0+**
- **真机测试** (需要CoreMotion传感器)

## 🎯 开发路线图

### ✅ 已完成
- [x] **实时3D飞行** - 挥手机=开飞机
- [x] **完整数据记录** - 每个动作都记录
- [x] **科幻界面** - 动态星空+霓虹光效
- [x] **完整设计稿** - 5个HTML设计文件
- [x] **真实飞机模型** - 替换3D箭头

### 🚧 即将推出
- [ ] **3D轨迹回放** - 360°重温飞行
- [ ] **数据导出** - CSV/JSON格式
- [ ] **Apple Vision Pro** - 空间计算体验
- [ ] **RoNIN技术升级** - 基于[RoNIN](https://ronin.cs.sfu.ca/)论文的神经网络惯性导航，实现不依赖GPS的精确速度计算。[对话链接](https://chat.z.ai/s/c8855f52-7457-4160-90ec-1652376e4998)

## 🤝 参与开发

### 🎯 欢迎所有贡献！
- **🐛 Bug修复** - 发现任何问题请提Issue
- **✨ 新功能** - 有好的想法欢迎PR
- **🎨 UI改进** - 设计稿已提供，可直接参考
- **📚 文档** - 帮助完善README

### 💡 快速贡献流程
1. **Fork项目**
2. **查看设计稿** - 参考`.superdesign/`中的设计
3. **开发功能** - 保持设计一致性
4. **提交PR** - 我们会快速review

## 📄 版权信息与致谢

### 🎨 3D 模型资源

**飞机3D模型**
- **模型名称**: Little Jet Plane
- **作者**: macouno
- **发布日期**: 2014年1月10日
- **许可类型**: [CC BY (Creative Commons - Attribution)](https://creativecommons.org/licenses/by/4.0/)
- **原始来源**: [Thingiverse - Little Jet Plane](https://www.thingiverse.com/thing:222309)

### 🎵 音效资源

- **[Pixabay](https://pixabay.com/)** - 提供高质量音效素材，遵循 Pixabay License

### 🛠️ 开发工具

- **[superdesign](https://github.com/superdesigndev/superdesign)** - 提供设计稿生成提示词

### 📱 应用版权

- **JETJETJET** © 2025 Chii Magnus
- **许可证**: GPL-3.0 License
<div align="center">

*Made with ❤️ by [Chii Magnus](https://github.com/chiimagnus)*

**如果这个项目让你眼前一亮，请给我们一个 ⭐️**

</div> 

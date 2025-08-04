<div align="center">

# JETJETJET✈︎✈︎✈︎

### *将你的iPhone变成专业飞行数据记录仪*

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

### 🎯 一键运行
```bash
# 1. 克隆项目
git clone https://github.com/ChiiMagnus/JETJETJET.git
# 2. 使用Xcode打开项目
# 3. 选择真机运行 ▶️
# 4. 开始飞行！
```

---

## 🎯 开发路线图

### ✅ 已完成 (立即可用)
- [x] **实时3D飞行** - 挥手机=开飞机
- [x] **完整数据记录** - 每个动作都记录
- [x] **3D轨迹回放** - 360°重温飞行
- [x] **科幻界面** - 动态星空+霓虹光效
- [x] **完整设计稿** - 5个HTML设计文件

### 🚧 即将推出
- [ ] **真实飞机模型** - 替换3D箭头
- [ ] **数据导出** - CSV/JSON格式
- [ ] **Apple Vision Pro** - 空间计算体验

---

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

---

## 📄 许可证 & 致谢

**GPL-3.0许可证** - 开源免费，欢迎fork！

**特别感谢**
- **Apple** - CoreMotion + SceneKit 强大框架
- **设计灵感** - 科幻电影 + 航空仪表 + 太空探索
- **社区贡献** - 每一位开发者 ❤️

---

<div align="center">

**[⬆️ 回到顶部](#-jetjetjet) | [📱 立即体验](https://github.com/ChiiMagnus/JETJETJET) | [🐛 报告问题](../../issues)**

*Made with ❤️ by ChiiMagnus*

**如果这个项目让你眼前一亮，请给我们一个 ⭐️ Star！**

</div> 

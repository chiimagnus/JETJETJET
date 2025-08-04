<div align="center">

# JETJETJET✈︎✈︎✈︎

### *Turn your iPhone into a professional flight data recorder*

[中文](README.md) | [English](README_EN.md)

[![Swift 5.9](https://img.shields.io/badge/Swift-5.9-orange.svg)](https://swift.org) [![SwiftUI](https://img.shields.io/badge/SwiftUI-5-green.svg)](https://developer.apple.com/swiftui)
[![SceneKit](https://img.shields.io/badge/3D-SceneKit-purple.svg)](https://developer.apple.com/scenekit) [![CoreMotion](https://img.shields.io/badge/Sensors-CoreMotion-red.svg)](https://developer.apple.com/coremotion)
[![iOS 17+](https://img.shields.io/badge/iOS-17+-blue.svg)](https://developer.apple.com/ios) [![License](https://img.shields.io/badge/License-GPL--3.0-yellow.svg)](./LICENSE)

</div>

## 🎯 One-liner

**JETJETJET** = Turn your iPhone into an airplane + real-time 3D flight replay

## ✨ Core Features

| Feature | Effect | Technical Highlights |
|---------|--------|---------------------|
| **🎮 Real-time Flight** | Phone = Fighter Jet, every movement in real-time 3D | CoreMotion 10Hz sampling |
| **🎬 Time Travel** | Complete flight path, 360° replay | SceneKit 3D rendering |
| **🌌 Sci-fi Interface** | Dynamic starfield + neon effects | SwiftUI + particle animations |

## 🛠️ Technical Architecture

### 🏗️ Minimal Tech Stack
```swift
// Pure Apple native, zero third-party dependencies
📱 UI: SwiftUI + Combine
🎮 3D: SceneKit (native)
📊 Data: SwiftData (iOS 17+)
🎯 Sensors: CoreMotion
```

### 📁 Project Structure
```
JETJETJET/
├── Models/          # Data models
├── ViewModels/      # Business logic
├── Views/           # SwiftUI interface
│   ├── 3D/          # SceneKit 3D
│   ├── Recording/   # Recording interface
│   └── History/     # History records
├── Services/        # Sensor services
└── .superdesign/    # ✅ Complete design files included!
    ├── jetjet_main_1.html      # Main interface design
    ├── jetjet_recording_1.html # Recording interface
    ├── jetjet_replay_1.html    # Replay interface
    └── jetjet_theme.css        # Complete theme system
```

## 🎨 Design Showcase

<div align="center">

### 📂 Complete design files included in project!

**🎨 5 beautiful HTML design files + complete CSS theme**

| Interface | Preview | Features |
|-----------|---------|----------|
| **Main Interface** | [🚀 Main design file](./.superdesign/design_iterations/jetjet_main_1.html) | Dynamic starfield + 3D aircraft |
| **Recording Interface** | [📹 Recording design file](./.superdesign/design_iterations/jetjet_recording_1.html) | HUD style + real-time data |
| **Countdown Interface** | [⏰ Countdown design file](./.superdesign/design_iterations/jetjet_countdown_1.html) | Immersive preparation experience |
| **History Records** | [📊 History design file](./.superdesign/design_iterations/jetjet_history_1.html) | Glassmorphism cards |
| **3D Replay** | [🎮 3D replay design file](./.superdesign/design_iterations/jetjet_replay_1.html) | Complete trajectory replay |

</div>

## 🚀 Getting Started

### 📱 Requirements
- **iOS 17.0+** (iPhone/iPad)
- **Xcode 15.0+**
- **Real device testing** (requires CoreMotion sensors)

## 🎯 Development Roadmap

### ✅ Completed
- [x] **Real-time 3D flight** - Wave phone = fly plane
- [x] **Complete data recording** - Every movement recorded
- [x] **Sci-fi interface** - Dynamic starfield + neon effects
- [x] **Complete design files** - 5 HTML design files

### 🚧 Coming Soon
- [ ] **3D trajectory replay** - 360° flight reliving
- [ ] **Real aircraft models** - Replace 3D arrow
- [ ] **Data export** - CSV/JSON formats
- [ ] **Apple Vision Pro** - Spatial computing experience
- [ ] **RoNIN tech upgrade** - Neural network inertial navigation based on [RoNIN](https://ronin.cs.sfu.ca/) paper, achieving precise velocity calculation without GPS dependency. [Conversation link](https://chat.z.ai/s/c8855f52-7457-4160-90ec-1652376e4998)

## 🤝 Contributing

### 🎯 All contributions welcome!
- **🐛 Bug fixes** - Report any issues
- **✨ New features** - PRs welcome for good ideas
- **🎨 UI improvements** - Design files provided for reference
- **📚 Documentation** - Help improve README

### 💡 Quick contribution process
1. **Fork the project**
2. **Check design files** - Reference designs in `.superdesign/`
3. **Develop features** - Maintain design consistency
4. **Submit PR** - We'll review quickly

## 📄 License

**GPL-3.0 License** - Open source and free, welcome to fork!

## 📄 Copyright Information & Acknowledgments

### 🎨 3D Model Resources

**Aircraft 3D Model**
- **Model Name**: Little Jet Plane
- **Author**: macouno
- **Release Date**: January 10, 2014
- **License Type**: [CC BY (Creative Commons - Attribution)](https://creativecommons.org/licenses/by/4.0/)
- **Original Source**: [Thingiverse - Little Jet Plane](https://www.thingiverse.com/thing:222309)

**Usage Note**: Under CC BY license, we can freely use, modify, and distribute this model. The only requirement is to maintain attribution to the original author.

### 🎵 Audio Resources

- **[Pixabay](https://pixabay.com/)** - High-quality sound effects under Pixabay License

### 🛠️ Development Tools

- **[superdesign](https://github.com/superdesigndev/superdesign)** - Design file generation prompts

### 📱 Application Copyright

- **JETJETJET** © 2025 Chii Magnus
- **License**: GPL-3.0 License
- **Tech Stack**: Built on Apple native frameworks (SwiftUI, SceneKit, CoreMotion, SwiftData)

<div align="center">

*Made with ❤️ by [Chii Magnus](https://github.com/chiimagnus)*

**If this project catches your eye, please give us a ⭐️**

</div>
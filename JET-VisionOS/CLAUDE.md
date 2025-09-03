# JET-VisionOS CLAUDE.md

本文件为 Claude Code (claude.ai/code) 在处理 JET-VisionOS 目标代码时提供指导，该目标专为 Apple Vision Pro 设计。

## 概述

JET-VisionOS 目标将 JETJETJET 的核心飞行数据记录功能扩展到 Apple Vision Pro 的空间计算环境中。它利用 visionOS 的特定功能，创造沉浸式的 3D 飞行可视化体验。

## visionOS 开发指南

### 核心概念
- 使用 SwiftUI 构建空间界面，充分利用 visionOS 的沉浸感光谱
- 实现窗口式和完全沉浸式体验
- 利用 RealityKit 进行高级 3D 渲染和空间交互
- 以手势和眼球追踪作为主要输入方式设计

### 关键 visionOS 功能的运用

#### 沉浸式空间
- 使用 `ImmersiveSpace` 和相关 API 创建沉浸式体验
- 在窗口模式和沉浸模式之间实现适当的场景转换
- 在 SwiftUI 中使用 `RealityView` 来展示自定义 RealityKit 内容

#### 空间交互
- 为手势操作设计（点击、捏合、拖拽、缩放、旋转）
- 支持眼球追踪进行元素选择
- 使用内置 SwiftUI 手势和 ARKit 实现自定义手势识别

#### 3D 内容集成
- 使用 RealityKit 和 Reality Composer Pro 创建高级 3D 场景
- 在 3D 空间中适当定位和调整窗口大小
- 在相关场景中实现物体追踪和平面检测

#### 性能考虑
- 优化 UI 和 RealityKit 内容的渲染成本
- 遵循 visionOS 性能最佳实践
- 尽可能在实际 Apple Vision Pro 硬件上测试

### 架构模式
- 在适当情况下扩展现有的 ViewModels 以实现 visionOS 特定功能
- 创建利用空间计算能力的 visionOS 特定 Views
- 在可能的情况下使用主 JETJETJET 目标中的共享 Models 和 Services

### Notion 开发资源
- 参考 [visionOS 开发 Notion 数据库](https://www.notion.so/crhlove/261be9d6386a80718480deccb539f276?v=261be9d6386a806c902f000cc0d1930f&source=copy_link) 获取更多资源和文档
- 将新的相关资源添加到 Notion 数据库中以维护全面的知识库

### Apple 文档参考
- [visionOS 文档](https://developer.apple.com/documentation/visionOS)
- [向您的应用添加 3D 内容](https://developer.apple.com/documentation/visionOS/adding-3d-content-to-your-app)
- [创建完全沉浸式体验](https://developer.apple.com/documentation/visionOS/creating-fully-immersive-experiences)
- [为 visionOS 设计](https://developer.apple.com/design/human-interface-guidelines/designing-for-visionos)

## 开发任务

### 创建新功能
1. 遵循 MVVM 模式，使用 SwiftUI Views 和 Observable ViewModels
2. 在适当情况下利用主目标中的现有 Services、Models、ViewModels
3. 使用 visionOS 特定 API 实现空间交互
4. 测试窗口式和沉浸式体验

### 处理 3D 内容
1. 使用 RealityKit 进行高级 3D 渲染
2. 为复杂场景创建 Reality Composer Pro 项目
3. 使用头部和设备变换定位实体
4. 在适当的沉浸式环境中启用视频反射

## 最佳实践

### UI/UX 设计
- 遵循 Apple 的 visionOS 人机界面指南
- 为亲密和完全沉浸式体验进行设计
- 确保 3D 空间中 UI 元素的适当大小和定位
- 在不同沉浸级别之间实现流畅的过渡

### 性能
- 使用 Xcode 工具定期分析应用性能
- 优化 RealityKit 内容渲染成本
- 减少 visionOS 中的 UI 渲染成本
- 实现高效的场景恢复模式

### 兼容性
- 确保应用在窗口模式和沉浸模式下都能良好运行
- 考虑现有 iOS 功能如何转换到 visionOS
- 在 iOS 和 visionOS 版本之间适当保持功能一致性

## 共享文件和跨目标资源

### 项目目标
1. **JETJETJET** - 主 iOS 应用目标
2. **JET-VisionOS** - VisionOS 应用目标，用于 Apple Vision Pro

### 共享资源
iOS 和 visionOS 共享的代码文件可见 [project.pbxproj](../JETJETJET.xcodeproj/project.pbxproj)

目前共享的文件有（存放在`JETJETJET/`文件夹中）：
```
JETJETJET/Models/FlightData.swift
JETJETJET/Models/FlightSession.swift
JETJETJET/Models/LightSourceSettings.swift

JETJETJET/Resources/Localizable.xcstrings
JETJETJET/Resources/Whoosh Epic Explosion.mp3
JETJETJET/Resources/Whoosh Sound Effect.mp3

JETJETJET/Services/MotionService.swift
JETJETJET/Services/SoundService.swift

JETJETJET/Utils/AppConfig.swift
JETJETJET/Utils/UserPreferences.swift

JETJETJET/ViewModels/AirplaneModelVM.swift
JETJETJET/ViewModels/FlightDataDetailVM.swift
JETJETJET/ViewModels/FlightHistoryVM.swift
JETJETJET/ViewModels/FlightRecordingVM.swift
JETJETJET/Views/3D/Airplane3DModel.swift
JETJETJET/Views/3D/Airplane3DSceneView.swift
```

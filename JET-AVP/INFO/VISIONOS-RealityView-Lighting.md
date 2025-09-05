## visionOS：RealityView 与灯光（Directional / IBL）速记

### 何时使用 RealityView（而非 Model3D）
- **需要可编程灯光/阴影/多光源/IBL 时，使用 `RealityView`。**
- `Model3D` 更偏展示型，无法直接向场景添加与控制 RealityKit 光源实体；若仅依赖模型自带或默认环境光，可继续用 `Model3D`，但不便于动态控制灯光参数。

### 最小可用示例：`DirectionalLight` 与按钮切换颜色
以下示例展示从 `Model3D` 迁移到 `RealityView`，添加方向光并通过按钮切换光源颜色。

```swift
import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    @State private var light: DirectionalLight?
    @State private var anchor = AnchorEntity(.world)

    var body: some View {
        ZStack {
            RealityView { content in
                // 1) 添加根锚点
                content.add(anchor)

                // 2) 加载模型（来自 RealityKitContent 包）
                if let model = try? await Entity(named: "jet", in: realityKitContentBundle) {
                    anchor.addChild(model)
                }

                // 3) 添加可控方向光
                let dirLight = DirectionalLight()
                dirLight.light.intensity = 20000
                dirLight.light.color = .white
                dirLight.look(at: .zero, from: [0.8, 1.2, 1.2], relativeTo: nil)
                anchor.addChild(dirLight)
                self.light = dirLight
            }

            Button("切换颜色") {
                guard let light else { return }
                // 简单示例：在暖/冷色之间切换
                light.light.color = (light.light.color == .white) ? .cyan : .white
            }
            .glassBackgroundEffect(in: .capsule)
        }
    }
}
```

提示：如需阴影，可配置 `DirectionalLightComponent.Shadow`；如需多光源，可创建多个 `DirectionalLight`/`SpotLight`/`PointLight` 并挂到锚点上。

### IBL（基于图像的光照）与环境资源
- 使用 `EnvironmentResource` 为场景提供 IBL/天空盒等环境光照信息。
- 你可以加载 HDR/EXR 等环境贴图资源并赋予场景的环境光照设置，以获得更自然的反射与漫反射效果。
- 具体 API 以文档为准（不同版本的 RealityKit/visionOS 对 `RealityView` 的环境设置接口略有差异）。

### 参考与延伸阅读（Apple Docs）
- **RealityView（RealityKit / visionOS 3D 容器）**：[`RealityView`](https://developer.apple.com/documentation/realitykit/realityview/)
- **方向光组件**：[`DirectionalLightComponent`](https://developer.apple.com/documentation/realitykit/directionallightcomponent/)
- **方向光实体**：[`DirectionalLight`](https://developer.apple.com/documentation/realitykit/directionallight/)
- **具备方向光能力的协议**：[`HasDirectionalLight`](https://developer.apple.com/documentation/realitykit/hasdirectionallight/)
- **环境资源（用于 IBL/天空盒）**：[`EnvironmentResource`](https://developer.apple.com/documentation/realitykit/environmentresource/)
- **在 visionOS 中添加 3D 内容（总览）**：[`Adding 3D content to your app`](https://developer.apple.com/documentation/visionos/adding-3d-content-to-your-app/)
- **RealityKit 更新与最佳实践**：[`RealityKit updates`](https://developer.apple.com/documentation/updates/realitykit/)

### 实战结论（TL;DR）
- **要做实时可控灯光/阴影/IBL：用 `RealityView`。**
- `Model3D` 适合快速展示模型，不适合可编程灯光控制。
- 方向光+按钮切色是入门级交互；进阶可叠加阴影、聚光、点光源与 IBL。

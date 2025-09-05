import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    @State private var root = Entity()
    @State private var dirLight: DirectionalLight?
    @State private var lightMode = 0

    var body: some View {
        ZStack {
            RealityView { content in
                content.add(root)

                if let model = try? await Entity(named: "jet", in: realityKitContentBundle) {
                    root.addChild(model)
                }

                let light = DirectionalLight()
                light.light.intensity = 20000
                light.light.color = .white
                light.look(at: .zero, from: SIMD3<Float>(0.8, 1.2, 1.2), relativeTo: nil)
                root.addChild(light)
                self.dirLight = light
            }
            
            Button("切换灯光效果") {
                guard let dirLight else { return }
                lightMode = (lightMode + 1) % 4
                switch lightMode {
                case 0: // 中性方向光
                    dirLight.isEnabled = true
                    dirLight.light.color = .white
                    dirLight.light.intensity = 20000
                    dirLight.look(at: .zero, from: SIMD3<Float>(0.8, 1.2, 1.2), relativeTo: nil)
                case 1: // 暖色强光（顶光偏前）
                    dirLight.isEnabled = true
                    dirLight.light.color = .orange
                    dirLight.light.intensity = 45000
                    dirLight.look(at: .zero, from: SIMD3<Float>(0.2, 2.0, 1.0), relativeTo: nil)
                case 2: // 冷色侧光（边缘轮廓）
                    dirLight.isEnabled = true
                    dirLight.light.color = .cyan
                    dirLight.light.intensity = 30000
                    dirLight.look(at: .zero, from: SIMD3<Float>(-1.4, 0.8, 0.2), relativeTo: nil)
                default: // 关闭方向光（仅保留默认环境）
                    dirLight.isEnabled = false
                }
            }
                .glassBackgroundEffect(in: .capsule)
        }

    }
}

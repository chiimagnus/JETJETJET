import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveView: View {
    @State private var enlarge = false

    var body: some View {
        RealityView { content in
            // Add the initial RealityKit content
            if let model = try? await Entity(named: "Immersive", in: realityKitContentBundle) {
                content.add(model)
            }
        }
    }
}

// 注意：ImmersiveSpace的内容在Xcode预览中无法正常显示
// 因为预览环境不支持RealityKit的异步加载和渲染
// 如果需要预览，请使用ContentView而不是ImmersiveView

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    @State private var root = Entity()
    @State private var dirLight: DirectionalLight?

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
                light.look(at: .zero, from: [0.8, 1.2, 1.2], relativeTo: nil)
                root.addChild(light)
                self.dirLight = light
            }
            
            Button("切换颜色") {
                guard let dirLight else { return }
                dirLight.light.color = (dirLight.light.color == .white) ? .cyan : .white
            }
                .glassBackgroundEffect(in: .capsule)
        }

    }
}

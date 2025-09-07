import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    @State private var enlarge = false
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace

    var body: some View {
        VStack {
            RealityView { content in
                // Add the initial RealityKit content
                if let model = try? await Entity(named: "jet", in: realityKitContentBundle) {
                    // Add collision component to make the model interactive
                    model.components.set(CollisionComponent(shapes: [.generateBox(size: SIMD3<Float>(0.5, 0.5, 0.5))]))
                    // Add input target component to enable gesture recognition
                    model.components.set(InputTargetComponent())

                    content.add(model)
                }
            } update: { content in
                // Update the RealityKit content when SwiftUI state changes
                if let model = content.entities.first {
                    let uniformScale: Float = enlarge ? 1.4 : 1.0
                    model.transform.scale = [uniformScale, uniformScale, uniformScale]
                }
            }
            .gesture(
                SpatialTapGesture()
                    .targetedToAnyEntity()
                    .onEnded { _ in
                        enlarge.toggle()
                    }
            )

            VStack(spacing: 16) {
                HStack(spacing: 20) {
                    Toggle("放大模型", isOn: $enlarge)
                        .toggleStyle(.button)

                    Button(action: {
                        Task {
                            await openImmersiveSpace(id: "ImmersiveSpace")
                        }
                    }) {
                        Text("进入沉浸式空间")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 12)
                            .background(Color.blue.opacity(0.8))
                            .cornerRadius(12)
                    }
                }
            }
            .padding()
            .glassBackgroundEffect()
        }
    }
}

#Preview {
    ContentView()
}

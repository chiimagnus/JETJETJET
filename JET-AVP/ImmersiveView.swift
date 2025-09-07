import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveView: View {
    @State private var enlarge = false

    var body: some View {
        RealityView { content in
            // Add the initial RealityKit content
            if let model = try? await Entity(named: "jet", in: realityKitContentBundle) {
                // Add collision component to make the model interactive
                model.components.set(CollisionComponent(shapes: [.generateBox(size: SIMD3<Float>(0.5, 0.5, 0.5))]))
                // Add input target component to enable gesture recognition
                model.components.set(InputTargetComponent())

                // Position the model in the immersive space
                model.position = SIMD3<Float>(0, 0, -2) // Place 2 meters in front

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
    }
}

#Preview {
    ImmersiveView()
}

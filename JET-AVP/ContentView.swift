import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    var body: some View {
        RealityView { content in
            if let model = try? await Entity(named: "jet", in: realityKitContentBundle) {
                content.add(model)
            }
        }
    }
}

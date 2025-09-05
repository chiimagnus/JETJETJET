import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {

    var body: some View {
        VStack {
            Model3D(named: "jet", bundle: realityKitContentBundle)
        }
    }
}

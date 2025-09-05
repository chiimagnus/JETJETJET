import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {

    var body: some View {
        Model3D(named: "jet", bundle: realityKitContentBundle)
//            .padding3D(.bottom, 2000)
        
    }
}

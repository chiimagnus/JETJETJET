import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {

    var body: some View {
        ZStack {
            Model3D(named: "jet", bundle: realityKitContentBundle)
                .padding3D(.bottom, 1000)
            
            Button("切换颜色") {
                
            }
                .glassBackgroundEffect(in: .capsule)
        }

    }
}

import SwiftUI

@main
struct JET_AVPApp: App {

    var body: some Scene {
        WindowGroup {
            MainView2D()
        }

        WindowGroup {
            ContentView()
        }
        .windowStyle(.volumetric)
        .defaultSize(width: 0.8, height: 0.8, depth: 0.8, in: .meters)

        ImmersiveSpace(id: "ImmersiveSpace"){
            ImmersiveView()
        }
    }
}

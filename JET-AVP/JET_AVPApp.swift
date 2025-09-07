import SwiftUI

@main
struct JET_AVPApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowStyle(.volumetric)
        // .defaultSize(width: 4096, height: 4096, depth: 4096)
        
        ImmersiveSpace(id: "ImmersiveSpace"){
            ImmersiveView()
        }
    }
}

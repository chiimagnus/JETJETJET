//
//  JETVisionOSApp.swift
//  JETVisionOS
//
//  Created by chii_magnus on 2025/9/9.
//

import SwiftUI

@main
struct JETVisionOSApp: App {

    @State private var appModel = AppModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appModel)
        }
        
        // Volumetric Jet Model Window Group
        WindowGroup(id: "volumetricJet") {
            VolumetricJetView()
                .environment(appModel)
        }
        .windowStyle(.volumetric)

        ImmersiveSpace(id: appModel.immersiveSpaceID) {
            ImmersiveView()
                .environment(appModel)
                .onAppear {
                    appModel.immersiveSpaceState = .open
                }
                .onDisappear {
                    appModel.immersiveSpaceState = .closed
                }
        }
        .immersionStyle(selection: .constant(.mixed), in: .mixed)
     }
}

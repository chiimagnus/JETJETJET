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
        
        // 需要具备id标识符，因为需要和主窗口区分开来——没有加id标识符的就是主窗口。
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

//
//  JET_AVPApp.swift
//  JET-AVP
//
//  Created by chii_magnus on 2025/9/5.
//

import SwiftUI

@main
struct JET_AVPApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowStyle(.volumetric)
        .defaultSize(width: 4096, height: 4096, depth: 4096)
    }
}

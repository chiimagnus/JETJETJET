//
//  JET_AVPApp.swift
//  JET-AVP
//
//  Created by chii_magnus on 2025/9/5.
//

import SwiftUI

@main
struct JET_AVPApp: App {

    @State private var appModel = AppModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appModel)
        }
    }
}
//
//  JETJETJETApp.swift
//  JETJETJET
//
//  Created by chii_magnus on 2025/7/29.
//

import SwiftUI
import SwiftData

@main
struct JETJETJETApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            FlightData.self,
            FlightSession.self,
        ])
        let modelConfiguration = ModelConfiguration(
            schema: schema, 
            isStoredInMemoryOnly: false,
            cloudKitDatabase: .automatic // 添加这行启用iCloud同步
        )

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            FlightRecordingView()
        }
        .modelContainer(sharedModelContainer)
    }
}

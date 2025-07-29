import SwiftUI
import SwiftData

@main
struct JETJETJETApp: App {
    // iCloud同步开关 - 设置为false禁用云同步
    private static let enableCloudSync = false
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            FlightData.self,
            FlightSession.self,
        ])
        
        let modelConfiguration: ModelConfiguration
        
        if enableCloudSync {
            // 启用iCloud同步的配置
            modelConfiguration = ModelConfiguration(
                schema: schema,
                isStoredInMemoryOnly: false,
                cloudKitDatabase: .automatic
            )
        } else {
            // 禁用iCloud同步的配置 - 仅本地存储
            modelConfiguration = ModelConfiguration(
                schema: schema,
                isStoredInMemoryOnly: false
            )
        }

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

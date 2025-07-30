import Foundation
import SwiftData

@Observable
class FlightHistoryVM {
    private var modelContext: ModelContext?
    
    // 错误状态
    var errorMessage: String?
    
    init() {}
    
    func setModelContext(_ context: ModelContext) {
        self.modelContext = context
    }
    
    func deleteSessions(at offsets: IndexSet, from sessions: [FlightSession]) {
        guard modelContext != nil else {
            errorMessage = "数据上下文不可用"
            return
        }
        
        for index in offsets {
            let session = sessions[index]
            deleteSession(session)
        }
    }
    
    private func deleteSession(_ session: FlightSession) {
        guard let modelContext = modelContext else { return }
        
        // 删除相关的飞行数据
        let sessionId = session.id
        let request = FetchDescriptor<FlightData>(
            predicate: #Predicate<FlightData> { data in
                data.sessionId == sessionId
            }
        )

        do {
            let relatedData = try modelContext.fetch(request)
            for data in relatedData {
                modelContext.delete(data)
            }
            
            // 删除会话
            modelContext.delete(session)
            
            errorMessage = nil
        } catch {
            print("删除相关数据失败: \(error)")
            errorMessage = "删除数据失败: \(error.localizedDescription)"
        }
    }
}

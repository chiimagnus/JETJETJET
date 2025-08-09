import Foundation
import SwiftData

@Observable
class FlightHistoryVM {
    private var modelContext: ModelContext?

    // 搜索状态
    var searchText: String = ""

    // 错误状态
    var errorMessage: String?

    // 缓存的飞行统计数据
    private var flightStatsCache: [UUID: FlightStats] = [:]

    init() {}
    
    func setModelContext(_ context: ModelContext) {
        self.modelContext = context
    }
    
    func deleteSessions(at offsets: IndexSet, from sessions: [FlightSession]) {
        guard modelContext != nil else {
            errorMessage = NSLocalizedString("error_data_context_unavailable", comment: "Data context unavailable error message")
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
        let sessionId: UUID? = session.id
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
            errorMessage = String(format: NSLocalizedString("error_delete_data_failed", comment: "Delete data failed error message"), error.localizedDescription)
        }
    }

    // MARK: - 搜索功能
    func filteredSessions(_ sessions: [FlightSession]) -> [FlightSession] {
        if searchText.isEmpty {
            return sessions
        }

        return sessions.filter { session in
            session.title.localizedCaseInsensitiveContains(searchText) ||
            session.flightDescription.localizedCaseInsensitiveContains(searchText) ||
            formatDate(session.startTime).localizedCaseInsensitiveContains(searchText)
        }
    }

    // MARK: - 飞行统计数据
    func getFlightStats(for session: FlightSession) -> FlightStats {
        // 检查缓存
        if let cachedStats = flightStatsCache[session.id] {
            return cachedStats
        }

        // 获取飞行数据并计算统计
        guard let modelContext = modelContext else {
            return FlightStats()
        }

        let sessionId: UUID? = session.id
        let request = FetchDescriptor<FlightData>(
            predicate: #Predicate<FlightData> { data in
                data.sessionId == sessionId
            }
        )

        do {
            let flightData = try modelContext.fetch(request)
            let stats = session.getFlightStats(from: flightData)

            // 缓存结果
            flightStatsCache[session.id] = stats

            return stats
        } catch {
            print("获取飞行数据失败: \(error)")
            return FlightStats()
        }
    }

    // MARK: - 工具方法
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }

    func clearStatsCache() {
        flightStatsCache.removeAll()
    }
}

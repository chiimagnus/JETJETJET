//
//  FlightHistoryView.swift
//  JETJETJET
//
//  Created by chii_magnus on 2025/7/29.
//

import SwiftUI
import SwiftData

struct FlightHistoryView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \FlightSession.startTime, order: .reverse) private var flightSessions: [FlightSession]

    var body: some View {
        NavigationView {
            List {
                ForEach(flightSessions, id: \.id) { session in
                    NavigationLink(destination: AirplaneModelView(session: session)) {
                        FlightSessionRow(session: session)
                    }
                }
                .onDelete(perform: deleteSessions)
            }
            .navigationTitle("飞行历史")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
        }
    }

    private func deleteSessions(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                let session = flightSessions[index]

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
                } catch {
                    print("删除相关数据失败: \(error)")
                }

                // 删除会话
                modelContext.delete(session)
            }
        }
    }
}

struct FlightSessionRow: View {
    let session: FlightSession

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(session.title)
                    .font(.headline)
                Spacer()
                Text(formatDate(session.startTime))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            HStack {
                Label("\(session.dataCount) 条数据", systemImage: "chart.line.uptrend.xyaxis")
                    .font(.caption)
                    .foregroundColor(.blue)

                Spacer()

                Label(session.formattedDuration, systemImage: "clock")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    FlightHistoryView()
        .modelContainer(for: [FlightData.self, FlightSession.self], inMemory: true)
}

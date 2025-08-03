import SwiftUI
import SwiftData

struct FlightHistoryView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \FlightSession.startTime, order: .reverse) private var flightSessions: [FlightSession]
    @State private var viewModel = FlightHistoryVM()

    var body: some View {
        VStack {
            List {
                ForEach(flightSessions, id: \.id) { session in
                    NavigationLink(destination: AirplaneModelView(session: session)) {
                        FlightSessionRow(session: session)
                    }
                }
                .onDelete(perform: deleteSessions)
            }

            // 错误信息显示
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .navigationTitle("飞行历史")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
        }
        .onAppear {
            viewModel.setModelContext(modelContext)
        }
    }

    private func deleteSessions(offsets: IndexSet) {
        withAnimation {
            viewModel.deleteSessions(at: offsets, from: flightSessions)
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

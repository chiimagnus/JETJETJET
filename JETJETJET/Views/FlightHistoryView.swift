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
    @Query(sort: \FlightData.timestamp, order: .reverse) private var flightData: [FlightData]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(groupedFlightData, id: \.key) { group in
                    Section(header: Text(formatDate(group.key))) {
                        ForEach(group.value, id: \.timestamp) { data in
                            FlightDataRow(data: data)
                        }
                        .onDelete { indexSet in
                            deleteItems(from: group.value, at: indexSet)
                        }
                    }
                }
            }
            .navigationTitle("飞行历史")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
        }
    }
    
    // 按日期分组飞行数据
    private var groupedFlightData: [(key: Date, value: [FlightData])] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: flightData) { data in
            calendar.startOfDay(for: data.timestamp)
        }
        return grouped.sorted { $0.key > $1.key }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    private func deleteItems(from group: [FlightData], at offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(group[index])
            }
        }
    }
}

struct FlightDataRow: View {
    let data: FlightData
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(formatTime(data.timestamp))
                    .font(.headline)
                Spacer()
                Text("速度: \(String(format: "%.2f", data.speed))")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            HStack(spacing: 20) {
                DataPoint(label: "俯仰", value: data.pitch, unit: "°")
                DataPoint(label: "横滚", value: data.roll, unit: "°")
                DataPoint(label: "偏航", value: data.yaw, unit: "°")
            }
        }
        .padding(.vertical, 2)
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        return formatter.string(from: date)
    }
}

struct DataPoint: View {
    let label: String
    let value: Double
    let unit: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label)
                .font(.caption2)
                .foregroundColor(.secondary)
            Text("\(String(format: "%.1f", value))\(unit)")
                .font(.caption)
                .fontWeight(.medium)
        }
    }
}

#Preview {
    FlightHistoryView()
        .modelContainer(for: FlightData.self, inMemory: true)
}

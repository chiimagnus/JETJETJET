import SwiftUI

// MARK: - 实时飞行数据显示组件
struct RealtimeFlightDataView: View {
    let flightData: FlightData

    var body: some View {
        VStack(spacing: 12) {
            // 标题
            HStack {
                Text(NSLocalizedString("realtime_flight_data_title", comment: "Realtime flight data title"))
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.blue)

                Spacer()
            }

            // 复用现有的HUD数据条样式
            HUDDataBarView(snapshot: FlightDataSnapshot(
                timestamp: flightData.timestamp,
                acceleration: flightData.acceleration,
                speed: flightData.speed,
                pitch: flightData.pitch,
                roll: flightData.roll,
                yaw: flightData.yaw
            ))
        }
        .padding(16)
        .background(.ultraThinMaterial)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.blue.opacity(0.3), lineWidth: 1)
        )
    }
}

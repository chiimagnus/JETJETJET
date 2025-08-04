import SwiftUI

// MARK: - 实时飞行数据显示组件
struct RealtimeFlightDataView: View {
    let flightData: FlightData
    
    var body: some View {
        VStack(spacing: 12) {
            // 标题
            HStack {
                Text("当前时刻飞行数据")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.blue)
                
                Spacer()
            }
            
            // 数据网格
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                FlightDataCard(
                    title: "PITCH",
                    value: flightData.pitch,
                    unit: "°",
                    color: .green
                )
                
                FlightDataCard(
                    title: "ROLL",
                    value: flightData.roll,
                    unit: "°",
                    color: .orange
                )
                
                FlightDataCard(
                    title: "YAW",
                    value: flightData.yaw,
                    unit: "°",
                    color: .purple
                )
                
                FlightDataCard(
                    title: "SPEED",
                    value: flightData.speed,
                    unit: "m/s",
                    color: .blue
                )
            }
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

// MARK: - 飞行数据卡片组件
struct FlightDataCard: View {
    let title: String
    let value: Double
    let unit: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            // 数值
            Text(formattedValue)
                .font(.system(size: 20, weight: .bold, design: .monospaced))
                .foregroundColor(color)
                .shadow(color: color.opacity(0.5), radius: 2)
            
            // 标签
            Text(title)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.gray)
                .textCase(.uppercase)
                .kerning(1)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
    }
    
    private var formattedValue: String {
        if title == "SPEED" {
            return String(format: "%.1f", abs(value)) + unit
        } else {
            return String(format: "%.0f", value) + unit
        }
    }
}

// MARK: - 扩展版实时数据显示（包含更多信息）
struct ExtendedRealtimeFlightDataView: View {
    let flightData: FlightData
    let currentIndex: Int
    let totalCount: Int
    
    var body: some View {
        VStack(spacing: 16) {
            // 主要数据
            RealtimeFlightDataView(flightData: flightData)
            
            // 附加信息
            additionalInfo
        }
    }
    
    private var additionalInfo: some View {
        HStack(spacing: 20) {
            // 数据点信息
            VStack(spacing: 4) {
                Text("\(currentIndex + 1)")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                Text("/ \(totalCount)")
                    .font(.caption)
                    .foregroundColor(.gray)
                Text("数据点")
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .textCase(.uppercase)
            }
            
            Spacer()
            
            // 时间戳
            VStack(spacing: 4) {
                Text(timeString)
                    .font(.system(size: 14, weight: .medium, design: .monospaced))
                    .foregroundColor(.white)
                Text("时间戳")
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .textCase(.uppercase)
            }
            
            Spacer()
            
            // G力估算
            VStack(spacing: 4) {
                Text(gForceString)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.red)
                Text("G力")
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .textCase(.uppercase)
            }
        }
        .padding(12)
        .background(.ultraThinMaterial)
        .cornerRadius(8)
    }
    
    private var timeString: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        return formatter.string(from: flightData.timestamp)
    }
    
    private var gForceString: String {
        // 简单的G力估算（基于速度变化）
        let gForce = sqrt(flightData.speed * flightData.speed) / 9.81
        return String(format: "%.1fG", max(1.0, gForce))
    }
}

// MARK: - 数据趋势指示器
struct DataTrendIndicator: View {
    let currentValue: Double
    let previousValue: Double
    let color: Color
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: trendIcon)
                .font(.caption2)
                .foregroundColor(trendColor)
            
            Text(trendText)
                .font(.caption2)
                .foregroundColor(trendColor)
        }
    }
    
    private var trendIcon: String {
        let diff = currentValue - previousValue
        if abs(diff) < 0.1 {
            return "minus"
        } else if diff > 0 {
            return "arrow.up"
        } else {
            return "arrow.down"
        }
    }
    
    private var trendColor: Color {
        let diff = currentValue - previousValue
        if abs(diff) < 0.1 {
            return .gray
        } else if diff > 0 {
            return .green
        } else {
            return .red
        }
    }
    
    private var trendText: String {
        let diff = abs(currentValue - previousValue)
        return String(format: "%.1f", diff)
    }
}

#Preview {
    let sampleData = FlightData(
        timestamp: Date(),
        speed: 2.5,
        pitch: 15.0,
        roll: -8.0,
        yaw: 25.0
    )
    
    return VStack(spacing: 20) {
        RealtimeFlightDataView(flightData: sampleData)
        
        ExtendedRealtimeFlightDataView(
            flightData: sampleData,
            currentIndex: 45,
            totalCount: 100
        )
    }
    .padding()
    .background(.black)
}

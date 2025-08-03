import SwiftUI

struct HeaderView: View {
    @State private var batteryLevel: Int = 89
    
    var body: some View {
        GlassCard {
            VStack(spacing: 8) {
                HStack {
                    // 主标题
                    HStack(spacing: 4) {
                        Text("✈️")
                            .font(.title2)
                        Text("J E T J E T J E T")
                            .font(.custom("Orbitron", size: 24))
                            .fontWeight(.bold)
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.cyan, .blue],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .shadow(color: .cyan.opacity(0.5), radius: 10)
                    }
                    
                    Spacer()
                    
                    // 电池指示器
                    HStack(spacing: 6) {
                        Image(systemName: "bolt.fill")
                            .foregroundColor(.green)
                            .font(.caption)
                        Text("\(batteryLevel)%")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.green)
                    }
                }
                
                // 副标题
                Text("F L I G H T   S Y S T E M")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                    .tracking(2)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
    }
}

#Preview {
    HeaderView()
        .preferredColorScheme(.dark)
}

import SwiftUI

struct FlightStatusIndicator: View {
    @State private var isPulsing = false
    
    var body: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(Color.green)
                .frame(width: 6, height: 6)
                .scaleEffect(isPulsing ? 1.2 : 1.0)
                .opacity(isPulsing ? 0.7 : 1.0)
                .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: isPulsing)
            
            Text("完成")
                .font(.system(.caption, design: .rounded, weight: .semibold))
                .foregroundColor(.green)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.green.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.green, lineWidth: 1)
                )
        )
        .onAppear {
            isPulsing = true
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        FlightStatusIndicator()
        
        HStack {
            FlightStatusIndicator()
            Spacer()
        }
        .padding()
        .background(Color.black)
    }
    .preferredColorScheme(.dark)
}

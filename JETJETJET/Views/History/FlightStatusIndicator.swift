import SwiftUI

struct FlightStatusIndicator: View {
    var body: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(Color.green)
                .frame(width: 6, height: 6)
            
            Text(NSLocalizedString("flight_status_completed", comment: "Flight status completed"))
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

import SwiftUI

struct NeonButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    @State private var isPressed = false
    @State private var glowIntensity: Double = 0.5
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .tracking(1)
            }
            .foregroundColor(isPressed ? .black : color)
            .padding(.horizontal, 32)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(isPressed ? color : Color.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(color, lineWidth: 2)
                    )
            )
            .shadow(color: color.opacity(glowIntensity), radius: isPressed ? 20 : 10)
            .scaleEffect(isPressed ? 0.95 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
        .onAppear {
            withAnimation(
                .easeInOut(duration: 2.0)
                .repeatForever(autoreverses: true)
            ) {
                glowIntensity = 1.0
            }
        }
    }
}

struct MainActionButtonView: View {
    let isRecording: Bool
    let isCountingDown: Bool
    let onStart: () -> Void
    let onStop: () -> Void
    
    private var buttonTitle: String {
        if isCountingDown {
            return "CANCEL"
        } else if isRecording {
            return "STOP FLIGHT"
        } else {
            return "START FLIGHT"
        }
    }
    
    private var buttonIcon: String {
        if isCountingDown {
            return "xmark.circle.fill"
        } else if isRecording {
            return "stop.circle.fill"
        } else {
            return "play.circle.fill"
        }
    }
    
    private var buttonColor: Color {
        if isCountingDown {
            return .orange
        } else if isRecording {
            return .red
        } else {
            return .cyan
        }
    }
    
    var body: some View {
        NeonButton(
            title: buttonTitle,
            icon: buttonIcon,
            color: buttonColor
        ) {
            if isRecording || isCountingDown {
                onStop()
            } else {
                onStart()
            }
        }
    }
}

struct BottomFunctionView: View {
    var body: some View {
        HStack(spacing: 40) {
            // 日志按钮
            NavigationLink(destination: FlightHistoryView()) {
                FunctionButtonView(
                    icon: "chart.bar.fill",
                    label: "LOGS",
                    color: .blue
                )
            }
            
            // 设置按钮
            FunctionButtonView(
                icon: "gearshape.fill",
                label: "SETUP",
                color: .blue
            )
        }
    }
}

struct FunctionButtonView: View {
    let icon: String
    let label: String
    let color: Color
    
    @State private var isPressed = false
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(label)
                .font(.caption2)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
                .tracking(1)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
        )
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
    }
}

#Preview {
    VStack(spacing: 30) {
        MainActionButtonView(
            isRecording: false,
            isCountingDown: false,
            onStart: {},
            onStop: {}
        )
        
        MainActionButtonView(
            isRecording: false,
            isCountingDown: true,
            onStart: {},
            onStop: {}
        )
        
        MainActionButtonView(
            isRecording: true,
            isCountingDown: false,
            onStart: {},
            onStop: {}
        )
        
        BottomFunctionView()
    }
    .preferredColorScheme(.dark)
    .padding()
}

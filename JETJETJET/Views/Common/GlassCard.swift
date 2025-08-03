import SwiftUI

struct GlassCard<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(0.2),
                                        Color.white.opacity(0.05)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
                    .shadow(
                        color: Color.black.opacity(0.3),
                        radius: 8,
                        x: 0,
                        y: 4
                    )
            )
    }
}

#Preview {
    VStack(spacing: 20) {
        GlassCard {
            VStack {
                Text("Glass Card Example")
                    .font(.headline)
                Text("This is a glass morphism card")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
        }
        
        GlassCard {
            HStack {
                Image(systemName: "airplane")
                    .font(.title)
                    .foregroundColor(.blue)
                VStack(alignment: .leading) {
                    Text("JET Status")
                        .font(.headline)
                    Text("Ready for takeoff")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer()
            }
            .padding()
        }
    }
    .preferredColorScheme(.dark)
    .padding()
}

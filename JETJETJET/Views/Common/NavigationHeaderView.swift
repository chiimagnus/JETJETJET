import SwiftUI

enum NavigationTitleType {
    case main
    case preJeting
    case jeting
    
    var title: String {
        switch self {
        case .main: return "J E T J E T J E T"
        case .preJeting: return "P R E - J E T I N G"
        case .jeting: return "J E T I N G"
        }
    }
    
    var emoji: String {
        switch self {
        case .main: return "✈️"
        case .preJeting: return "🚀"
        case .jeting: return "✈️"
        }
    }
    
    var fontSize: CGFloat {
        switch self {
        case .main: return 24
        case .preJeting: return 20
        case .jeting: return 24
        }
    }
}

struct NavigationHeaderView: View {
    let titleType: NavigationTitleType
    let showRecordingBorder: Bool
    
    var body: some View {
        GlassCard {
            VStack(spacing: 8) {
                HStack {
                    // 主标题
                    HStack(spacing: 4) {
                        Text(titleType.emoji)
                            .font(.title2)
                        Text(titleType.title)
                            .font(.custom("Orbitron", size: titleType.fontSize))
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
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
        .overlay(
            // 录制状态边框（可选）
            Group {
                if showRecordingBorder {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(
                            LinearGradient(
                                colors: [Color.red.opacity(0.6), Color.red.opacity(0.2)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                }
            }
        )
        .background(
            // 录制状态背景（可选）
            Group {
                if showRecordingBorder {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.red.opacity(0.05))
                }
            }
        )
    }
}

#Preview {
    VStack(spacing: 20) {
        NavigationHeaderView(titleType: .main, showRecordingBorder: false)
        NavigationHeaderView(titleType: .preJeting, showRecordingBorder: false)
        NavigationHeaderView(titleType: .jeting, showRecordingBorder: true)
    }
    .preferredColorScheme(.dark)
    .padding()
}
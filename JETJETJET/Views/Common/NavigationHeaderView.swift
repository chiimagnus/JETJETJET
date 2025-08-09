import SwiftUI

enum NavigationTitleType {
    case main
    case jetting
    
    var title: String {
        switch self {
        case .main: return NSLocalizedString("main_view_title", comment: "Main view title")
        case .jetting: return NSLocalizedString("jetting_view_title", comment: "Jetting view title")
        }
    }
}

struct NavigationHeaderView: View {
    let titleType: NavigationTitleType
    
    var body: some View {
        GlassCard {
            VStack(spacing: 8) {
                HStack {
                    // 主标题 - 居中显示
                    HStack(spacing: 4) {
                        Text("🚀")
                            .font(.title2)
                        Text(titleType.title)
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
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        NavigationHeaderView(titleType: .main)
        NavigationHeaderView(titleType: .jetting)
    }
    .preferredColorScheme(.dark)
    .padding()
}
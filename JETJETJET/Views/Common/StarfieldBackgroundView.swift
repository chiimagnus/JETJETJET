import SwiftUI

struct StarfieldBackgroundView: View {
    var body: some View {
        // 简洁的渐变背景 - 大幅提升性能
        LinearGradient(
            gradient: Gradient(stops: [
                .init(color: Color(red: 0.15, green: 0.22, blue: 0.35), location: 0.0),
                .init(color: Color(red: 0.02, green: 0.02, blue: 0.04), location: 1.0)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}



#Preview {
    StarfieldBackgroundView()
}

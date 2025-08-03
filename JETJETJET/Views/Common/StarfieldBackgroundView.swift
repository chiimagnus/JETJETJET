import SwiftUI

struct StarfieldBackgroundView: View {
    var body: some View {
        // 简洁的渐变背景 - 大幅提升性能
        LinearGradient(
            gradient: Gradient(stops: [
                .init(color: Color(red: 0.11, green: 0.15, blue: 0.21), location: 0.0),
                .init(color: Color(red: 0.04, green: 0.04, blue: 0.06), location: 1.0)
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

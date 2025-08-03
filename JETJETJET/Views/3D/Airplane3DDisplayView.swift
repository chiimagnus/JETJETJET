import SwiftUI
import SceneKit

struct Airplane3DDisplayView: View {
    let airplane3DModel: Airplane3DModel

    // 自适应高度 - iPhone 16 Pro Max 使用更大的高度
    private var adaptiveHeight: CGFloat {
        UIScreen.main.bounds.height > 800 ? 280 : 250
    }
    
    var body: some View {
        ZStack {
            // 3D场景背景
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        gradient: Gradient(stops: [
                            .init(color: Color(red: 0.10, green: 0.10, blue: 0.18), location: 0.0),
                            .init(color: Color(red: 0.09, green: 0.13, blue: 0.24), location: 0.5),
                            .init(color: Color(red: 0.06, green: 0.20, blue: 0.38), location: 1.0)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
                
            // 3D飞机场景
            Airplane3DSceneView(
                airplane3DModel: airplane3DModel,
                height: nil,
                showControls: false
            )
        }
        .frame(height: adaptiveHeight)
    }
}

#Preview {
    Airplane3DDisplayView(airplane3DModel: Airplane3DModel())
        .preferredColorScheme(.dark)
}

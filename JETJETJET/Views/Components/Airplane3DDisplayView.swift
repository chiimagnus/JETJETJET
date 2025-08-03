import SwiftUI
import SceneKit

struct Airplane3DDisplayView: View {
    let airplane3DModel: Airplane3DModel
    @State private var floatingOffset: CGFloat = 0
    
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
            
            // 粒子效果背景
            ForEach(0..<6, id: \.self) { index in
                ParticleView(index: index)
            }
            
            // 3D飞机场景
            Airplane3DSceneView(
                airplane3DModel: airplane3DModel,
                height: nil,
                showControls: false
            )
            .offset(y: floatingOffset)
            .onAppear {
                withAnimation(
                    .easeInOut(duration: 4.0)
                    .repeatForever(autoreverses: true)
                ) {
                    floatingOffset = -10
                }
            }
            
            // 轨道指示器
            VStack {
                Spacer()
                HStack(spacing: 8) {
                    ForEach(0..<5, id: \.self) { index in
                        OrbitIndicatorView(index: index)
                    }
                }
                .padding(.bottom, 16)
            }
        }
        .frame(height: 250)
    }
}

struct ParticleView: View {
    let index: Int
    @State private var animationOffset: CGFloat = 0
    
    private var position: CGPoint {
        let positions: [CGPoint] = [
            CGPoint(x: 0.2, y: 0.3),
            CGPoint(x: 0.4, y: 0.7),
            CGPoint(x: 0.6, y: 0.2),
            CGPoint(x: 0.8, y: 0.6),
            CGPoint(x: 0.3, y: 0.8),
            CGPoint(x: 0.7, y: 0.4)
        ]
        return positions[index % positions.count]
    }
    
    var body: some View {
        Circle()
            .fill(Color.white)
            .frame(width: 2, height: 2)
            .opacity(0.6)
            .position(
                x: position.x * 300,
                y: position.y * 250 + animationOffset
            )
            .onAppear {
                withAnimation(
                    .linear(duration: 6.0)
                    .repeatForever(autoreverses: false)
                    .delay(Double(index) * 0.5)
                ) {
                    animationOffset = -300
                }
            }
    }
}

struct OrbitIndicatorView: View {
    let index: Int
    @State private var isActive: Bool = false
    
    var body: some View {
        Circle()
            .fill(Color.cyan)
            .frame(width: 8, height: 8)
            .opacity(isActive ? 1.0 : 0.3)
            .scaleEffect(isActive ? 1.2 : 1.0)
            .shadow(color: .cyan, radius: isActive ? 8 : 2)
            .onAppear {
                withAnimation(
                    .easeInOut(duration: 2.0)
                    .repeatForever(autoreverses: true)
                    .delay(Double(index) * 0.3)
                ) {
                    isActive.toggle()
                }
            }
    }
}

#Preview {
    Airplane3DDisplayView(airplane3DModel: Airplane3DModel())
        .preferredColorScheme(.dark)
}

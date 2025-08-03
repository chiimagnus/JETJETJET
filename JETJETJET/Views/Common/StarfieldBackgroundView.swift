import SwiftUI

struct StarfieldBackgroundView: View {
    @State private var animationOffset: CGFloat = 0
    
    var body: some View {
        ZStack {
            // 渐变背景
            LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: Color(red: 0.11, green: 0.15, blue: 0.21), location: 0.0),
                    .init(color: Color(red: 0.04, green: 0.04, blue: 0.06), location: 1.0)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // 星星层 - 减少数量以提升性能
            ForEach(0..<30, id: \.self) { index in
                StarView(index: index)
            }

            // 移动粒子效果 - 减少数量
            ForEach(0..<5, id: \.self) { index in
                MovingParticleView(index: index, animationOffset: animationOffset)
            }
        }
        .onAppear {
            withAnimation(.linear(duration: 20).repeatForever(autoreverses: false)) {
                animationOffset = 1000
            }
        }
    }
}

struct StarView: View {
    let index: Int
    @State private var opacity: Double = 0.3
    @State private var scale: CGFloat = 1.0
    
    private var position: CGPoint {
        let seed = Double(index * 123 + 456)
        return CGPoint(
            x: (seed.truncatingRemainder(dividingBy: 1.0)) * UIScreen.main.bounds.width,
            y: ((seed * 1.618).truncatingRemainder(dividingBy: 1.0)) * UIScreen.main.bounds.height
        )
    }
    
    private var animationDelay: Double {
        Double(index) * 0.1
    }
    
    var body: some View {
        Circle()
            .fill(Color.white)
            .frame(width: 2, height: 2)
            .opacity(opacity)
            .scaleEffect(scale)
            .position(position)
            .onAppear {
                withAnimation(
                    .easeInOut(duration: 3.0)
                    .repeatForever(autoreverses: true)
                    .delay(animationDelay)
                ) {
                    opacity = 1.0
                }
                
                withAnimation(
                    .easeInOut(duration: 2.0)
                    .repeatForever(autoreverses: true)
                    .delay(animationDelay * 0.5)
                ) {
                    scale = 1.5
                }
            }
    }
}

struct MovingParticleView: View {
    let index: Int
    let animationOffset: CGFloat
    
    private var startPosition: CGPoint {
        let seed = Double(index * 789 + 123)
        return CGPoint(
            x: (seed.truncatingRemainder(dividingBy: 1.0)) * UIScreen.main.bounds.width,
            y: UIScreen.main.bounds.height + 50
        )
    }
    
    private var endPosition: CGPoint {
        CGPoint(
            x: startPosition.x + CGFloat.random(in: -100...100),
            y: -50
        )
    }
    
    var body: some View {
        Circle()
            .fill(Color.white)
            .frame(width: 1, height: 1)
            .opacity(0.6)
            .position(
                x: startPosition.x + (endPosition.x - startPosition.x) * (animationOffset / 1000),
                y: startPosition.y + (endPosition.y - startPosition.y) * (animationOffset / 1000)
            )
    }
}

#Preview {
    StarfieldBackgroundView()
}

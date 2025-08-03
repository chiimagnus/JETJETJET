import SwiftUI
import SceneKit

struct FlightSceneView: View {
    let airplane3DModel: Airplane3DModel
    @State private var floatingOffset: CGFloat = 0
    
    // 自适应高度
    private var adaptiveHeight: CGFloat {
        UIScreen.main.bounds.height > 800 ? 320 : 300
    }
    
    var body: some View {
        ZStack {
            // 天空渐变背景
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        gradient: Gradient(stops: [
                            .init(color: Color(red: 0.53, green: 0.81, blue: 0.92), location: 0.0), // 天蓝色
                            .init(color: Color(red: 0.60, green: 0.85, blue: 0.91), location: 0.3),
                            .init(color: Color(red: 0.94, green: 0.97, blue: 1.0), location: 1.0)   // 浅蓝白色
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                )
            
            // 飞行轨迹
            FlightTrailView()
            
            // 3D飞机场景
            Airplane3DSceneView(
                airplane3DModel: airplane3DModel,
                height: nil,
                showControls: false
            )
            .offset(y: floatingOffset)
            .onAppear {
                withAnimation(
                    .easeInOut(duration: 6.0)
                    .repeatForever(autoreverses: true)
                ) {
                    floatingOffset = -15
                }
            }
            
            // 位置标记
            VStack {
                Spacer()
                HStack {
                    // 起始点
                    HStack(spacing: 6) {
                        Circle()
                            .fill(Color.green)
                            .frame(width: 12, height: 12)
                            .shadow(color: .green, radius: 4)
                            .scaleEffect(1.2)
                            .animation(
                                .easeInOut(duration: 1.5)
                                .repeatForever(autoreverses: true),
                                value: true
                            )
                        Text("起始点")
                            .font(.caption2)
                            .foregroundColor(.white)
                            .fontWeight(.medium)
                    }
                    
                    Spacer()
                    
                    // 当前位置
                    HStack(spacing: 6) {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 12, height: 12)
                            .shadow(color: .blue, radius: 4)
                            .scaleEffect(1.2)
                            .animation(
                                .easeInOut(duration: 1.0)
                                .repeatForever(autoreverses: true),
                                value: true
                            )
                        Text("当前位置")
                            .font(.caption2)
                            .foregroundColor(.white)
                            .fontWeight(.medium)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
            }
        }
        .frame(height: adaptiveHeight)
    }
}

struct CloudView: View {
    enum CloudSize {
        case small, medium, large
        
        var mainSize: CGSize {
            switch self {
            case .small: return CGSize(width: 40, height: 15)
            case .medium: return CGSize(width: 60, height: 20)
            case .large: return CGSize(width: 80, height: 25)
            }
        }
    }
    
    let size: CloudSize
    
    var body: some View {
        ZStack {
            // 主云朵体
            Ellipse()
                .fill(Color.white.opacity(0.8))
                .frame(width: size.mainSize.width, height: size.mainSize.height)
            
            // 云朵装饰
            Circle()
                .fill(Color.white.opacity(0.8))
                .frame(width: size.mainSize.height * 1.5, height: size.mainSize.height * 1.5)
                .offset(x: -size.mainSize.width * 0.2, y: -size.mainSize.height * 0.3)
            
            Circle()
                .fill(Color.white.opacity(0.8))
                .frame(width: size.mainSize.height * 1.2, height: size.mainSize.height * 1.2)
                .offset(x: size.mainSize.width * 0.3, y: -size.mainSize.height * 0.2)
        }
    }
}

struct FlightTrailView: View {
    @State private var trailOffset1: CGFloat = 0
    @State private var trailOffset2: CGFloat = 0
    
    var body: some View {
        ZStack {
            // 飞行轨迹1
            RoundedRectangle(cornerRadius: 1)
                .fill(
                    LinearGradient(
                        colors: [Color.clear, Color.cyan.opacity(0.6), Color.clear],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(width: 200, height: 2)
                .rotationEffect(.degrees(-5))
                .offset(x: trailOffset1, y: 60)
                .onAppear {
                    withAnimation(
                        .easeInOut(duration: 3.0)
                        .repeatForever(autoreverses: true)
                    ) {
                        trailOffset1 = 50
                    }
                }
            
            // 飞行轨迹2
            RoundedRectangle(cornerRadius: 1)
                .fill(
                    LinearGradient(
                        colors: [Color.clear, Color.blue.opacity(0.4), Color.clear],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(width: 150, height: 2)
                .rotationEffect(.degrees(3))
                .offset(x: trailOffset2, y: 80)
                .onAppear {
                    withAnimation(
                        .easeInOut(duration: 2.5)
                        .repeatForever(autoreverses: true)
                        .delay(1.0)
                    ) {
                        trailOffset2 = -40
                    }
                }
        }
    }
}

#Preview {
    FlightSceneView(airplane3DModel: Airplane3DModel())
        .preferredColorScheme(.dark)
}

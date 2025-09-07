import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveView: View {
    @State private var enlarge = false
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace

    var body: some View {
        ZStack(alignment: .topLeading) {
            RealityView { content in
                // Add the initial RealityKit content
                if let model = try? await Entity(named: "Immersive", in: realityKitContentBundle) {
                    content.add(model)
                }
            }

            // 返回按钮
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        Task {
                            await dismissImmersiveSpace()
                        }
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 30))
                            .foregroundColor(.white.opacity(0.8))
                            .padding(20)
                            .background(Color.black.opacity(0.5))
                            .clipShape(Circle())
                    }
                    .padding(.top, 50)
                    .padding(.trailing, 20)
                }
                Spacer()
            }
        }
    }
}

// 注意：ImmersiveSpace的内容在Xcode预览中无法正常显示
// 因为预览环境不支持RealityKit的异步加载和渲染
// 如果需要预览，请使用ContentView而不是ImmersiveView

import SwiftUI
import SceneKit

// MARK: - 通用3D模型展示组件
struct Airplane3DSceneView: View {
    let airplane3DModel: Airplane3DModel
    let height: CGFloat?
    let showControls: Bool

    init(airplane3DModel: Airplane3DModel, height: CGFloat? = nil, showControls: Bool = true) {
        self.airplane3DModel = airplane3DModel
        self.height = height
        self.showControls = showControls
    }

    var body: some View {
        TransparentSceneView(
            scene: airplane3DModel.getScene(),
            showControls: showControls
        )
        .frame(height: height)
        .if(height != nil) { view in
            view.cornerRadius(12).padding(.horizontal)
        }
    }
}

// MARK: - 透明背景的SceneView
struct TransparentSceneView: UIViewRepresentable {
    let scene: SCNScene?
    let showControls: Bool

    func makeUIView(context: Context) -> SCNView {
        let sceneView = SCNView()
        sceneView.scene = scene

        // 设置透明背景的多种方式
        sceneView.backgroundColor = UIColor.clear
        sceneView.isOpaque = false

        // 设置控制选项
        sceneView.allowsCameraControl = showControls
        sceneView.autoenablesDefaultLighting = true

        return sceneView
    }

    func updateUIView(_ uiView: SCNView, context: Context) {
        uiView.scene = scene
        uiView.allowsCameraControl = showControls
    }
}

// MARK: - View扩展，用于条件修饰符
extension View {
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

#Preview {
    ZStack {
        // 测试背景 - 如果3D场景透明，应该能看到这个渐变
        LinearGradient(
            colors: [.red, .blue, .green],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()

        VStack(spacing: 20) {
            Text("透明度测试")
                .font(.title)
                .foregroundColor(.white)

            // 带控制的3D场景
            Airplane3DSceneView(
                airplane3DModel: Airplane3DModel(),
                height: 300,
                showControls: true
            )

            // 无控制的3D场景
            Airplane3DSceneView(
                airplane3DModel: Airplane3DModel(),
                height: 200,
                showControls: false
            )
        }
        .padding()
    }
    .preferredColorScheme(.dark)
}
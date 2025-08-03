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
        SceneView(
            scene: airplane3DModel.getScene(),
            options: showControls ? [.allowsCameraControl, .autoenablesDefaultLighting] : [.autoenablesDefaultLighting]
        )
        .frame(height: height)
        .if(height != nil) { view in
            view.cornerRadius(12).padding(.horizontal)
        }
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
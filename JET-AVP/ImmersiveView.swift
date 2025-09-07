import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveView: View {
    @State private var enlarge = false
    @State private var selectedEntity: Entity?
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace

    var body: some View {
        ZStack(alignment: .topLeading) {
            RealityView { content in
                // Add the initial RealityKit content
                if let model = try? await Entity(named: "Immersive", in: realityKitContentBundle) {
                    // 递归为所有子实体添加交互组件
                    setupEntityForInteraction(model)

                    content.add(model)
                }
            } update: { content in
                // 处理状态变化和实体更新
                if let entity = selectedEntity ?? content.entities.first {
                    let uniformScale: Float = enlarge ? 1.4 : 1.0
                    entity.transform.scale = [uniformScale, uniformScale, uniformScale]
                }
            }
            .gesture(
                SpatialTapGesture()
                    .targetedToAnyEntity()
                    .onEnded { value in
                        // 处理点击事件
                        selectedEntity = value.entity
                        enlarge.toggle()

                        // 添加点击反馈效果
                        if enlarge {
                            // 放大时添加轻微的旋转动画
                            let entity = value.entity
                            var transform = entity.transform
                            transform.rotation = simd_quatf(angle: 0.1, axis: [0, 1, 0])
                            entity.move(to: transform, relativeTo: entity.parent, duration: 0.2)
                        }
                    }
            )

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

            // 显示交互提示
            VStack {
                Spacer()
                Text("点击3D模型进行交互")
                    .font(.title3)
                    .foregroundColor(.white.opacity(0.8))
                    .padding()
                    .background(Color.black.opacity(0.5))
                    .cornerRadius(10)
                    .padding(.bottom, 50)
            }
        }
    }

    // 递归设置实体为可交互状态
    private func setupEntityForInteraction(_ entity: Entity) {
        // 为当前实体添加碰撞和输入组件
        if entity.components[CollisionComponent.self] == nil {
            entity.components.set(CollisionComponent(shapes: [.generateBox(size: SIMD3<Float>(0.3, 0.3, 0.3))]))
        }
        if entity.components[InputTargetComponent.self] == nil {
            entity.components.set(InputTargetComponent())
        }

        // 递归处理所有子实体
        for child in entity.children {
            setupEntityForInteraction(child)
        }
    }
}

// 注意：ImmersiveSpace的内容在Xcode预览中无法正常显示
// 因为预览环境不支持RealityKit的异步加载和渲染
// 如果需要预览，请使用ContentView而不是ImmersiveView

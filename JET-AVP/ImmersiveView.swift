//
//  ImmersiveView.swift
//  JET-AVP
//
//  Created by chii_magnus on 2025/9/5.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveView: View {

    var body: some View {
        RealityView { content in
            // Add the initial RealityKit content
            if let immersiveContentEntity = try? await Entity(named: "Immersive", in: realityKitContentBundle) {
                content.add(immersiveContentEntity)

                // Put skybox here.  See example in World project available at
                // https://developer.apple.com/
            }
        }
        .overlay(
            // 使用 RealityKit 的 Model3D 直接加载飞机模型
            Model3D(named: "jet", bundle: Bundle.main)
                .scaleEffect(0.02)  // 调整模型大小以适应场景
                .offset(z: -2)  // 调整模型位置
        )
    }
}

#Preview(immersionStyle: .full) {
    ImmersiveView()
        .environment(AppModel())
}

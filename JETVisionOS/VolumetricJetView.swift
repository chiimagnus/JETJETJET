//
//  VolumetricJetView.swift
//  JETVisionOS
//
//  Created by chii_magnus on 2025/9/9.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct VolumetricJetView: View {
    var body: some View {
        Model3D(named: "jet", bundle: realityKitContentBundle)
            .frame(width: 400, height: 400)
            .aspectRatio(contentMode: .fit)
    }
}

#Preview(windowStyle: .automatic) {
    VolumetricJetView()
}
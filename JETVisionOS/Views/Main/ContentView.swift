//
//  ContentView.swift
//  JETVisionOS
//
//  Created by chii_magnus on 2025/9/9.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {

    var body: some View {
        VStack {
            Model3D(named: "jet", bundle: realityKitContentBundle)
                .padding(.bottom, 50)

            Spacer()
            
            HStack {
                ToggleImmersiveSpaceButton()
                
                ShowVolumetricJetButton()
            }
            .padding(.horizontal)
        }
        .padding()
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
        .environment(AppModel())
}

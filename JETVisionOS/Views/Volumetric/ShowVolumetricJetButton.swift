//
//  ShowVolumetricJetButton.swift
//  JETVisionOS
//
//  Created by chii_magnus on 2025/9/9.
//

import SwiftUI

struct ShowVolumetricJetButton: View {
    @Environment(\.openWindow) private var openWindow
    
    var body: some View {
        Button("Show Volumetric Jet") {
            openWindow(id: "volumetricJet")
        }
    }
}

#Preview(windowStyle: .automatic) {
    ShowVolumetricJetButton()
}
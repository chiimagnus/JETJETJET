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
        Button(action: {
            // Open the volumetric window group
            openWindow(id: "volumetricJet")
        }) {
            Text("Show Volumetric Jet")
                .font(.headline)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(12)
        }
        .padding(.top, 20)
    }
}

#Preview(windowStyle: .automatic) {
    ShowVolumetricJetButton()
}
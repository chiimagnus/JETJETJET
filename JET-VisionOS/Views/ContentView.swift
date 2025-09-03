//
//  ContentView.swift
//  JET-VisionOS
//
//  Created by chii_magnus on 2025/9/1.
//

import SwiftUI
import RealityKit

struct ContentView: View {

    var body: some View {
        VStack {
            Text("JET Flight Simulator")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
            Text("Experience flight data in immersive 3D")
                .font(.headline)
                .foregroundColor(.secondary)
                .padding(.bottom, 50)
            
            ToggleImmersiveSpaceButton()
                .font(.title2)
                .padding()
        }
        .padding()
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
        .environment(AppModel())
}

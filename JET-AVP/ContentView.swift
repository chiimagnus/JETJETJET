//
//  ContentView.swift
//  JET-AVP
//
//  Created by chii_magnus on 2025/9/5.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {

    var body: some View {
        VStack {
            Model3D(named: "Scene", bundle: realityKitContentBundle)
                .padding(.bottom, 50)

            Text("JET-AVP 飞行模拟器")
                .font(.title)
                .padding()
        }
        .padding()
    }
}
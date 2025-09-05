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
            Model3D(named: "jet", bundle: realityKitContentBundle)
        }
    }
}

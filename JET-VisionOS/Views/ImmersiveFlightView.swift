//
//  ImmersiveFlightView.swift
//  JET-VisionOS
//
//  Created by chii_magnus on 2025/9/3.
//

import SwiftUI
import RealityKit
import RealityKitContent
import Combine

struct ImmersiveFlightView: View {
    @Environment(AppModel.self) var appModel
    
    // Use the shared MotionService from the main target
    @StateObject private var motionService = MotionService()
    @State private var flightDataSnapshot: FlightDataSnapshot?
    
    var body: some View {
        ZStack {
            RealityView { content in
                // Add the initial RealityKit content
                if let immersiveContentEntity = try? await Entity(named: "Immersive", in: realityKitContentBundle) {
                    content.add(immersiveContentEntity)
                }
                
                // Add our flight simulator content
                let airplaneEntity = createAirplaneEntity()
                content.add(airplaneEntity)
            } update: { content in
                // Update the airplane position based on flight data
                if let airplaneEntity = content.entities.first(where: { $0.name == "airplane" }),
                   let snapshot = flightDataSnapshot {
                    // Update airplane orientation based on pitch, roll, and yaw
                    let pitchRadians = Float(snapshot.pitch * .pi / 180.0)
                    let rollRadians = Float(snapshot.roll * .pi / 180.0)
                    let yawRadians = Float(snapshot.yaw * .pi / 180.0)
                    
                    let transform = Transform(pitch: pitchRadians, yaw: yawRadians, roll: rollRadians)
                    airplaneEntity.orientation = transform.rotation
                }
            }
            
            // 添加一个按钮来展示3D模型视图
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        // 这里可以导航到3D模型展示视图
                        // 但在immersive view中我们只显示一个提示
                    }) {
                        Image(systemName: "airplane.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .shadow(radius: 5)
                    }
                    .padding()
                    .background(Color.black.opacity(0.5))
                    .clipShape(Circle())
                    .padding()
                }
            }
        }
        .onAppear {
            startMotionUpdates()
        }
        .onDisappear {
            motionService.stopMotionUpdates()
        }
    }
    
    private func startMotionUpdates() {
        motionService.startMotionMonitoring { snapshot in
            DispatchQueue.main.async {
                self.flightDataSnapshot = snapshot
            }
        }
    }
    
    private func createAirplaneEntity() -> Entity {
        // Create a simple airplane model using RealityKit primitives
        let airplane = ModelEntity(
            mesh: .generateBox(size: [0.4, 0.15, 2.4]),
            materials: [SimpleMaterial(color: .systemBlue, isMetallic: false)]
        )
        
        // Add wings
        let wing = ModelEntity(
            mesh: .generateBox(size: [2.4, 0.06, 0.45]),
            materials: [SimpleMaterial(color: .systemBlue, isMetallic: false)]
        )
        wing.position = [0, 0, 0]
        airplane.addChild(wing)
        
        // Add tail
        let tail = ModelEntity(
            mesh: .generateBox(size: [0.6, 0.45, 0.06]),
            materials: [SimpleMaterial(color: .systemBlue, isMetallic: false)]
        )
        tail.position = [0, 0.15, -1.05]
        airplane.addChild(tail)
        
        airplane.name = "airplane"
        return airplane
    }
}

#Preview(immersionStyle: .full) {
    ImmersiveFlightView()
        .environment(AppModel())
}
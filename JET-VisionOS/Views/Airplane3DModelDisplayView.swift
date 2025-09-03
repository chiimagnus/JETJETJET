//
//  Airplane3DModelDisplayView.swift
//  JET-VisionOS
//
//  Created by chii_magnus on 2025/9/3.
//

import SwiftUI
import RealityKit
import RealityKitContent
import Combine

struct Airplane3DModelDisplayView: View {
    @State private var airplaneModel: Airplane3DModel = Airplane3DModel()
    @State private var selectedModelType: AirplaneModelType = .defaultModel
    @State private var isAnimating = false
    @State private var pitch: Double = 0
    @State private var roll: Double = 0
    @State private var yaw: Double = 0
    
    var body: some View {
        NavigationStack {
            VStack {
                // 模型选择器
                Picker("选择飞机模型", selection: $selectedModelType) {
                    ForEach(AirplaneModelType.allCases, id: \.self) { modelType in
                        Text(modelType.displayName).tag(modelType)
                    }
                }
                .pickerStyle(.segmented)
                .padding()
                .onChange(of: selectedModelType) { _, newValue in
                    // 当模型类型改变时，创建新的模型实例
                    airplaneModel = Airplane3DModel(modelType: newValue)
                }
                
                // 3D 模型展示区域
                RealityView { content in
                    // 添加我们的飞机模型内容
                    let airplaneEntity = createAirplaneEntity(for: selectedModelType)
                    content.add(airplaneEntity)
                } update: { content in
                    // 更新模型姿态
                    if let airplaneEntity = content.entities.first(where: { $0.name == "airplane" }) {
                        updateAirplaneOrientation(airplaneEntity)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                // 控制面板
                VStack(spacing: 20) {
                    // 姿态控制滑块
                    VStack {
                        Text("飞机姿态控制")
                            .font(.headline)
                        
                        HStack {
                            VStack {
                                Text("俯仰 (Pitch): \(String(format: "%.1f", pitch))°")
                                Slider(value: $pitch, in: -90...90, step: 1)
                            }
                            
                            VStack {
                                Text("横滚 (Roll): \(String(format: "%.1f", roll))°")
                                Slider(value: $roll, in: -180...180, step: 1)
                            }
                            
                            VStack {
                                Text("偏航 (Yaw): \(String(format: "%.1f", yaw))°")
                                Slider(value: $yaw, in: -180...180, step: 1)
                            }
                        }
                    }
                    .padding()
                    
                    // 动画控制按钮
                    HStack {
                        Button(action: {
                            isAnimating.toggle()
                            if !isAnimating {
                                // 重置姿态
                                pitch = 0
                                roll = 0
                                yaw = 0
                            }
                        }) {
                            Text(isAnimating ? "停止动画" : "开始动画")
                                .font(.headline)
                                .padding()
                                .background(isAnimating ? Color.red : Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        
                        Button(action: {
                            // 重置姿态
                            pitch = 0
                            roll = 0
                            yaw = 0
                        }) {
                            Text("重置姿态")
                                .font(.headline)
                                .padding()
                                .background(Color.gray)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("3D 飞机模型展示")
            .onReceive(Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()) { _ in
                if isAnimating {
                    // 自动旋转动画
                    yaw += 2
                    if yaw > 180 {
                        yaw -= 360
                    }
                }
            }
        }
    }
    
    private func createAirplaneEntity(for modelType: AirplaneModelType) -> Entity {
        switch modelType {
        case .defaultModel:
            return createDefaultAirplaneEntity()
        case .jet1:
            return createJet1AirplaneEntity()
        }
    }
    
    private func createDefaultAirplaneEntity() -> Entity {
        // 创建一个简单的飞机模型使用RealityKit原语
        let fuselage = ModelEntity(
            mesh: .generateBox(size: [0.4, 0.15, 2.4]),
            materials: [SimpleMaterial(color: .systemBlue, isMetallic: false)]
        )
        
        // 添加机翼
        let wing = ModelEntity(
            mesh: .generateBox(size: [2.4, 0.06, 0.45]),
            materials: [SimpleMaterial(color: .systemBlue, isMetallic: false)]
        )
        wing.position = [0, 0, 0]
        fuselage.addChild(wing)
        
        // 添加尾翼
        let tail = ModelEntity(
            mesh: .generateBox(size: [0.6, 0.45, 0.06]),
            materials: [SimpleMaterial(color: .systemBlue, isMetallic: false)]
        )
        tail.position = [0, 0.15, -1.05]
        fuselage.addChild(tail)
        
        fuselage.name = "airplane"
        return fuselage
    }
    
    private func createJet1AirplaneEntity() -> Entity {
        // 创建一个更复杂的飞机模型来模拟导入的jet.scn模型
        let fuselage = ModelEntity(
            mesh: .generateBox(size: [0.2, 0.2, 1.0]),
            materials: [SimpleMaterial(color: .systemTeal, isMetallic: true)]
        )
        
        // 添加主翼
        let mainWing = ModelEntity(
            mesh: .generateBox(size: [1.5, 0.05, 0.3]),
            materials: [SimpleMaterial(color: .systemTeal, isMetallic: true)]
        )
        mainWing.position = [0, 0, 0]
        
        // 添加尾翼
        let tailWing = ModelEntity(
            mesh: .generateBox(size: [0.4, 0.3, 0.05]),
            materials: [SimpleMaterial(color: .systemTeal, isMetallic: true)]
        )
        tailWing.position = [0, 0.15, -0.4]
        
        // 添加垂直尾翼
        let verticalTail = ModelEntity(
            mesh: .generateBox(size: [0.05, 0.4, 0.3]),
            materials: [SimpleMaterial(color: .systemTeal, isMetallic: true)]
        )
        verticalTail.position = [0, 0.2, -0.4]
        
        // 组装飞机
        let airplane = Entity()
        airplane.addChild(fuselage)
        airplane.addChild(mainWing)
        airplane.addChild(tailWing)
        airplane.addChild(verticalTail)
        
        airplane.name = "airplane"
        return airplane
    }
    
    private func updateAirplaneOrientation(_ airplaneEntity: Entity) {
        // 将角度转换为弧度
        let pitchRadians = Float(pitch * Double.pi / 180.0)
        let rollRadians = Float(roll * Double.pi / 180.0)
        let yawRadians = Float(yaw * Double.pi / 180.0)
        
        // 根据模型类型应用不同的旋转逻辑
        switch selectedModelType {
        case .defaultModel:
            // 默认模型需要额外的180度Y轴旋转让飞机头朝向观察者
            let transform = Transform(pitch: -pitchRadians, yaw: yawRadians + Float.pi, roll: rollRadians)
            airplaneEntity.orientation = transform.rotation
        case .jet1:
            // Jet1模型直接应用旋转
            let transform = Transform(pitch: -pitchRadians, yaw: yawRadians, roll: rollRadians)
            airplaneEntity.orientation = transform.rotation
        }
    }
}

#Preview {
    Airplane3DModelDisplayView()
}
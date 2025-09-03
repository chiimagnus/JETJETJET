//
//  ContentView.swift
//  JET-VisionOS
//
//  Created by chii_magnus on 2025/9/1.
//

import SwiftUI
import RealityKit

struct ContentView: View {
    @Environment(AppModel.self) private var appModel
    @State private var show3DModelView = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                Text("JET 飞行记录器")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                
                Text("体验沉浸式3D飞行模拟")
                    .font(.title2)
                    .foregroundColor(.secondary)
                    .padding(.bottom, 20)
                
                // 功能按钮
                VStack(spacing: 20) {
                    ToggleImmersiveSpaceButton()
                        .font(.title2)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                    
                    Button(action: {
                        show3DModelView = true
                    }) {
                        HStack {
                            Image(systemName: "airplane")
                                .font(.title2)
                            Text("3D 飞机模型展示")
                                .font(.title3)
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                    }
                    .sheet(isPresented: $show3DModelView) {
                        Airplane3DModelDisplayView()
                            .environment(appModel)
                    }
                    
                    Button(action: {
                        // 可以添加更多功能
                    }) {
                        HStack {
                            Image(systemName: "clock")
                                .font(.title2)
                            Text("飞行历史记录")
                                .font(.title3)
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                    }
                }
                .padding(.horizontal, 40)
                
                // 信息展示
                VStack(spacing: 10) {
                    Text("特性")
                        .font(.headline)
                        .padding(.top, 20)
                    
                    ForEach([
                        "实时3D飞行可视化",
                        "多种飞机模型选择",
                        "沉浸式空间体验",
                        "飞行数据记录与回放"
                    ], id: \.self) { feature in
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            Text(feature)
                            Spacer()
                        }
                        .padding(.horizontal)
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .padding(.horizontal, 20)
                
                Spacer()
            }
            .padding()
        }
        .environment(appModel)
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
        .environment(AppModel())
}

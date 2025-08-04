import SwiftUI

// MARK: - 飞机模型选择视图
struct AirplaneModelSelectionView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedModelType: AirplaneModelType
    @State private var previewModels: [AirplaneModelType: Airplane3DModel] = [:]
    
    var body: some View {
        ZStack {
            // 背景
            StarfieldBackgroundView()
            
            VStack(spacing: 0) {
                // 顶部导航栏
                topNavigationBar
                    .padding(.top, 10)
                
                // 模型选择内容
                ScrollView {
                    VStack(spacing: 20) {
                        // 标题
                        Text("选择飞机模型")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.top, 20)
                        
                        // 模型选择网格
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 20) {
                            ForEach(AirplaneModelType.allCases, id: \.self) { modelType in
                                ModelSelectionCard(
                                    modelType: modelType,
                                    isSelected: selectedModelType == modelType,
                                    previewModel: previewModels[modelType]
                                ) {
                                    selectedModelType = modelType
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        Spacer(minLength: 100)
                    }
                }
            }
        }
        .preferredColorScheme(.dark)
        .navigationBarHidden(true)
        .onAppear {
            initializePreviewModels()
        }
    }
    
    private var topNavigationBar: some View {
        HStack {
            // 返回按钮
            Button(action: {
                dismiss()
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .medium))
                    Text("返回")
                        .font(.system(size: 16, weight: .medium))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.ultraThinMaterial)
                )
            }
            
            Spacer()
            
            // 标题
            Text("模型选择")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
            
            Spacer()
            
            // 占位符保持平衡
            Color.clear
                .frame(width: 80, height: 36)
        }
        .padding(.horizontal, 20)
    }
    
    private func initializePreviewModels() {
        for modelType in AirplaneModelType.allCases {
            previewModels[modelType] = Airplane3DModel(modelType: modelType)
        }
    }
}

// MARK: - 模型选择卡片
struct ModelSelectionCard: View {
    let modelType: AirplaneModelType
    let isSelected: Bool
    let previewModel: Airplane3DModel?
    let onSelect: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            // 3D预览
            Group {
                if let previewModel = previewModel {
                    Airplane3DSceneView(
                        airplane3DModel: previewModel,
                        height: 120,
                        showControls: false
                    )
                } else {
                    Rectangle()
                        .fill(.ultraThinMaterial)
                        .frame(height: 120)
                        .overlay {
                            ProgressView()
                                .tint(.white)
                        }
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            // 模型名称
            Text(modelType.displayName)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
            
            // 选择状态指示器
            if isSelected {
                HStack(spacing: 4) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                    Text("已选择")
                        .font(.caption)
                        .foregroundColor(.green)
                }
            } else {
                Text("点击选择")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(isSelected ? .green : .clear, lineWidth: 2)
                )
        )
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
        .onTapGesture {
            onSelect()
        }
    }
}

#Preview {
    AirplaneModelSelectionView(selectedModelType: .constant(.defaultModel))
}

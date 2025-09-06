import SwiftUI

struct DataTag: View {
    let value: String
    let label: String
    let color: Color
    @State private var isHovered = false
    
    var body: some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.system(.title2, design: .rounded, weight: .heavy)) // 更大更粗的字体
                .foregroundColor(color)
                .shadow(color: color.opacity(0.8), radius: isHovered ? 8 : 4) // 增强发光效果
                .shadow(color: color.opacity(0.4), radius: isHovered ? 12 : 6) // 双重发光
                .animation(.easeInOut(duration: 0.3), value: isHovered)

            Text(label)
                .font(.system(.caption2, design: .rounded, weight: .semibold)) // 更粗的标签字体
                .foregroundColor(.secondary)
                .textCase(.uppercase)
                .tracking(1) // 增加字母间距
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12) // 增加垂直内边距
        .padding(.horizontal, 8) // 增加水平内边距
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white.opacity(isHovered ? 0.12 : 0.05)) // 增强背景对比度
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(
                            isHovered ? color.opacity(0.8) : Color.white.opacity(0.15), // 增强边框对比度
                            lineWidth: isHovered ? 1.5 : 1
                        )
                )
                .shadow(
                    color: isHovered ? color.opacity(0.3) : Color.clear, // 添加发光阴影
                    radius: isHovered ? 8 : 0,
                    x: 0,
                    y: 0
                )
        )
        .scaleEffect(isHovered ? 1.05 : 1.0)
        .animation(.easeInOut(duration: 0.3), value: isHovered)
        .onHover { hovering in
            isHovered = hovering
        }
        .onTapGesture {
            // 模拟悬停效果
            withAnimation(.easeInOut(duration: 0.15)) {
                isHovered = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                withAnimation(.easeInOut(duration: 0.15)) {
                    isHovered = false
                }
            }
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        // 单个标签预览
        DataTag(value: "15.2", label: "Max Speed", color: .cyan)
            .frame(width: 80)
        
        // 网格布局预览
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 4), spacing: 12) {
            DataTag(value: "15.2", label: "Max Speed", color: .cyan)
            DataTag(value: "45°", label: "Max Pitch", color: .green)
            DataTag(value: "30°", label: "Max Roll", color: .orange)
            DataTag(value: "3.2G", label: "Max G", color: .purple)
        }
        .padding()
    }
    .background(Color.black)
    .preferredColorScheme(.dark)
}

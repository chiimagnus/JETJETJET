import SwiftUI

struct DataTag: View {
    let value: String
    let label: String
    let color: Color
    @State private var isHovered = false
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(.title3, design: .rounded, weight: .bold))
                .foregroundColor(color)
                .shadow(color: color.opacity(0.5), radius: isHovered ? 4 : 0)
                .animation(.easeInOut(duration: 0.3), value: isHovered)
            
            Text(label)
                .font(.system(.caption2, design: .rounded, weight: .medium))
                .foregroundColor(.gray)
                .textCase(.uppercase)
                .tracking(0.5)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .padding(.horizontal, 4)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white.opacity(isHovered ? 0.08 : 0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(
                            isHovered ? color.opacity(0.5) : Color.white.opacity(0.1),
                            lineWidth: 1
                        )
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

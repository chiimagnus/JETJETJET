import SwiftUI

struct SearchBar: View {
    @Binding var searchText: String
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .font(.system(.body, weight: .medium))
                .foregroundColor(isFocused ? Color(red: 0, green: 0.83, blue: 1) : .gray) // 霓虹青色
                .shadow(color: isFocused ? Color(red: 0, green: 0.83, blue: 1).opacity(0.6) : Color.clear, radius: 4) // 图标发光
                .animation(.easeInOut(duration: 0.3), value: isFocused)
            
            TextField("搜索飞行记录...", text: $searchText)
                .font(.system(.body, design: .rounded))
                .foregroundColor(.white)
                .textFieldStyle(PlainTextFieldStyle())
                .focused($isFocused)
                .onSubmit {
                    isFocused = false
                }
            
            if !searchText.isEmpty {
                Button(action: {
                    searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(.body, weight: .medium))
                        .foregroundColor(.gray)
                }
                .transition(.scale.combined(with: .opacity))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(
                            isFocused ? Color(red: 0, green: 0.83, blue: 1) : Color.white.opacity(0.1), // 霓虹青色
                            lineWidth: isFocused ? 1.5 : 1
                        )
                )
                .shadow(
                    color: isFocused ? Color(red: 0, green: 0.83, blue: 1).opacity(0.4) : Color.black.opacity(0.1), // 霓虹发光
                    radius: isFocused ? 12 : 4,
                    x: 0,
                    y: 2
                )
                .shadow(
                    color: isFocused ? Color(red: 0, green: 0.83, blue: 1).opacity(0.2) : Color.clear, // 双重发光
                    radius: isFocused ? 20 : 0,
                    x: 0,
                    y: 0
                )
        )
        .animation(.easeInOut(duration: 0.3), value: isFocused)
        .onAppear {
            // 当搜索栏出现时自动获得焦点
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isFocused = true
            }
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        SearchBar(searchText: .constant(""))
        SearchBar(searchText: .constant("测试搜索"))
    }
    .padding()
    .background(Color.black)
    .preferredColorScheme(.dark)
}

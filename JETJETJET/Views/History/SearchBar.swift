import SwiftUI

struct SearchBar: View {
    @Binding var searchText: String
    @State private var isFocused = false
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .font(.system(.body, weight: .medium))
                .foregroundColor(isFocused ? .cyan : .gray)
                .animation(.easeInOut(duration: 0.3), value: isFocused)
            
            TextField("搜索飞行记录...", text: $searchText)
                .font(.system(.body, design: .rounded))
                .foregroundColor(.white)
                .textFieldStyle(PlainTextFieldStyle())
                .onTapGesture {
                    isFocused = true
                }
                .onSubmit {
                    isFocused = false
                }
            
            if !searchText.isEmpty {
                Button(action: {
                    searchText = ""
                    isFocused = false
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
                            isFocused ? Color.cyan : Color.white.opacity(0.1),
                            lineWidth: 1
                        )
                )
                .shadow(
                    color: isFocused ? Color.cyan.opacity(0.2) : Color.black.opacity(0.1),
                    radius: isFocused ? 8 : 4,
                    x: 0,
                    y: 2
                )
        )
        .animation(.easeInOut(duration: 0.3), value: isFocused)
        .onChange(of: searchText) { _, _ in
            if !searchText.isEmpty {
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

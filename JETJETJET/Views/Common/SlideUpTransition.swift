import SwiftUI

// MARK: - PDF翻页式转场动画
struct SlideUpTransition<Content: View>: View {
    @Binding var isPresented: Bool
    let content: () -> Content

    @State private var offset: CGFloat = UIScreen.main.bounds.height

    var body: some View {
        ZStack {
            if isPresented {
                // 新页面内容 - 从下方滑入
                content()
                    .offset(y: offset)
                    .transition(.identity)
            }
        }
        .onChange(of: isPresented) { _, newValue in
            if newValue {
                presentView()
            } else {
                dismissView()
            }
        }
    }

    private func presentView() {
        // 重置初始状态 - 新页面在屏幕下方
        offset = UIScreen.main.bounds.height

        // 执行PDF翻页动画 - 新页面从下往上滑入
        withAnimation(.easeInOut(duration: 0.5)) {
            offset = 0
        }
    }

    private func dismissView() {
        // 页面向下滑出（回退效果）
        withAnimation(.easeInOut(duration: 0.4)) {
            offset = UIScreen.main.bounds.height
        }
    }
}

// MARK: - PDF翻页式转场修饰符
struct SlideUpPresentationModifier<PresentedContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    let presentedContent: () -> PresentedContent

    @State private var backgroundOffset: CGFloat = 0

    func body(content: Content) -> some View {
        ZStack {
            // 背景页面 - 当新页面出现时向上滑动
            content
                .offset(y: backgroundOffset)
                .onChange(of: isPresented) { _, newValue in
                    if newValue {
                        // 新页面出现时，背景页面向上滑动
                        withAnimation(.easeInOut(duration: 0.5)) {
                            backgroundOffset = -UIScreen.main.bounds.height
                        }
                    } else {
                        // 新页面消失时，背景页面向下滑回原位
                        withAnimation(.easeInOut(duration: 0.4)) {
                            backgroundOffset = 0
                        }
                    }
                }

            // 新页面 - PDF翻页效果
            SlideUpTransition(isPresented: $isPresented, content: presentedContent)
        }
    }
}

// MARK: - View扩展
extension View {
    func slideUpPresentation<Content: View>(
        isPresented: Binding<Bool>,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        self.modifier(SlideUpPresentationModifier(isPresented: isPresented, presentedContent: content))
    }
}

// MARK: - 预览
#Preview {
    struct PreviewWrapper: View {
        @State private var showModal = false
        
        var body: some View {
            VStack {
                Button("Show Modal") {
                    showModal = true
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.gray.opacity(0.2))
            .slideUpPresentation(isPresented: $showModal) {
                VStack {
                    Text("Modal Content")
                        .font(.title)
                        .padding()
                    
                    Button("Close") {
                        showModal = false
                    }
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white)
                .cornerRadius(20, corners: [.topLeft, .topRight])
            }
        }
    }
    
    return PreviewWrapper()
}

// MARK: - 圆角扩展
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

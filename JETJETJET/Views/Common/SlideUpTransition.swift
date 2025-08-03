import SwiftUI

// MARK: - 简化版页面切换动画
struct SimplePageTransition<FirstPage: View, SecondPage: View>: View {
    @Binding var showSecondPage: Bool
    let firstPage: () -> FirstPage
    let secondPage: () -> SecondPage

    var body: some View {
        ZStack {
            // 第一个页面
            firstPage()
                .offset(y: showSecondPage ? -UIScreen.main.bounds.height : 0)

            // 第二个页面
            if showSecondPage {
                secondPage()
                    .offset(y: showSecondPage ? 0 : UIScreen.main.bounds.height)
                    .transition(.move(edge: .bottom))
            }
        }
        .animation(.easeInOut(duration: 0.5), value: showSecondPage)
    }
}

// MARK: - 简化版View扩展
extension View {
    /// 简单的页面切换修饰符
    func simplePageTransition<Content: View>(
        showSecondPage: Binding<Bool>,
        @ViewBuilder secondPage: @escaping () -> Content
    ) -> some View {
        SimplePageTransition(
            showSecondPage: showSecondPage,
            firstPage: { self },
            secondPage: secondPage
        )
    }
}

// MARK: - 预览
#Preview {
    struct PreviewWrapper: View {
        @State private var showSecondPage = false

        var body: some View {
            // 第一个页面
            VStack {
                Text("第一个页面")
                    .font(.largeTitle)
                    .padding()

                Button("切换到第二页") {
                    showSecondPage = true
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.gray.opacity(0.2))
            .simplePageTransition(showSecondPage: $showSecondPage) {
                // 第二个页面
                VStack {
                    Text("第二个页面")
                        .font(.largeTitle)
                        .padding()

                    Button("返回第一页") {
                        showSecondPage = false
                    }
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white)
            }
        }
    }

    return PreviewWrapper()
}



# NavigationView 嵌套问题解决方案

## 问题描述
在 `FlightRecordingView` 中点击右上角的 `clock.arrow.circlepath` 按钮进入 `FlightHistoryView` 后，发现导航栏标题 "飞行历史" 和 "< 返回" 按钮不在同一水平位置，布局出现异常。

## 问题原因
`FlightHistoryView.swift` 中错误地嵌套了 `NavigationView`，导致导航层次结构混乱：

```swift
// ❌ 错误：嵌套 NavigationView
struct FlightHistoryView: View {
    var body: some View {
        NavigationView {  // 不应该在这里创建新的 NavigationView
            List {
                // ...
            }
            .navigationTitle("飞行历史")
        }
    }
}
```

## 解决方案
移除 `FlightHistoryView` 中的嵌套 `NavigationView`，让子视图使用父视图提供的导航环境：

```swift
// ✅ 正确：使用父视图的导航环境
struct FlightHistoryView: View {
    var body: some View {
        List {
            // ...
        }
        .navigationTitle("飞行历史")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
        }
    }
}
```

## 修复效果
- ✅ 导航栏标题和返回按钮正确对齐
- ✅ 导航层次结构清晰
- ✅ 用户体验一致
- ✅ 遵循 SwiftUI 最佳实践

## 最佳实践
- 子视图不应该创建自己的 `NavigationView`
- 利用父视图提供的导航环境
- 保持导航层次结构扁平化

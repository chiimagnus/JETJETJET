import SwiftUI

// Color扩展 - 用于获取颜色组件
extension Color {
    var components: (red: Double, green: Double, blue: Double, alpha: Double) {
        #if canImport(UIKit)
        typealias NativeColor = UIColor
        #elseif canImport(AppKit)
        typealias NativeColor = NSColor
        #endif

        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0

        guard NativeColor(self).getRed(&r, green: &g, blue: &b, alpha: &a) else {
            return (0, 0, 0, 0)
        }

        return (Double(r), Double(g), Double(b), Double(a))
    }
}

struct StarfieldBackgroundView: View {
    // 飞机姿态数据，用于动态调整背景
    var pitch: Double = 0.0
    var roll: Double = 0.0
    var yaw: Double = 0.0

    // 光源设置
    @Environment(LightSourceSettings.self) private var lightSettings

    var body: some View {
        // 动态渐变背景 - 根据飞机机头方向调整
        RadialGradient(
            gradient: Gradient(stops: [
                .init(color: lightColor, location: 0.0),
                .init(color: mediumColor, location: 0.4),
                .init(color: darkColor, location: 1.0)
            ]),
            center: lightCenter,
            startRadius: 50,
            endRadius: 800
        )
        .ignoresSafeArea()
        .animation(.easeInOut(duration: 0.8), value: yaw)
        .animation(.easeInOut(duration: 0.6), value: pitch)
        .animation(.easeInOut(duration: 1.0), value: lightSettings.currentMode)
    }

    // 计算光亮中心点 - 基于飞机机头方向
    private var lightCenter: UnitPoint {
        // 将yaw角度转换为屏幕坐标
        // yaw: -180到180度，0度为正北
        let normalizedYaw = (yaw + 180) / 360 // 转换为0-1范围
        let x = 0.5 + sin(yaw * .pi / 180) * 0.3 // 左右偏移
        let y = 0.5 - cos(yaw * .pi / 180) * 0.3 // 上下偏移

        // 加入pitch的影响 - 机头向上时光源向上移动
        let pitchOffset = pitch / 180 * 0.2 // pitch影响垂直位置

        return UnitPoint(
            x: max(0.1, min(0.9, x)),
            y: max(0.1, min(0.9, y - pitchOffset))
        )
    }

    // 动态光亮颜色 - 基于飞行姿态和光源模式
    private var lightColor: Color {
        let mode = lightSettings.currentMode

        if mode == .default {
            // 默认模式使用原始的动态计算方式
            let brightness = 0.3 + max(0, pitch / 90) * 0.4
            return Color(
                red: 0.2 + brightness * 0.3,
                green: 0.3 + brightness * 0.4,
                blue: 0.5 + brightness * 0.3
            )
        } else {
            // 其他模式使用基础颜色加亮度调整
            let brightness = 0.3 + max(0, pitch / 90) * 0.4
            let baseColor = mode.lightColor

            return Color(
                red: min(1.0, baseColor.components.red * (0.5 + brightness)),
                green: min(1.0, baseColor.components.green * (0.5 + brightness)),
                blue: min(1.0, baseColor.components.blue * (0.5 + brightness))
            )
        }
    }

    // 中等亮度颜色 - 基于光源模式
    private var mediumColor: Color {
        lightSettings.currentMode.mediumColor
    }

    // 深色背景 - 基于光源模式
    private var darkColor: Color {
        lightSettings.currentMode.darkColor
    }
}

#Preview {
    StarfieldBackgroundView(pitch: 15, roll: -10, yaw: 45)
}

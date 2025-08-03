import SwiftUI

struct StarfieldBackgroundView: View {
    // 飞机姿态数据，用于动态调整背景
    var pitch: Double = 0.0
    var roll: Double = 0.0
    var yaw: Double = 0.0

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

    // 动态光亮颜色 - 基于飞行姿态
    private var lightColor: Color {
        // 根据pitch调整亮度 - 机头向上时更亮
        let brightness = 0.3 + max(0, pitch / 90) * 0.4
        return Color(
            red: 0.2 + brightness * 0.3,
            green: 0.3 + brightness * 0.4,
            blue: 0.5 + brightness * 0.3
        )
    }

    // 中等亮度颜色
    private var mediumColor: Color {
        Color(red: 0.08, green: 0.12, blue: 0.20)
    }

    // 深色背景
    private var darkColor: Color {
        Color(red: 0.01, green: 0.01, blue: 0.03)
    }
}



#Preview {
    StarfieldBackgroundView(pitch: 15, roll: -10, yaw: 45)
}

import SwiftUI

struct CountdownView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var countdownValue = 3
    @State private var isCountdownActive = true
    @State private var showRipples = true
    @State private var countdownTimer: Timer?
    @State private var showingRecordingView = false

    let onAbort: (() -> Void)?
    let onRecordingComplete: (() -> Void)?
    let viewModel: FlightRecordingVM
    let lightSettings: LightSourceSettings
    
    var body: some View {
        ZStack {
            // 静态星空背景 - 倒计时页面使用默认参数
            StarfieldBackgroundView()
                .environment(lightSettings)
                .ignoresSafeArea()
            
            VStack(spacing: 32) {
                // 顶部标题
                HeaderCard()
                
                Spacer()
                
                // 倒计时显示区域
                CountdownDisplayView(
                    countdownValue: countdownValue,
                    showRipples: showRipples
                )
                
                // 手机位置指示
                PhonePositionIndicator()
                
                // 准备状态指示器
                PreparationStatusView()
                
                Spacer()
                
                // 取消按钮
                AbortButton {
                    // 停止倒计时
                    stopCountdown()
                    // 调用abort回调
                    onAbort?()
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 24)
        }
        .navigationBarHidden(true)
        .onAppear {
            startCountdown()
        }
        .onDisappear {
            stopCountdown()
        }
        .simplePageTransition(showSecondPage: $showingRecordingView) {
            RecordingActiveView(
                viewModel: viewModel,
                onStopRecording: {
                    // 录制完成，直接退回到MainView
                    showingRecordingView = false
                    onRecordingComplete?()
                }
            )
            .environment(lightSettings)
        }
    }
    
    private func startCountdown() {
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if countdownValue > 0 && isCountdownActive {
                // 触发震动
                HapticService.shared.medium()
                countdownValue -= 1
            } else {
                timer.invalidate()
                countdownTimer = nil

                if isCountdownActive {
                    // 正常完成倒计时
                    isCountdownActive = false
                    showRipples = false

                    // 倒计时结束，触发成功震动
                    HapticService.shared.success()

                    // 延迟1秒后直接转场到录制界面
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        viewModel.startRecording()

                        // 开始录制后跳转到录制界面
                        DispatchQueue.main.asyncAfter(deadline: .now() + AppConfig.Recording.transitionDelay) {
                            if viewModel.isRecording {
                                showingRecordingView = true
                            }
                        }
                    }
                }
            }
        }
    }

    private func stopCountdown() {
        isCountdownActive = false
        countdownTimer?.invalidate()
        countdownTimer = nil
    }
}

// MARK: - 头部卡片
struct HeaderCard: View {
    var body: some View {
        NavigationHeaderView(titleType: .preJeting, showRecordingBorder: false)
    }
}

// MARK: - 倒计时显示
struct CountdownDisplayView: View {
    let countdownValue: Int
    let showRipples: Bool
    @State private var pulseScale: CGFloat = 1.0
    @State private var glowIntensity: Double = 0.5
    
    var body: some View {
        ZStack {
            // 波纹效果
            if showRipples {
                ForEach(0..<3, id: \.self) { index in
                    RippleEffect(delay: Double(index))
                }
            }
            
            // 粒子效果
            ForEach(0..<8, id: \.self) { index in
                FloatingParticle(index: index)
            }
            
            // 倒计时数字
            ZStack {
                // 发光背景
                RoundedRectangle(cornerRadius: 30)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.orange.opacity(0.1),
                                Color.orange.opacity(0.05)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(Color.orange, lineWidth: 2)
                            .shadow(color: Color.orange.opacity(glowIntensity), radius: 20)
                    )
                
                // 数字显示
                Text(countdownValue > 0 ? "\(countdownValue)" : "GO!")
                    .font(.system(size: 120, weight: .black, design: .rounded))
                    .foregroundColor(countdownValue > 0 ? .orange : .green)
                    .shadow(color: countdownValue > 0 ? .orange : .green, radius: 20)
                    .shadow(color: countdownValue > 0 ? .orange : .green, radius: 40)
                    .scaleEffect(pulseScale)
            }
            .frame(width: 280, height: 280)
        }
        .onAppear {
            startAnimations()
        }
        .onChange(of: countdownValue) { _, _ in
            // 数字变化时的脉冲效果
            withAnimation(.easeInOut(duration: 0.3)) {
                pulseScale = 1.2
            }
            withAnimation(.easeInOut(duration: 0.3).delay(0.3)) {
                pulseScale = 1.0
            }
        }
    }
    
    private func startAnimations() {
        // 脉冲动画
        withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
            pulseScale = 1.1
        }
        
        // 发光动画
        withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
            glowIntensity = 1.0
        }
    }
}

// MARK: - 波纹效果
struct RippleEffect: View {
    let delay: Double
    @State private var scale: CGFloat = 0.3
    @State private var opacity: Double = 1.0

    var body: some View {
        Circle()
            .stroke(Color.orange, lineWidth: 2)
            .frame(width: 100, height: 100)
            .scaleEffect(scale)
            .opacity(opacity)
            .onAppear {
                withAnimation(
                    .easeOut(duration: 3.0)
                    .repeatForever(autoreverses: false)
                    .delay(delay)
                ) {
                    scale = 3.0
                    opacity = 0.0
                }
            }
    }
}

// MARK: - 浮动粒子
struct FloatingParticle: View {
    let index: Int
    @State private var offset: CGFloat = 0
    @State private var scale: CGFloat = 1.0
    @State private var opacity: Double = 0.3

    private var position: CGPoint {
        let positions: [CGPoint] = [
            CGPoint(x: 0.2, y: 0.2), CGPoint(x: 0.8, y: 0.3),
            CGPoint(x: 0.3, y: 0.7), CGPoint(x: 0.7, y: 0.8),
            CGPoint(x: 0.1, y: 0.5), CGPoint(x: 0.9, y: 0.6),
            CGPoint(x: 0.4, y: 0.1), CGPoint(x: 0.6, y: 0.9)
        ]
        return positions[index % positions.count]
    }

    var body: some View {
        Circle()
            .fill(Color.orange)
            .frame(width: 4, height: 4)
            .scaleEffect(scale)
            .opacity(opacity)
            .offset(y: offset)
            .position(
                x: position.x * 280,
                y: position.y * 280
            )
            .onAppear {
                withAnimation(
                    .easeInOut(duration: 4.0)
                    .repeatForever(autoreverses: true)
                    .delay(Double(index) * 0.5)
                ) {
                    offset = -30
                    scale = 1.5
                    opacity = 1.0
                }
            }
    }
}

#Preview {
    CountdownView(
        onAbort: {
            print("取消倒计时")
        },
        onRecordingComplete: {
            print("录制完成")
        },
        viewModel: FlightRecordingVM(),
        lightSettings: LightSourceSettings()
    )
    .preferredColorScheme(.dark)
}

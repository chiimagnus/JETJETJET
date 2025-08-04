import SwiftUI

// MARK: - 现代化播放控制组件
struct ModernPlaybackControlsView: View {
    let isPlaying: Bool
    let currentIndex: Int
    let totalCount: Int
    let currentTime: String
    let totalTime: String
    let onPlayPause: () -> Void
    let onSeek: (Int) -> Void
    let onSkipBackward: () -> Void
    let onSkipForward: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            // 播放控制按钮
            playbackButtons
            
            // 进度条和时间
            progressSection
        }
        .padding(16)
        .background(.ultraThinMaterial)
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.blue.opacity(0.3), lineWidth: 1)
        )
    }
}

// MARK: - 视图组件
extension ModernPlaybackControlsView {
    
    // 播放控制按钮
    private var playbackButtons: some View {
        HStack(spacing: 20) {
            // 快退按钮
            ControlButton(
                icon: "backward.end.fill",
                isActive: false,
                action: onSkipBackward
            )
            .disabled(totalCount == 0)
            
            // 播放/暂停按钮
            ControlButton(
                icon: isPlaying ? "pause.circle.fill" : "play.circle.fill",
                isActive: isPlaying,
                isLarge: true,
                action: onPlayPause
            )
            .disabled(totalCount == 0)
            
            // 快进按钮
            ControlButton(
                icon: "forward.end.fill",
                isActive: false,
                action: onSkipForward
            )
            .disabled(totalCount == 0)
        }
    }
    
    // 进度条和时间显示
    private var progressSection: some View {
        VStack(spacing: 8) {
            // 时间显示
            HStack {
                Text(currentTime)
                    .font(.caption)
                    .foregroundColor(.white)
                    .fontDesign(.monospaced)
                
                Spacer()
                
                Text(totalTime)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .fontDesign(.monospaced)
            }
            
            // 进度条
            if totalCount > 0 {
                ModernProgressBar(
                    currentIndex: currentIndex,
                    totalCount: totalCount,
                    onSeek: onSeek
                )
            } else {
                // 空状态进度条
                RoundedRectangle(cornerRadius: 3)
                    .fill(Color.white.opacity(0.1))
                    .frame(height: 6)
            }
        }
    }
}

// MARK: - 控制按钮组件
struct ControlButton: View {
    let icon: String
    let isActive: Bool
    let isLarge: Bool
    let action: () -> Void
    
    init(icon: String, isActive: Bool, isLarge: Bool = false, action: @escaping () -> Void) {
        self.icon = icon
        self.isActive = isActive
        self.isLarge = isLarge
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: isLarge ? 24 : 18, weight: .medium))
                .foregroundColor(isActive ? .blue : .white)
                .frame(width: isLarge ? 50 : 40, height: isLarge ? 50 : 40)
                .background(
                    Circle()
                        .fill(isActive ? Color.blue.opacity(0.2) : Color.white.opacity(0.1))
                        .overlay(
                            Circle()
                                .stroke(
                                    isActive ? Color.blue.opacity(0.5) : Color.white.opacity(0.2),
                                    lineWidth: 1
                                )
                        )
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - 现代化进度条组件
struct ModernProgressBar: View {
    let currentIndex: Int
    let totalCount: Int
    let onSeek: (Int) -> Void
    
    @State private var isDragging = false
    @State private var dragValue: Double = 0
    
    private var progress: Double {
        guard totalCount > 0 else { return 0 }
        return isDragging ? dragValue : Double(currentIndex) / Double(totalCount - 1)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // 背景轨道
                RoundedRectangle(cornerRadius: 3)
                    .fill(Color.white.opacity(0.1))
                    .frame(height: 6)
                
                // 进度填充
                RoundedRectangle(cornerRadius: 3)
                    .fill(
                        LinearGradient(
                            colors: [.green, .blue],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: geometry.size.width * progress, height: 6)
                    .animation(.easeInOut(duration: 0.1), value: progress)
                
                // 拖拽指示器
                Circle()
                    .fill(.blue)
                    .frame(width: 12, height: 12)
                    .shadow(color: .blue, radius: 4)
                    .offset(x: geometry.size.width * progress - 6)
                    .scaleEffect(isDragging ? 1.2 : 1.0)
                    .animation(.easeInOut(duration: 0.1), value: isDragging)
            }
        }
        .frame(height: 12)
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    isDragging = true
                    let newProgress = max(0, min(1, value.location.x / UIScreen.main.bounds.width))
                    dragValue = newProgress
                }
                .onEnded { value in
                    isDragging = false
                    let newIndex = Int(dragValue * Double(totalCount - 1))
                    onSeek(max(0, min(newIndex, totalCount - 1)))
                }
        )
    }
}

#Preview {
    VStack(spacing: 20) {
        ModernPlaybackControlsView(
            isPlaying: true,
            currentIndex: 45,
            totalCount: 100,
            currentTime: "01:23",
            totalTime: "02:34",
            onPlayPause: {},
            onSeek: { _ in },
            onSkipBackward: {},
            onSkipForward: {}
        )
        
        ModernPlaybackControlsView(
            isPlaying: false,
            currentIndex: 0,
            totalCount: 0,
            currentTime: "00:00",
            totalTime: "00:00",
            onPlayPause: {},
            onSeek: { _ in },
            onSkipBackward: {},
            onSkipForward: {}
        )
    }
    .padding()
    .background(.black)
}

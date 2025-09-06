import AVFoundation
import Foundation
import UIKit

/// 音效播放服务
class SoundService {
    static let shared = SoundService()
    
    private var audioPlayers: [String: AVAudioPlayer] = [:]
    
    private init() {
        setupAudioSession()
    }
    
    /// 配置音频会话
    private func setupAudioSession() {
        do {
            // 使用 playback 类别确保音效能播放
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers])
            try AVAudioSession.sharedInstance().setActive(true)
            print("✅ 音频会话配置成功")
        } catch {
            print("❌ 音频会话配置失败: \(error)")
        }
    }
    
    /// 播放音效
    /// - Parameters:
    ///   - soundName: 音效文件名（不包含扩展名）
    ///   - volume: 音量 (0.0 - 1.0)
    ///   - duration: 播放时长（秒），nil表示播放完整音频
    func playSound(_ soundName: String, volume: Float = 1.0, duration: TimeInterval? = nil) {
        // 如果已经有这个音效的播放器，直接使用
        if let player = audioPlayers[soundName] {
            player.volume = volume
            player.currentTime = 0 // 重置到开始
            player.play()

            // 如果指定了播放时长，设置定时器停止播放
            if let duration = duration {
                DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                    player.stop()
                }
            }
            return
        }

        // 从 Bundle 中加载音频文件
        print("🎵 尝试加载音效文件: \(soundName)")

        guard let url = Bundle.main.url(forResource: soundName, withExtension: "mp3") else {
            print("❌ 找不到音效文件: \(soundName).mp3")
            // 列出 Bundle 中的所有文件进行调试
            if let bundlePath = Bundle.main.resourcePath {
                let files = try? FileManager.default.contentsOfDirectory(atPath: bundlePath)
                print("📁 Bundle 中的文件: \(files?.prefix(10) ?? [])")
            }
            return
        }

        print("✅ 找到音效文件: \(url.lastPathComponent)")

        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.volume = volume
            player.prepareToPlay()

            print("🎵 音效播放器创建成功，音量: \(volume)")

            // 缓存播放器
            audioPlayers[soundName] = player

            let success = player.play()
            print("🎵 播放结果: \(success ? "成功" : "失败")")

            // 如果指定了播放时长，设置定时器停止播放
            if let duration = duration {
                print("⏱️ 设置 \(duration) 秒后停止播放")
                DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                    player.stop()
                    print("⏹️ 音效播放停止")
                }
            }
        } catch {
            print("❌ 播放音效失败: \(error)")
        }
    }
    
    /// 停止指定音效
    /// - Parameter soundName: 音效文件名
    func stopSound(_ soundName: String) {
        audioPlayers[soundName]?.stop()
    }
    
    /// 停止所有音效
    func stopAllSounds() {
        audioPlayers.values.forEach { $0.stop() }
    }
    
    /// 设置指定音效的音量
    /// - Parameters:
    ///   - soundName: 音效文件名
    ///   - volume: 音量 (0.0 - 1.0)
    func setVolume(_ volume: Float, for soundName: String) {
        audioPlayers[soundName]?.volume = volume
    }
    
    /// 预加载音效（提前准备可以减少播放延迟）
    /// - Parameter soundName: 音效文件名
    func preloadSound(_ soundName: String) {
        guard audioPlayers[soundName] == nil else { return }

        var url: URL?

        // 首先尝试从 Assets.xcassets 中加载
        if let asset = NSDataAsset(name: soundName) {
            // 创建临时文件来播放
            let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("\(soundName).mp3")
            do {
                try asset.data.write(to: tempURL)
                url = tempURL
            } catch {
                print("写入临时音效文件失败: \(error)")
            }
        } else {
            // 回退到 Bundle 中查找
            url = Bundle.main.url(forResource: soundName, withExtension: nil)
        }

        guard let audioURL = url else {
            print("找不到音效文件: \(soundName)")
            return
        }

        do {
            let player = try AVAudioPlayer(contentsOf: audioURL)
            player.prepareToPlay()
            audioPlayers[soundName] = player
        } catch {
            print("预加载音效失败: \(error)")
        }
    }
}

// MARK: - 便捷方法
extension SoundService {
    /// 播放页面切换音效（只播放前2秒）
    func playTransitionSound() {
        playSound("Whoosh Epic Explosion", volume: 0.7, duration: 2.0)
    }

    /// 预加载常用音效
    func preloadCommonSounds() {
        preloadSound("Whoosh Epic Explosion")
    }
}

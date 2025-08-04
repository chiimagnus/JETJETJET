import Foundation
import SceneKit
import UIKit

// MARK: - 飞机模型类型枚举
enum AirplaneModelType: String, CaseIterable {
    case defaultModel = "default"
    case jet1 = "jet1"

    var displayName: String {
        switch self {
        case .defaultModel:
            return "默认"
        case .jet1:
            return "JET1"
        }
    }

    var fileName: String? {
        switch self {
        case .defaultModel:
            return nil // 代码生成的模型
        case .jet1:
            return "jet" // jet.scn文件
        }
    }
}

// MARK: - 飞机模型配置
struct AirplaneModelConfig {
    let position: SCNVector3
    let rotation: SCNVector3
    let scale: SCNVector3
    let cameraPosition: SCNVector3
    let cameraLookAt: SCNVector3

    static let defaultConfig = AirplaneModelConfig(
        position: SCNVector3(0, 0, 0),
        rotation: SCNVector3(0, Float.pi, 0), // 180度Y轴旋转
        scale: SCNVector3(1, 1, 1),
        cameraPosition: SCNVector3(x: 0, y: 1, z: 2.2),
        cameraLookAt: SCNVector3(0, 0, 0)
    )

    static let jet1Config = AirplaneModelConfig(
        position: SCNVector3(0, 0, 0),
        rotation: SCNVector3(0, 0, 0), // 无初始旋转
        scale: SCNVector3(0.02, 0.02, 0.02),
        cameraPosition: SCNVector3(x: 0, y: 1, z: 2.2),
        cameraLookAt: SCNVector3(0, 0, 0)
    )

    static func config(for modelType: AirplaneModelType) -> AirplaneModelConfig {
        switch modelType {
        case .defaultModel:
            return defaultConfig
        case .jet1:
            return jet1Config
        }
    }
}

// MARK: - 3D飞机模型工具类
class Airplane3DModel {
    private var scene: SCNScene?
    private var airplaneNode: SCNNode?
    private let modelType: AirplaneModelType
    private let config: AirplaneModelConfig

    init(modelType: AirplaneModelType = .defaultModel) {
        self.modelType = modelType
        self.config = AirplaneModelConfig.config(for: modelType)
        setupScene()
    }
    
    private func setupScene() {
        let newScene = SCNScene()

        // 设置透明背景
        newScene.background.contents = UIColor.clear

        // 创建飞机模型
        let airplane = createAirplaneNode()
        newScene.rootNode.addChildNode(airplane)

        // 设置相机
        setupCamera(in: newScene)

        // 设置光源
        setupLighting(in: newScene)

        self.scene = newScene
        self.airplaneNode = airplane
    }
    
    private func createAirplaneNode() -> SCNNode {
        switch modelType {
        case .defaultModel:
            return createDefaultAirplaneNode()
        case .jet1:
            return createJet1AirplaneNode()
        }
    }

    private func createDefaultAirplaneNode() -> SCNNode {
        // 创建飞机主体 - 放大3倍
        let bodyGeometry = SCNBox(width: 0.4, height: 0.15, length: 2.4, chamferRadius: 0.06)
        bodyGeometry.firstMaterial?.diffuse.contents = UIColor.systemBlue
        bodyGeometry.firstMaterial?.specular.contents = UIColor.white
        bodyGeometry.firstMaterial?.shininess = 0.8

        let airplaneNode = SCNNode(geometry: bodyGeometry)
        airplaneNode.name = "airplane"

        // 添加机翼 - 放大3倍
        let wingGeometry = SCNBox(width: 2.4, height: 0.06, length: 0.45, chamferRadius: 0.03)
        wingGeometry.firstMaterial?.diffuse.contents = UIColor.systemBlue
        let wingNode = SCNNode(geometry: wingGeometry)
        wingNode.position = SCNVector3(0, 0, 0)
        airplaneNode.addChildNode(wingNode)

        // 添加尾翼 - 放大3倍
        let tailGeometry = SCNBox(width: 0.6, height: 0.45, length: 0.06, chamferRadius: 0.03)
        tailGeometry.firstMaterial?.diffuse.contents = UIColor.systemBlue
        let tailNode = SCNNode(geometry: tailGeometry)
        tailNode.position = SCNVector3(0, 0.15, -1.05)
        airplaneNode.addChildNode(tailNode)

        // 应用配置
        airplaneNode.position = config.position
        airplaneNode.eulerAngles = config.rotation
        airplaneNode.scale = config.scale

        return airplaneNode
    }

    private func createJet1AirplaneNode() -> SCNNode {
        guard let fileName = modelType.fileName,
              let sceneURL = Bundle.main.url(forResource: fileName, withExtension: "scn"),
              let scene = try? SCNScene(url: sceneURL) else {
            print("无法加载模型文件: \(modelType.fileName ?? "unknown")")
            // 如果加载失败，返回默认模型
            return createDefaultAirplaneNode()
        }

        // 创建容器节点
        let containerNode = SCNNode()
        containerNode.name = "airplane"

        // 复制场景中的所有子节点到容器节点
        for childNode in scene.rootNode.childNodes {
            containerNode.addChildNode(childNode.clone())
        }

        // 计算模型边界并居中
        centerModel(containerNode)

        // 应用配置
        containerNode.position = config.position
        containerNode.eulerAngles = config.rotation
        containerNode.scale = config.scale

        return containerNode
    }

    private func centerModel(_ node: SCNNode) {
        // 计算模型的边界框
        let (min, max) = node.boundingBox

        // 计算中心偏移
        let centerX = (min.x + max.x) / 2
        let centerY = (min.y + max.y) / 2
        let centerZ = (min.z + max.z) / 2

        // 将模型移动到中心
        node.position = SCNVector3(-centerX, -centerY, -centerZ)
    }
    
    private func setupCamera(in scene: SCNScene) {
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = config.cameraPosition
        cameraNode.look(at: config.cameraLookAt)
        scene.rootNode.addChildNode(cameraNode)
    }
    
    private func setupLighting(in scene: SCNScene) {
        // 环境光
        let ambientLight = SCNNode()
        ambientLight.light = SCNLight()
        ambientLight.light?.type = .ambient
        ambientLight.light?.intensity = 100
        scene.rootNode.addChildNode(ambientLight)
        
        // 定向光
        let directionalLight = SCNNode()
        directionalLight.light = SCNLight()
        directionalLight.light?.type = .directional
        directionalLight.light?.intensity = 500
        directionalLight.position = SCNVector3(x: 5, y: 10, z: 5)
        directionalLight.look(at: SCNVector3(0, 0, 0))
        scene.rootNode.addChildNode(directionalLight)
    }
    
    func getScene() -> SCNScene? {
        return scene
    }
    
    func getAirplaneNode() -> SCNNode? {
        return airplaneNode
    }
    
    func updateAirplaneAttitude(pitch: Double, roll: Double, yaw: Double) {
        guard let airplaneNode = airplaneNode else { return }

        // 将角度转换为弧度，并反转pitch和roll的符号以匹配iOS设备坐标系
        let pitchRadians = Float(-pitch * Double.pi / 180.0)  // 反转pitch
        let rollRadians = Float(-roll * Double.pi / 180.0)    // 反转roll
        let yawRadians = Float(yaw * Double.pi / 180.0)       // yaw保持不变

        // 根据模型类型应用不同的旋转逻辑
        switch modelType {
        case .defaultModel:
            // 应用旋转，同时保留初始的180度Y轴旋转（让飞机头朝里）
            airplaneNode.eulerAngles = SCNVector3(pitchRadians, yawRadians + Float.pi, rollRadians)
        case .jet1:
            // JET1模型直接应用旋转，无需额外的初始旋转
            airplaneNode.eulerAngles = SCNVector3(pitchRadians, yawRadians, rollRadians)
        }
    }
    
    func resetAirplanePosition() {
        guard let airplaneNode = airplaneNode else { return }
        // 重置到初始配置的旋转状态
        airplaneNode.eulerAngles = config.rotation
    }

    func getModelType() -> AirplaneModelType {
        return modelType
    }
}

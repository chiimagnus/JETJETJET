import Foundation
import SceneKit
import UIKit

// MARK: - 3D飞机模型工具类
class Airplane3DModel {
    private var scene: SCNScene?
    private var airplaneNode: SCNNode?
    private let modelType: AirplaneModelType

    init(modelType: AirplaneModelType = .defaultModel) {
        self.modelType = modelType
        setupScene()
    }
    
    private func setupScene() {
        let newScene = SCNScene()

        // 设置透明背景
        newScene.background.contents = UIColor.clear

        // 根据模型类型创建飞机模型
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
            return loadExternalAirplaneNode()
        }
    }

    private func createDefaultAirplaneNode() -> SCNNode {
        // 创建飞机主体 - 放大9倍（原来3倍 × 2倍 × 1.5倍）
        let bodyGeometry = SCNBox(width: 1.2, height: 0.45, length: 7.2, chamferRadius: 0.18)
        bodyGeometry.firstMaterial?.diffuse.contents = UIColor.systemBlue
        bodyGeometry.firstMaterial?.specular.contents = UIColor.white
        bodyGeometry.firstMaterial?.shininess = 0.8

        let airplaneNode = SCNNode(geometry: bodyGeometry)
        airplaneNode.name = "airplane"

        // 添加机翼 - 放大9倍（原来3倍 × 2倍 × 1.5倍）
        let wingGeometry = SCNBox(width: 7.2, height: 0.18, length: 1.35, chamferRadius: 0.09)
        wingGeometry.firstMaterial?.diffuse.contents = UIColor.systemBlue
        let wingNode = SCNNode(geometry: wingGeometry)
        wingNode.position = SCNVector3(0, 0, 0)
        airplaneNode.addChildNode(wingNode)

        // 添加尾翼 - 放大9倍（原来3倍 × 2倍 × 1.5倍）
        let tailGeometry = SCNBox(width: 1.8, height: 1.35, length: 0.18, chamferRadius: 0.09)
        tailGeometry.firstMaterial?.diffuse.contents = UIColor.systemBlue
        let tailNode = SCNNode(geometry: tailGeometry)
        tailNode.position = SCNVector3(0, 0.45, -3.15)
        airplaneNode.addChildNode(tailNode)

        // 旋转180度，让飞机头朝里，屁股朝向用户（默认模型保持原来的角度）
        airplaneNode.eulerAngles = SCNVector3(0, Float.pi, 0)

        return airplaneNode
    }

    private func loadExternalAirplaneNode() -> SCNNode {
        guard let fileName = modelType.fileName else {
            print("警告：模型类型 \(modelType) 没有对应的文件名，使用默认模型")
            return createDefaultAirplaneNode()
        }

        // 尝试从Resources目录加载.scn文件
        guard let sceneURL = Bundle.main.url(forResource: fileName.replacingOccurrences(of: ".scn", with: ""), withExtension: "scn") else {
            print("错误：无法找到模型文件 \(fileName)，使用默认模型")
            return createDefaultAirplaneNode()
        }

        do {
            let scene = try SCNScene(url: sceneURL, options: nil)

            // 查找飞机节点（通常是根节点的第一个子节点或名为特定名称的节点）
            let airplaneNode = findAirplaneNode(in: scene.rootNode) ?? scene.rootNode.childNodes.first ?? SCNNode()

            // 设置节点名称
            airplaneNode.name = "airplane"

            // 调整模型方向和大小（如果需要）
            adjustExternalModel(airplaneNode)

            return airplaneNode
        } catch {
            print("错误：加载模型文件失败 \(error)，使用默认模型")
            return createDefaultAirplaneNode()
        }
    }

    private func findAirplaneNode(in node: SCNNode) -> SCNNode? {
        // 查找名为"airplane"、"jet"或包含"plane"的节点
        if let name = node.name?.lowercased() {
            if name.contains("airplane") || name.contains("jet") || name.contains("plane") {
                return node
            }
        }

        // 递归查找子节点
        for childNode in node.childNodes {
            if let found = findAirplaneNode(in: childNode) {
                return found
            }
        }

        return nil
    }

    private func adjustExternalModel(_ node: SCNNode) {
        // 计算模型的边界框以确定合适的缩放比例
        let boundingBox = node.boundingBox
        let modelSize = SCNVector3(
            boundingBox.max.x - boundingBox.min.x,
            boundingBox.max.y - boundingBox.min.y,
            boundingBox.max.z - boundingBox.min.z
        )

        // 参考默认模型的大小（长度7.2，宽度7.2，高度约1.8）- 再放大50%
        let targetLength: Float = 7.2
        let targetWidth: Float = 7.2
        let targetHeight: Float = 1.8

        // 计算缩放比例，选择最小的比例以确保模型完全可见
        let scaleX = targetWidth / max(modelSize.x, 0.1)
        let scaleY = targetHeight / max(modelSize.y, 0.1)
        let scaleZ = targetLength / max(modelSize.z, 0.1)
        let uniformScale = min(scaleX, min(scaleY, scaleZ))

        // 应用缩放
        node.scale = SCNVector3(uniformScale, uniformScale, uniformScale)

        // 调整位置，确保模型居中
        let center = SCNVector3(
            (boundingBox.max.x + boundingBox.min.x) / 2,
            (boundingBox.max.y + boundingBox.min.y) / 2,
            (boundingBox.max.z + boundingBox.min.z) / 2
        )
        node.position = SCNVector3(-center.x * uniformScale, -center.y * uniformScale, -center.z * uniformScale)

        // 调整飞机角度：手机平放时正常显示，竖起时也正常显示（与默认模型保持一致）
        // X轴旋转-90度（pitch）+ Y轴旋转180度（yaw）
        node.eulerAngles = SCNVector3(-Float.pi/2, Float.pi, 0)

        // 应用与默认模型相同的材质颜色
        applyDefaultMaterial(to: node)

        print("模型调整完成 - 原始大小: \(modelSize), 缩放比例: \(uniformScale), 中心点: \(center)")
    }

    private func applyDefaultMaterial(to node: SCNNode) {
        // 递归遍历所有子节点，应用默认的蓝色材质
        applyMaterialRecursively(to: node)
    }

    private func applyMaterialRecursively(to node: SCNNode) {
        // 如果节点有几何体，应用材质
        if let geometry = node.geometry {
            // 创建与默认模型相同的材质
            let material = SCNMaterial()
            material.diffuse.contents = UIColor.systemBlue
            material.specular.contents = UIColor.white
            material.shininess = 0.8

            // 应用到所有材质槽
            geometry.materials = [material]
        }

        // 递归处理所有子节点
        for childNode in node.childNodes {
            applyMaterialRecursively(to: childNode)
        }
    }
    
    private func setupCamera(in scene: SCNScene) {
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 1, z: 2.2)
        cameraNode.look(at: SCNVector3(0, 0, 0))
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

        // 根据模型类型应用不同的基础角度
        switch modelType {
        case .defaultModel:
            // 默认模型：只保留Y轴180度旋转
            airplaneNode.eulerAngles = SCNVector3(pitchRadians, yawRadians + Float.pi, rollRadians)
        case .jet1:
            // 外部模型：保留X轴-90度 + Y轴180度旋转
            airplaneNode.eulerAngles = SCNVector3(pitchRadians - Float.pi/2, yawRadians + Float.pi, rollRadians)
        }
    }
    
    func resetAirplanePosition() {
        guard let airplaneNode = airplaneNode else { return }
        // 根据模型类型重置到不同的初始角度
        switch modelType {
        case .defaultModel:
            // 默认模型：只有Y轴180度旋转
            airplaneNode.eulerAngles = SCNVector3(0, Float.pi, 0)
        case .jet1:
            // 外部模型：X轴-90度 + Y轴180度
            airplaneNode.eulerAngles = SCNVector3(-Float.pi/2, Float.pi, 0)
        }
    }

    // 切换模型类型（重新创建模型）
    func switchModel(to newModelType: AirplaneModelType) {
        guard let scene = scene else { return }

        // 移除当前飞机节点
        airplaneNode?.removeFromParentNode()

        // 创建新的飞机节点
        let newAirplane = createAirplaneNodeForType(newModelType)
        scene.rootNode.addChildNode(newAirplane)

        // 更新引用
        self.airplaneNode = newAirplane
    }

    private func createAirplaneNodeForType(_ type: AirplaneModelType) -> SCNNode {
        switch type {
        case .defaultModel:
            return createDefaultAirplaneNode()
        case .jet1:
            return loadExternalAirplaneNode()
        }
    }
}

import SwiftUI
import SceneKit

class Airplane3DModel {
    private var scene: SCNScene?
    private var airplaneNode: SCNNode?
    
    init() {
        setupScene()
    }
    
    private func setupScene() {
        let newScene = SCNScene()
        
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
        
        // 旋转180度，让飞机头朝里，屁股朝向用户
        airplaneNode.eulerAngles = SCNVector3(0, Float.pi, 0)
        
        return airplaneNode
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
        
        // 将角度转换为弧度并应用到飞机模型
        let pitchRadians = Float(pitch * Double.pi / 180.0)
        let rollRadians = Float(roll * Double.pi / 180.0)
        let yawRadians = Float(yaw * Double.pi / 180.0)
        
        // 应用旋转（注意SceneKit的坐标系）
        airplaneNode.eulerAngles = SCNVector3(pitchRadians, yawRadians, rollRadians)
    }
    
    func resetAirplanePosition() {
        guard let airplaneNode = airplaneNode else { return }
        airplaneNode.eulerAngles = SCNVector3(0, 0, 0)
    }
} 
//
//  YXHomeVC.swift
//  ARKitDemo
//
//  Created by ios on 2021/7/29.
//

import UIKit
import ARKit
import SceneKit

struct Masks: OptionSet {
    
    let rawValue: Int
    static let ship = Masks(rawValue: 1 << 0)
    static let bullet = Masks(rawValue: 1 << 1)
}

class YXWorldVC: YXBaseVC, ARSessionDelegate, ARSCNViewDelegate {

    lazy var sceneView : ARSCNView = {
        
        //初始AR渲染摄像层
        let sceneView = ARSCNView.init(frame: self.view.bounds)
        //打开光线评估运算。ARSCNView将自动使用该功能，并基于所测算的真实世界光照条件来给物体打光
        sceneView.automaticallyUpdatesLighting = true
        sceneView.delegate = self
        #if DEBUG
        //开启关键点监测
        sceneView.debugOptions = ARSCNDebugOptions.showFeaturePoints
        #endif
        return sceneView
    }()
    
    lazy var planeNode: SCNReferenceNode = {
        
        guard let url = Bundle.main.url(forResource: "art.scnassets/ship", withExtension: "scn")
        else {
            fatalError("ship.scn not exit.")
        }
        let v : Float = 0.2
        let planeNode = SCNReferenceNode(url: url)!
        planeNode.load()
        planeNode.scale = SCNVector3Make(v, v, v)
        planeNode.name = "plane"
        
        return planeNode
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(self.sceneView)
        self.initShip()
        self.initPlane()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //初始世界视角，充分利用所有的运动信息，并给出最佳的结果。需要注意的是，它只支持苹果A9处理器，或者更高
        let configuration = ARWorldTrackingConfiguration()
        //开启自动水平监测
        configuration.planeDetection = .horizontal
        //打开光线评估运算。ARSCNView将自动使用该功能，并基于所测算的真实世界光照条件来给物体打光
        configuration.isLightEstimationEnabled = true
        //开始捕捉画面
        self.sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.sceneView.session.pause()
    }
    
    //MARK:- progress
    //点击
    @objc func singleTapAction(gesture: UITapGestureRecognizer) {
     
        let point = gesture.location(in: self.sceneView)
        let hitResult = self.sceneView.hitTest(point, options: nil)
        for hit in hitResult {
            let node = hit.node
            if node == self.planeNode {
                print("find plane")
                let rotation = SCNAction.rotate(by: 10, around: SCNVector3Make(0, 1, 0), duration: 3)
                node.runAction(rotation)
            }
            if node.name == "shipMesh" {
                NSLog("tapped")
                let rotation = SCNAction.rotate(by: 3, around: SCNVector3Make(0, 1, 0), duration: 2)
                let moveUp = SCNAction.move(by: SCNVector3Make(0, 5, 0), duration: 2)
                let group = SCNAction.group([rotation, moveUp])
                node.runAction(group)
            }
        }
        if self.view.layer.contains(point) {
            NSLog("point.x == %d", point.x)
        }
    }

    //MARK:- ARSCNViewDelegate
    //渲染平面
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        guard anchor is ARPlaneAnchor else { return }
        
        DispatchQueue.main.async {
        
            node.addChildNode(self.planeNode)
            
            let lightNode = SCNNode()
            lightNode.light = SCNLight()
            lightNode.light!.type = .omni
            lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
            node.addChildNode(lightNode)
            
            let ambientLightNode = SCNNode()
            ambientLightNode.light = SCNLight()
            ambientLightNode.light!.type = .ambient
            ambientLightNode.light!.color = UIColor.gray
            node.addChildNode(ambientLightNode)
        }
    }
    
    //MARK:- 初始化
    func initShip() {
        
        let ship = YXWorldShip()
        let shipX : Double = 0
        let shipY : Double = 0.3
        let shipZ : Double = -0.5
        ship.position = SCNVector3(shipX, shipY, shipZ)
        self.sceneView.scene.rootNode.addChildNode(ship)
        
        //球形
        let bullet = YXWorldBullet()
        let bulletX : Double = 0.1
        let bulletY : Double = 0
        let bulletZ : Double = -0.2
        bullet.position = SCNVector3(bulletX, bulletY, bulletZ)
        self.sceneView.scene.rootNode.addChildNode(bullet)
    }
    
    func initPlane() {
        
        let singleTap : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(singleTapAction(gesture:)))
        self.sceneView.addGestureRecognizer(singleTap)
    }
    
}

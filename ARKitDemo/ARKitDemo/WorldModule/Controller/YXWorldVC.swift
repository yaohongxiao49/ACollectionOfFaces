//
//  YXHomeVC.swift
//  ARKitDemo
//
//  Created by ios on 2021/7/29.
//

import UIKit
import ARKit

struct Masks: OptionSet {
    
    let rawValue: Int
    static let ship = Masks(rawValue: 1 << 0)
    static let bullet = Masks(rawValue: 1 << 1)
}

class YXWorldVC: YXBaseVC, ARSessionDelegate {

    lazy var sceneView : ARSCNView = {
        
        let sceneView = ARSCNView.init(frame: self.view.bounds)
        sceneView.automaticallyUpdatesLighting = true
        return sceneView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(self.sceneView)
        self.initShip()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        self.sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.sceneView.session.pause()
    }
    
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

}

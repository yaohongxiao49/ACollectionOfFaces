//
//  YXHomeBullet.swift
//  ARKitDemo
//
//  Created by ios on 2021/7/29.
//

import UIKit
import ARKit

class YXWorldBullet: SCNNode {

    override init() {
        super.init()
        
        //形状：球体
        let sphere = SCNSphere(radius: 0.025)
        self.geometry = sphere
        //物理实体
        let shape = SCNPhysicsShape(geometry: sphere)
        self.physicsBody = SCNPhysicsBody(type: .dynamic, shape: shape)
        
        self.physicsBody?.isAffectedByGravity = false //不受引力影响
        self.physicsBody?.categoryBitMask = Masks.bullet.rawValue //自身是识别码
        self.physicsBody?.contactTestBitMask = Masks.ship.rawValue //碰撞的掩码
        
        //添加节点的图片
        let material = SCNMaterial()
        material.diffuse.contents = UIImage.init(named: "sanlian")
        self.geometry?.materials = [material]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

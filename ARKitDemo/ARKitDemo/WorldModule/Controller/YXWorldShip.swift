//
//  YXShip.swift
//  ARKitDemo
//
//  Created by ios on 2021/7/29.
//

import UIKit
import ARKit

class YXWorldShip: SCNNode {

    override init() {
        super.init()
        
        //正方体
        let box = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
        self.geometry = box
        
        let shape = SCNPhysicsShape(geometry: box)
        self.physicsBody = SCNPhysicsBody(type: .dynamic, shape: shape)
        self.physicsBody?.isAffectedByGravity = false
        self.physicsBody?.categoryBitMask = Masks.ship.rawValue
        self.physicsBody?.contactTestBitMask = Masks.bullet.rawValue
        
        let material = SCNMaterial()
        material.diffuse.contents = UIImage.init(named: "battle")
        
        self.geometry?.materials = [material, material, material, material, material, material]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//
//  Bullet.swift
//  EnigmaAR
//
//  Created by Ido Chetrit on 14/04/2018.
//  Copyright © 2018 Ido Chetrit. All rights reserved.
//

import UIKit
import SceneKit

class Bullet: SCNNode {
  override init () {
    super.init()
    let sphere = SCNSphere(radius: 0.025)
    self.geometry = sphere
    let shape = SCNPhysicsShape(geometry: sphere, options: nil)
    self.physicsBody = SCNPhysicsBody(type: .dynamic, shape: shape)
    self.physicsBody?.isAffectedByGravity = false
    
    self.physicsBody?.categoryBitMask = CollisionCategory.bullets.rawValue
    self.physicsBody?.contactTestBitMask = CollisionCategory.ship.rawValue
    
    // add texture
    let material = SCNMaterial()
    material.diffuse.contents = UIImage(named: "bullet_texture")
    self.geometry?.materials  = [material]
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}

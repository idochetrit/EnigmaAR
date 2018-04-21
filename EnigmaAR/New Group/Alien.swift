//
//  Alien.swift
//  EnigmaAR
//
//  Created by Ido Chetrit on 14/04/2018.
//  Copyright © 2018 Ido Chetrit. All rights reserved.
//

import UIKit
import SceneKit

class Alien: SCNNode {
  
  override init() {
    super.init()
    
    let alienScene = SCNScene(named: "art.scnassets/Alien.scn")!
    
    for childNode in alienScene.rootNode.childNodes {
      self.addChildNode(childNode)
    }
    let box = SCNBox(width: 0.5, height: 1.0, length: 0.2, chamferRadius: 0)
    self.geometry = box
    let shape = SCNPhysicsShape(geometry: box, options: nil)
    self.physicsBody = SCNPhysicsBody(type: .dynamic, shape: shape)
    self.physicsBody?.isAffectedByGravity = false
    
    self.physicsBody?.categoryBitMask = CollisionCategory.alien.rawValue
    self.physicsBody?.contactTestBitMask = CollisionCategory.bullets.rawValue
    
    self.scale = SCNVector3(0.05, 0.05, 0.05)
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

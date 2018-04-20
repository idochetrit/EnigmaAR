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
    self.geometry = alienScene.rootNode.geometry
    self.position = alienScene.rootNode.position
    
    self.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
    self.physicsBody?.isAffectedByGravity = false
    
    self.physicsBody?.categoryBitMask = CollisionCategory.alien.rawValue
    self.physicsBody?.contactTestBitMask = CollisionCategory.bullets.rawValue
    
    self.scale = SCNVector3(0.5, 0.5, 0.5)
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

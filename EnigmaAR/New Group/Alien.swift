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
    
    let alienScene = SCNScene(named: "art.scnassets/Robot.scn")!
    
    for childNode in alienScene.rootNode.childNodes {
      self.addChildNode(childNode)
    }
    let box = SCNBox(width: 10.0, height: 1.5, length: 55.5, chamferRadius: 0)
    let clear =  SCNMaterial()
    clear.diffuse.contents = UIColor.clear
    box.materials = [clear]
    self.geometry = box
//    guard let alienGeometry = self.geometry
//      else {print("oops"); return}
//    let shape = SCNPhysicsShape(geometry: box, options: nil)
    self.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
    self.physicsBody?.isAffectedByGravity = false
    
    self.physicsBody?.categoryBitMask = CollisionCategory.alien.rawValue
    self.physicsBody?.contactTestBitMask = CollisionCategory.bullets.rawValue
    
    
  
    self.scale = SCNVector3(0.07, 0.07, 0.07)
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

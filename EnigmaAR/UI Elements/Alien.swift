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
  var id: Int?
  var parentPlaneNode: SCNNode!
  static let BitMask = 0b0001

  init(id: Int) {
    super.init()
    self.id = id
    
    // add scene
    let alienScene = SCNScene(named: "art.scnassets/Robot.scn")!
    guard let rootAlienNode = alienScene.rootNode.childNode(withName: "Robot", recursively: true)
      else { print("cant find scene"); return }
    let alienNodes: [SCNNode] = rootAlienNode.childNodes

    for childNode in alienNodes {
      self.addChildNode(childNode)
    }
    
    
//    let w = CGFloat(2.0)
//    let h = CGFloat(4.277)
//    let l =  CGFloat(2.387)
//    let box = SCNBox(width: w, height: h, length: l, chamferRadius: 0)
//    let clear =  SCNMaterial()
//    clear.transparency = 0.5
//    clear.diffuse.contents = UIColor.lightGray
//    box.materials = [clear]
//    self.geometry = box
//    let shape = SCNPhysicsShape(geometry: box, options: nil)
    self.geometry = rootAlienNode.geometry
    let shape = SCNPhysicsShape(node: self,
                                options: [SCNPhysicsShape.Option.type: SCNPhysicsShape.ShapeType.boundingBox])

    self.physicsBody = SCNPhysicsBody(type: .dynamic, shape: shape)
    self.physicsBody?.isAffectedByGravity = false
    self.physicsBody?.contactTestBitMask = Bullet.BitMask
    self.physicsBody?.categoryBitMask = Alien.BitMask
    
    // adds lighting
//    self.addLight(alienScene: alienScene)
    
    self.scale = SCNVector3(0.07, 0.07, 0.07)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func addLight(alienScene: SCNScene) {
    guard let lightNode = alienScene.rootNode.childNode(withName: "Sun", recursively: true)
      else {return}
    self.light = lightNode.light
  }
  
  func updateLocation() {
    guard let wrapperNode = self.parent,
      let planeNode = self.parentPlaneNode
      else { return }
    
    let transform = planeNode.transform
    let insertionYOffset : Float = 1.9
    
    let position = SCNVector3(
      transform.m31 + Float(self.id!) * (0.8),
      transform.m32 - insertionYOffset,
      transform.m33 - 0.5
    )
    wrapperNode.position = position
  }
  
}

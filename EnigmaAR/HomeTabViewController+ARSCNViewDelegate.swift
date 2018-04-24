//
//  HomeViewController+ARSCNViewDelegate.swift
//  EnigmaAR
//
//  Created by Ido Chetrit on 14/04/2018.
//  Copyright © 2018 Ido Chetrit. All rights reserved.
//

import ARKit

extension HomeViewController : ARSCNViewDelegate {
  
  // MARK: - ARSCNViewDelegate
  func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
    guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
    
    // 2
    let width = CGFloat(planeAnchor.extent.x)
    let height = CGFloat(planeAnchor.extent.z)
    let plane = SCNPlane(width: width, height: height)
    
    // 3
    plane.materials.first?.diffuse.contents = UIColor.lightGray
    plane.materials.first?.transparency = 0.2
    
    // 4
    let planeNode = Plane(planeAnchor)
    planeNode.geometry = plane
    planeNode.position = SCNVector3Make(planeAnchor.center.x, 0, planeAnchor.center.z)
    planeNode.eulerAngles.x = -.pi / 2
    
    // 6
    node.addChildNode(planeNode)
    planeNodes.append(planeNode)
  }
  
  func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
//    guard let planeAnchor = anchor as? ARPlaneAnchor
//      else { return }
    for planeNode in planeNodes {
      if planeNode == node {
        guard let plane = planeNode.geometry as? SCNPlane
          else {return}
        let currentAnchor = planeNode.anchor
        
        let width = CGFloat(currentAnchor.extent.x)
        let height = CGFloat(currentAnchor.extent.z)
        plane.width = width
        plane.height = height
        
        // 3
        let x = CGFloat(currentAnchor.center.x)
        let y = CGFloat(currentAnchor.center.y)
        let z = CGFloat(currentAnchor.center.z)
        planeNode.position = SCNVector3(x, y, z)
      }
    }
    
    //  updateAliensLocations def?
//    for alien in aliens {
//      alien.updateLocation()
//    }
  }

  // MARK: Nodes setup
  
  func addCrosshair() {
    let node = SCNNode()
    node.geometry?.materials.first?.diffuse.contents = UIImage(named: "crosshair")
//    let center = self.view.center
//    guard let realWorldPosition = self.sceneView.scene.realWorldPosition(for: center) else { return }
    node.position = SCNVector3Zero
    sceneView.scene.rootNode.addChildNode(node)
  }
  
  func configureLighting() {
    sceneView.autoenablesDefaultLighting = false
    sceneView.automaticallyUpdatesLighting = true
    
    // add lighting
    let light = SCNLight()
    light.type = .ambient
    light.spotInnerAngle = 45
    light.spotOuterAngle = 45
    light.shadowRadius = 10.0

    // add to spot node
    let spotNode = SCNNode()
    spotNode.light = light
    spotNode.castsShadow = true
    spotNode.position = SCNVector3(100, 100, 170);
    spotNode.eulerAngles.x = -.pi / 2
    sceneView.scene.rootNode.addChildNode(spotNode)
  }
  
  func addAlienNode(planeNode: Plane, index: Int) {
    let alienNode = Alien(id: index)
    
//    guard let planeNode = self.sceneView.node(for: anchor)
//      else { return }
    alienNode.parentPlaneNode = planeNode
    
    let wrapperNode = SCNNode()
    let transform = SCNVector3.positionFromTransform(planeNode.anchor.transform)
    
    
    let insertionYOffset : Float = 2.0
    let toggled = index % 2 == 0
    let intervalXOffset =  Float(index) * (0.2)
    let intervalZOffset =  Float(index) * (1.4)
    let position = SCNVector3(
      transform.x + (toggled ? -intervalXOffset : intervalXOffset),
      transform.y - insertionYOffset,
      transform.z - 1 + (toggled ? -intervalZOffset : intervalZOffset)
    )
    wrapperNode.position = position
    wrapperNode.addChildNode(alienNode)
//    let objPos = planeNode.convertPosition(alienNode.position, from: planeNode)
//    alienNode.position = objPos
    
//    alienNode.position.y -= insertionYOffset
    alienNode.eulerAngles.z = -.pi / 2
    print("Alien pos. ", alienNode.position)
    print("Plane wrapper Node pos. ", wrapperNode.position)
    
    sceneView.scene.rootNode.addChildNode(wrapperNode)
    aliens.append(alienNode)
  }
  
  func floatBetween(_ first: Float,  and second: Float) -> Float {
    // random float between upper and lower bound (inclusive)
    return (Float(arc4random()) / Float(UInt32.max)) * (first - second) + second
  }
  
  func getUserVector() -> (SCNVector3, SCNVector3) { // (direction, position)
    if let frame = self.sceneView.session.currentFrame {
      let mat = SCNMatrix4(frame.camera.transform) // 4x4 transform matrix describing camera in world space
      let dir = SCNVector3(-1 * mat.m31, -1 * mat.m32, -1 * mat.m33) // orientation of camera in world space
      let pos = SCNVector3(mat.m41, mat.m42, mat.m43) // location of camera in world space
      
      return (dir, pos)
    }
    return (SCNVector3(0, 0, -1), SCNVector3(0, 0, -0.2))
  }
}

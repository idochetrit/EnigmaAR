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
  
  
  /*Implement this to provide a custom node for the given anchor.
   @discussion This node will automatically be added to the scene graph.
   If this method is not implemented, a node will be automatically created.
   If nil is returned the anchor will be ignored.
   @param renderer The renderer that will render the scene.
   @param anchor The added anchor.
   @return Node that will be mapped to the anchor or nil.
   */
  func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
    guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
    
    // 2
    let width = CGFloat(planeAnchor.extent.x)
    let height = CGFloat(planeAnchor.extent.z)
    let plane = SCNPlane(width: width, height: height)
    
    // 3
    plane.materials.first?.diffuse.contents = UIColor.lightGray
    
    // 4
    let planeNode = SCNNode(geometry: plane)
    planeNode.position = SCNVector3Make(planeAnchor.center.x,
                                        planeAnchor.center.y,
                                        planeAnchor.center.z)
    planeNode.eulerAngles.x = -.pi / 2
    
    // 6
    node.addChildNode(planeNode)
    
    DispatchQueue.main.async {
      if (self.aliens.count < 5) {
        self.addAlienNode(node: planeNode, index: self.aliens.count)
      }
    }
  }
  
  func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
    guard let planeAnchor = anchor as? ARPlaneAnchor,
      let planeNode = node.childNodes.first,
      let plane = planeNode.geometry as? SCNPlane
      else { return }

    let width = CGFloat(planeAnchor.extent.x)
    let height = CGFloat(planeAnchor.extent.z)
    plane.width = width
    plane.height = height

    // 3
    let x = CGFloat(planeAnchor.center.x)
    let y = CGFloat(planeAnchor.center.y)
    let z = CGFloat(planeAnchor.center.z)
    planeNode.position = SCNVector3(x, y, z)
  }
  
  func addCrosshair() {
    let node = SCNNode()
    node.geometry?.materials.first?.diffuse.contents = UIImage(named: "crosshair")
//    let center = self.view.center
//    guard let realWorldPosition = self.sceneView.scene.realWorldPosition(for: center) else { return }
    node.position = SCNVector3(0,0,0)
    sceneView.scene.rootNode.addChildNode(node)
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

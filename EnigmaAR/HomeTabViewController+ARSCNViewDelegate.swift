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

    // This visualization covers only detected planes.
    guard let planeAnchor = anchor as? ARPlaneAnchor else { return }

    // Create a SceneKit plane to visualize the node using its position and extent.
    let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
    let planeNode = SCNNode(geometry: plane)
    planeNode.position = SCNVector3Make(planeAnchor.center.x, 0, planeAnchor.center.z)

    // SCNPlanes are vertically oriented in their local coordinate space.
    // Rotate it to match the horizontal orientation of the ARPlaneAnchor.
    planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2, 1, 0, 0)

    // ARKit owns the node corresponding to the anchor, so make the plane a child node.
    currentAnchor = planeAnchor
    node.addChildNode(planeNode)
    addAlienNode(position: planeNode)
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

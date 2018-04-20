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
    print("flat plane detected")

    // Create a SceneKit plane to visualize the node using its position and extent.
    let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
    let planeNode = SCNNode(geometry: plane)
    planeNode.position = SCNVector3Make(planeAnchor.center.x, 0, planeAnchor.center.z)

    // SCNPlanes are vertically oriented in their local coordinate space.
    // Rotate it to match the horizontal orientation of the ARPlaneAnchor.
    planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2, 1, 0, 0)

    // ARKit owns the node corresponding to the anchor, so make the plane a child node.
    node.addChildNode(planeNode)
  }
  
  
}

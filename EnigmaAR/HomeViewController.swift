//
//  HomeViewController.swift
//  EnigmaAR
//
//  Created by Ido Chetrit on 07/04/2018.
//  Copyright © 2018 Ido Chetrit. All rights reserved.
//

import UIKit
import ARKit

class HomeViewController: UIViewController, SCNPhysicsContactDelegate {

  @IBOutlet weak var sceneView: ARSCNView!
  var screenCenter: CGPoint?
  let planeHeight: CGFloat = 0.01
  
  // MARK: - Queues
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Show statistics such as fps and timing information
    configureLighting()
    setUpWorld()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    configureSession()
  }
  
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    // Pause the view's session
    sceneView.session.pause()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Release any cached data, images, etc that aren't in use.
  }

  
  
  // MARK: - Actions
  
  @IBAction func didTapScreen(_ sender: UITapGestureRecognizer) { // fire bullet in direction camera is facing
    
    // Play torpedo sound when bullet is launched
    
//    self.playSoundEffect(ofType: .torpedo)
    
    let bulletsNode = Bullet()
    
    let (direction, position) = self.getUserVector()
    bulletsNode.position = position // SceneKit/AR coordinates are in meters
    
    let bulletDirection = direction
    bulletsNode.physicsBody?.applyForce(bulletDirection, asImpulse: true)
    sceneView.scene.rootNode.addChildNode(bulletsNode)
    
  }
  
  func removeNodeWithAnimation(_ node: SCNNode, explosion: Bool) {
    
    // Play collision sound for all collisions (bullet-bullet, etc.)
    
//    self.playSoundEffect(ofType: .collision)
    
    if explosion {
      
      // Play explosion sound for bullet-ship collisions
      
//      self.playSoundEffect(ofType: .explosion)
      
//      let particleSystem = SCNParticleSystem(named: "explosion", inDirectory: nil)
      let systemNode = SCNNode()
//      systemNode.addParticleSystem(particleSystem!)
      // place explosion where node is
      systemNode.position = node.position
      sceneView.scene.rootNode.addChildNode(systemNode)
    }
    
    // remove node
    node.removeFromParentNode()
  }
  
  
  // MARK: - Contact Delegate
  
  func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
    //print("did begin contact", contact.nodeA.physicsBody!.categoryBitMask, contact.nodeB.physicsBody!.categoryBitMask)
    if contact.nodeA.physicsBody?.categoryBitMask == CollisionCategory.alien.rawValue || contact.nodeB.physicsBody?.categoryBitMask == CollisionCategory.alien.rawValue { // this conditional is not required--we've used the bit masks to ensure only one type of collision takes place--will be necessary as soon as more collisions are created/enabled
      
      print("Hit alien!")
      self.removeNodeWithAnimation(contact.nodeB, explosion: false) // remove the bullet
//      self.userScore += 1
      
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
        // remove/replace ship after half a second to visualize collision
        self.removeNodeWithAnimation(contact.nodeA, explosion: true)
        self.addAlienNode()
      })
      
    }
  }
  
   // MARK: - Game Functionality
  
  private func configureSession() {
    // Create a session configuration
    let configuration = ARWorldTrackingConfiguration()
    configuration.planeDetection = .horizontal
    
    // Run the view's session
    sceneView.session.run(configuration)
  }
  
  private func setUpWorld() {
    // Set the view's delegate
    sceneView.delegate = self
    
    // Show statistics such as fps and timing information, debuge options
    sceneView.showsStatistics = true
    sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
    
    // Create a new empty scene
    let scene = SCNScene()
    
    // Set the scene to the view
    sceneView.scene = scene
    sceneView.scene.physicsWorld.contactDelegate = self
    
    // adds aliens
    addAlienNode()
  }
  
  
  private func addAlienNode() {
    let alienNode = Alien()
    
    let posX = floatBetween(-0.5, and: 0.5 )
    let posY = floatBetween(-0.5, and: 0.5 )
//    let posY = currentPlane.anchor.center.x
    alienNode.position = SCNVector3(posX, posY, 0) // SceneKit/AR coordinates are in meters
//    return alienNode
    sceneView.scene.rootNode.addChildNode(alienNode)
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
  
  func configureLighting() {
    sceneView.autoenablesDefaultLighting = true
    sceneView.automaticallyUpdatesLighting = true
  }
  
  
  func session(_ session: ARSession, didFailWithError error: Error) {
    // Present an error message to the user
    print("Session failed with error: \(error.localizedDescription)")
  }
  
  func sessionWasInterrupted(_ session: ARSession) {
    // Inform the user that the session has been interrupted, for example, by presenting an overlay
    
  }
  
  func sessionInterruptionEnded(_ session: ARSession) {
    // Reset tracking and/or remove existing anchors if consistent tracking is required
    
  }
}

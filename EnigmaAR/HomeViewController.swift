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
  var currentPlaneNode: SCNPlane!
  var currentAnchor: ARPlaneAnchor!
  
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
  
  @IBAction func didTapScreen(_ sender: UITapGestureRecognizer) {
    // fire bullet in direction camera is facing
    
    // Play torpedo sound when bullet is launched
    
//    self.playSoundEffect(ofType: .torpedo)
//
//    let tapLocation = sender.location(in: self.sceneView)
//    let hitTestResults = self.sceneView.hitTest(tapLocation, types: .estimatedHorizontalPlane)
//
//    guard let hitTestResult = hitTestResults.first else { return }
//    let t = hitTestResult.worldTransform.translation
//    self.addAlienNode(position: SCNVector3(t.x, t.y, t.z))

    let bulletsNode = Bullet()

    let (direction, position) = getUserVector()
    bulletsNode.position = position // SceneKit/AR coordinates are in meters

    let bulletDirection = direction
    bulletsNode.physicsBody?.applyForce(bulletDirection, asImpulse: true)
    sceneView.scene.rootNode.addChildNode(bulletsNode)
    
  }
  
  func removeNodeWithAnimation(_ node: SCNNode, explosion: Bool) {
    // Play collision sound for all collisions (bullet-bullet, etc.)
//    self.playSoundEffect(ofType: .collision)
    
    if explosion {
      
      let particleSystem = SCNParticleSystem(named: "explosion", inDirectory: "art.scnassets")
      let systemNode = SCNNode()
      systemNode.addParticleSystem(particleSystem!)
      // place explosion where node is
      systemNode.position = node.position
      sceneView.scene.rootNode.addChildNode(systemNode)
    }
    
    // remove node
    node.removeFromParentNode()
  }
  
  
  // MARK: - Contact Delegate
  
  func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
    print("did begin contact", contact.nodeA.physicsBody!.categoryBitMask, contact.nodeB.physicsBody!.categoryBitMask)
    
    print("Hit alien!")
    // remove the bullet
    self.removeNodeWithAnimation(contact.nodeB, explosion: false)
//      self.userScore += 1
    
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
      // // remove/replace ship after half a second to visualize collision
        self.removeNodeWithAnimation(contact.nodeA, explosion: true)
//        self.addAlienNode()
      })
    
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
    sceneView.debugOptions = ARSCNDebugOptions.showFeaturePoints
    
    // Set the scene to the view
    sceneView.scene = SCNScene()
    sceneView.scene.physicsWorld.contactDelegate = self
  }
  
  
  func addAlienNode(position: SCNNode) {
    let alienNode = Alien()
    
//    let x = position.x
//    let y = position.y
//    let z = position.z

    
    sceneView.scene.rootNode.addChildNode(alienNode)
//    let planeAnchorNode = sceneView.node(for: currentAnchor)!
    let objPos = position.convertPosition(alienNode.position, from: position)
    let x = objPos.x
    let y = objPos.y
    let z = objPos.z
    alienNode.position = SCNVector3(x, y, z)
    
  }
  
  func configureLighting() {
    sceneView.autoenablesDefaultLighting = true
    sceneView.automaticallyUpdatesLighting = true
  }
}

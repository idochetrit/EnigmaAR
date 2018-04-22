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
  var screenCenter: CGPoint!
  var currentAnchor: ARPlaneAnchor!
  var aliens : [Alien] = []
  var hasAliens : Bool = false
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

    let (dir, pos) = getUserVector()
    bulletsNode.position = pos // SceneKit/AR coordinates are in meters

    let bulletVector = SCNVector3(dir.x * 4, dir.y * 4, dir.z * 4)
    bulletsNode.physicsBody?.applyForce(bulletVector, asImpulse: true)
    sceneView.scene.rootNode.addChildNode(bulletsNode)
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: {
      self.removeNodeWithAnimation(bulletsNode, explosion: false)
    })
    
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
//    sceneView.debugOptions = ARSCNDebugOptions.showFeaturePoints
    
    // Set the scene to the view
    sceneView.scene = SCNScene()
    sceneView.scene.physicsWorld.contactDelegate = self
    
    addCrosshair()
  }
  
  
  func addAlienNode(node: SCNNode, index: Int) {
    let alienNode = Alien()

    let objPos = node.convertPosition(alienNode.position, from: node)
//    let toggled = (index % 2 == 0)
    let insertionYOffset : Float = 1.7
    let x = objPos.x + Float(index) * (0.3)
    let y = objPos.y - insertionYOffset
    let z = objPos.z - 0.5

    alienNode.position = SCNVector3(x, y, z)
    alienNode.eulerAngles.x = -.pi / 2
    print("Alien pos. ", alienNode.position)
    print("Plane Node pos. ", node.position)
    
    sceneView.scene.rootNode.addChildNode(alienNode)
    aliens.append(alienNode)
  }
  
  func configureLighting() {
    sceneView.autoenablesDefaultLighting = true
    sceneView.automaticallyUpdatesLighting = true
  }
}

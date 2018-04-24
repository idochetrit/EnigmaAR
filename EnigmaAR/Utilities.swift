/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 Utility functions and type extensions used throughout the projects.
 */

import Foundation
import ARKit

// MARK: - Collection extensions
extension Array {
  func randomItem() -> Element? {
    if self.isEmpty { return nil }
    let randomIndex: Int = Int(arc4random_uniform(UInt32(self.count)))
    return self[randomIndex]
  }
}

extension Array where Iterator.Element == Float {
  var average: Float? {
    guard !self.isEmpty else {
      return nil
    }
    
    let sum = self.reduce(Float(0)) { current, next in
      return current + next
    }
    return sum / Float(self.count)
  }
}

extension Array where Iterator.Element == float3 {
  var average: float3? {
    guard !self.isEmpty else {
      return nil
    }
    
    let sum = self.reduce(float3(0)) { current, next in
      return current + next
    }
    return sum / Float(self.count)
  }
}

// MARK: - SCNNode extension

extension SCNNode {
  
  func setUniformScale(_ scale: Float) {
    self.simdScale = float3(scale, scale, scale)
  }
  
  func renderOnTop(_ enable: Bool) {
    self.renderingOrder = enable ? 2 : 0
    if let geom = self.geometry {
      for material in geom.materials {
        material.readsFromDepthBuffer = enable ? false : true
      }
    }
    for child in self.childNodes {
      child.renderOnTop(enable)
    }
  }
}

// MARK: - float4x4 extensions

extension float4x4 {
  /// Treats matrix as a (right-hand column-major convention) transform matrix
  /// and factors out the translation component of the transform.
  var translation: float3 {
    let translation = self.columns.3
    return float3(translation.x, translation.y, translation.z)
  }
}

// MARK: - CGPoint extensions

extension CGPoint {
  
  init(_ size: CGSize) {
    self.init()
    self.x = size.width
    self.y = size.height
  }
  
  init(_ vector: SCNVector3) {
    self.init()
    self.x = CGFloat(vector.x)
    self.y = CGFloat(vector.y)
  }
  
  func distanceTo(_ point: CGPoint) -> CGFloat {
    return (self - point).length()
  }
  
  func length() -> CGFloat {
    return sqrt(self.x * self.x + self.y * self.y)
  }
  
  func midpoint(_ point: CGPoint) -> CGPoint {
    return (self + point) / 2
  }
  static func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
  }
  
  static func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
  }
  
  static func += (left: inout CGPoint, right: CGPoint) {
    left = left + right
  }
  
  static func -= (left: inout CGPoint, right: CGPoint) {
    left = left - right
  }
  
  static func / (left: CGPoint, right: CGFloat) -> CGPoint {
    return CGPoint(x: left.x / right, y: left.y / right)
  }
  
  static func * (left: CGPoint, right: CGFloat) -> CGPoint {
    return CGPoint(x: left.x * right, y: left.y * right)
  }
  
  static func /= (left: inout CGPoint, right: CGFloat) {
    left = left / right
  }
  
  static func *= (left: inout CGPoint, right: CGFloat) {
    left = left * right
  }
}

// MARK: - CGSize extensions

extension CGSize {
  init(_ point: CGPoint) {
    self.init()
    self.width = point.x
    self.height = point.y
  }
  
  static func + (left: CGSize, right: CGSize) -> CGSize {
    return CGSize(width: left.width + right.width, height: left.height + right.height)
  }
  
  static func - (left: CGSize, right: CGSize) -> CGSize {
    return CGSize(width: left.width - right.width, height: left.height - right.height)
  }
  
  static func += (left: inout CGSize, right: CGSize) {
    left = left + right
  }
  
  static func -= (left: inout CGSize, right: CGSize) {
    left = left - right
  }
  
  static func / (left: CGSize, right: CGFloat) -> CGSize {
    return CGSize(width: left.width / right, height: left.height / right)
  }
  
  static func * (left: CGSize, right: CGFloat) -> CGSize {
    return CGSize(width: left.width * right, height: left.height * right)
  }
  
  static func /= (left: inout CGSize, right: CGFloat) {
    left = left / right
  }
  
  static func *= (left: inout CGSize, right: CGFloat) {
    left = left * right
  }
}

// MARK: - CGRect extensions

extension CGRect {
  var mid: CGPoint {
    return CGPoint(x: midX, y: midY)
  }
}

func rayIntersectionWithHorizontalPlane(rayOrigin: float3, direction: float3, planeY: Float) -> float3? {
  
  let direction = simd_normalize(direction)
  
  // Special case handling: Check if the ray is horizontal as well.
  if direction.y == 0 {
    if rayOrigin.y == planeY {
      // The ray is horizontal and on the plane, thus all points on the ray intersect with the plane.
      // Therefore we simply return the ray origin.
      return rayOrigin
    } else {
      // The ray is parallel to the plane and never intersects.
      return nil
    }
  }
  
  // The distance from the ray's origin to the intersection point on the plane is:
  //   (pointOnPlane - rayOrigin) dot planeNormal
  //  --------------------------------------------
  //          direction dot planeNormal
  
  // Since we know that horizontal planes have normal (0, 1, 0), we can simplify this to:
  let dist = (planeY - rayOrigin.y) / direction.y
  
  // Do not return intersections behind the ray's origin.
  if dist < 0 {
    return nil
  }
  
  // Return the intersection point.
  return rayOrigin + (direction * dist)
}


// MARK: - SCNVector3 extensions
extension SCNVector3 {
  
  init(_ vec: vector_float3) {
    self.init()
    self.x = vec.x
    self.y = vec.y
    self.z = vec.z
  }
  
  func length() -> Float {
    return sqrtf(x * x + y * y + z * z)
  }
  
  mutating func setLength(_ length: Float) {
    self.normalize()
    self *= length
  }
  
  mutating func setMaximumLength(_ maxLength: Float) {
    if self.length() <= maxLength {
      return
    } else {
      self.normalize()
      self *= maxLength
    }
  }
  
  mutating func normalize() {
    self = self.normalized()
  }
  
  func normalized() -> SCNVector3 {
    if self.length() == 0 {
      return self
    }
    
    return self / self.length()
  }
  
  static func positionFromTransform(_ transform: matrix_float4x4) -> SCNVector3 {
    return SCNVector3Make(transform.columns.3.x, transform.columns.3.y, transform.columns.3.z)
  }
  
  func friendlyString() -> String {
    return "(\(String(format: "%.2f", x)), \(String(format: "%.2f", y)), \(String(format: "%.2f", z)))"
  }
  
  func dot(_ vec: SCNVector3) -> Float {
    return (self.x * vec.x) + (self.y * vec.y) + (self.z * vec.z)
  }
  
  func cross(_ vec: SCNVector3) -> SCNVector3 {
    return SCNVector3(self.y * vec.z - self.z * vec.y, self.z * vec.x - self.x * vec.z, self.x * vec.y - self.y * vec.x)
  }
}

public let SCNVector3One: SCNVector3 = SCNVector3(1.0, 1.0, 1.0)

func SCNVector3Uniform(_ value: Float) -> SCNVector3 {
  return SCNVector3Make(value, value, value)
}

func SCNVector3Uniform(_ value: CGFloat) -> SCNVector3 {
  return SCNVector3Make(Float(value), Float(value), Float(value))
}

func + (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
  return SCNVector3Make(left.x + right.x, left.y + right.y, left.z + right.z)
}

func - (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
  return SCNVector3Make(left.x - right.x, left.y - right.y, left.z - right.z)
}

func += (left: inout SCNVector3, right: SCNVector3) {
  left = left + right
}

func -= (left: inout SCNVector3, right: SCNVector3) {
  left = left - right
}

func / (left: SCNVector3, right: Float) -> SCNVector3 {
  return SCNVector3Make(left.x / right, left.y / right, left.z / right)
}

func * (left: SCNVector3, right: Float) -> SCNVector3 {
  return SCNVector3Make(left.x * right, left.y * right, left.z * right)
}

func /= (left: inout SCNVector3, right: Float) {
  left = left / right
}

func *= (left: inout SCNVector3, right: Float) {
  left = left * right
}

// MARK: - SCNMaterial extensions
extension SCNMaterial {
  
  static func material(withDiffuse diffuse: Any?, respondsToLighting: Bool = true) -> SCNMaterial {
    let material = SCNMaterial()
    material.diffuse.contents = diffuse
    material.isDoubleSided = true
    if respondsToLighting {
      material.locksAmbientWithDiffuse = true
    } else {
      material.ambient.contents = UIColor.black
      material.lightingModel = .constant
      material.emission.contents = diffuse
    }
    return material
  }
}



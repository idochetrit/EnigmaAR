struct CollisionCategory: OptionSet {
  let rawValue: Int
  
  static let bullets  = CollisionCategory(rawValue: 1 << 0) // 00...01
  static let ship = CollisionCategory(rawValue: 1 << 1) // 00..10
}

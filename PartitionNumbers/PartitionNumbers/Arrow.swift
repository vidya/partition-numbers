//
//  Arrow.swift
//  TrimSegment
//
//  Created by Dad on 4/14/15.
//  Copyright (c) 2015 Resilia, Inc. All rights reserved.
//

import Foundation
import SpriteKit

class Arrow : VJSprite {
  
  enum PhysicsCategory: UInt32 {
    case Arrow = 1
    case Brick = 2
    
    case None = 0
    //    case All = UInt32.max.rawValue
  }

  convenience init(params: [String : AnyObject]) {

    self.init(properties: params)

    initPhysicsBody()
    
    physicsBody?.categoryBitMask      = PhysicsCategory.Arrow.rawValue
    physicsBody?.collisionBitMask     = PhysicsCategory.None.rawValue
    
    physicsBody?.contactTestBitMask   = PhysicsCategory.Brick.rawValue
  }

  func moveToTarget(target: CGPoint, arrowCount: Int) {
//    var duration = CGFloat(arrowCount) + 1.0
    var duration = CGFloat(arrowCount) / 4.0

    let moveAction = SKAction.moveTo(target, duration: NSTimeInterval(duration))
    let waitAction = SKAction.waitForDuration(NSTimeInterval(5 * (arrowCount + 1)))
    
    let actionList = SKAction.sequence([moveAction, waitAction])
    
    runAction(actionList)  
  }
  
  class func hasBodyTypeOf(body: SKPhysicsBody) -> Bool {
    return (body.categoryBitMask & PhysicsCategory.Arrow.rawValue != 0)
  }
  
  func getGroup() -> Int { return userData!["group"] as! Int }
  
  func remove() {
    runAction(SKAction.fadeOutWithDuration(2.0))
    removeFromParent()
  }
  
}

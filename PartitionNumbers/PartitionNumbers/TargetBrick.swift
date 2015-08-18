//
//  TargetBrick.swift
//  TrimSegment
//
//  Created by Dad on 4/14/15.
//  Copyright (c) 2015 Resilia, Inc. All rights reserved.
//

import Foundation
import SpriteKit

class TargetBrick : VJSprite {
  
  enum PhysicsCategory: UInt32 {
    case Arrow = 1
    case Brick = 2
    
    case None = 0
    //    case All = UInt32.max.rawValue
  }
  
  convenience init(params: [String:AnyObject], totalBrickCount: Int, brickNum: Int) {
    
    self.init(properties: params)
    
    initPhysicsBody()
    
    physicsBody?.categoryBitMask = PhysicsCategory.Brick.rawValue
    
    physicsBody?.collisionBitMask = PhysicsCategory.None.rawValue
    
    physicsBody?.contactTestBitMask =  PhysicsCategory.Arrow.rawValue
    
    userData = ["target_num" : (brickNum + 1)]
    
    let brickLabel = getBrickLabel("\(brickNum + 1)")
    
    brickLabel.position = CGPointMake(-1, -6)
    
    addChild(brickLabel)
  }
  
  private func getBrickLabel(inText: String) -> SKLabelNode {
  
    let label          = SKLabelNode(text: inText)
    
    label.fontColor    = UIColor.blueColor()
    label.fontSize     = 28
    
    label.xScale       = 0.6
    label.yScale       = 0.6
    
    return label
  }
  
  class func hasBodyTypeOf(body: SKPhysicsBody) -> Bool {
    return (body.categoryBitMask & PhysicsCategory.Brick.rawValue != 0)
  }

  func remove() {
    runAction(SKAction.fadeOutWithDuration(2.0))
    removeFromParent()
  }

}

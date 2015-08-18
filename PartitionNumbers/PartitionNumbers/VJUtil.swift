//
//  VJUtil.swift
//  TrimSegment
//
//  Created by Dad on 5/4/15.
//  Copyright (c) 2015 Resilia, Inc. All rights reserved.
//

import Foundation
import SpriteKit

class VJUtil {

  class func getBodyPair(contact: SKPhysicsContact) -> (SKPhysicsBody, SKPhysicsBody) {
    
    var firstBody: SKPhysicsBody
    var secondBody: SKPhysicsBody
    
    if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
      firstBody = contact.bodyA
      secondBody = contact.bodyB
    }
    else {
      firstBody = contact.bodyB
      secondBody = contact.bodyA
    }
    
    return (firstBody, secondBody)
  }
}

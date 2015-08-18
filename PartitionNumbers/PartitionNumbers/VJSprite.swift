//
//  VJSprite.swift
//  TrimSegment
//
//  Created by Dad on 3/20/15.
//  Copyright (c) 2015 Resilia, Inc. All rights reserved.
//

import Foundation
import SpriteKit

class VJSprite : SKSpriteNode {

  convenience init(properties dict: [String : AnyObject]) {

    var texture = SKTexture(imageNamed: dict["image"] as! String!)
    self.init(texture: texture, color: nil, size: texture.size())
    
    if let value = dict["xScale"] as? CGFloat{ xScale = value }
    if let value = dict["yScale"] as? CGFloat{ yScale = value }
    
    name = dict["name"] as? String
    
    let point = dict["location"]as! NSValue
    position = point.CGPointValue()
  }
  
  func initPhysicsBody() {
    physicsBody = SKPhysicsBody(rectangleOfSize: frame.size)
    physicsBody?.dynamic = true
    
    physicsBody?.usesPreciseCollisionDetection = true
  }
}

//
//  TargetContainer.swift
//  TrimSegment
//
//  Created by Dad on 5/7/15.
//  Copyright (c) 2015 Resilia, Inc. All rights reserved.
//

import Foundation

import SpriteKit

class TargetBrickContainer : SKNode {
  
  //  GameScene.swift
  //  TrimSegment
  //
  //  Created by Dad on 3/20/15.
  //  Copyright (c) 2015 Resilia, Inc. All rights reserved.
  //
  
  convenience init(location: CGPoint) {
    
    self.init()
    
    let targetContainerPosition = CGPointMake(self.position.x - 80, self.position.y + 380)


    let moveAction = SKAction.moveTo(targetContainerPosition, duration: NSTimeInterval(0.1))
    
    runAction(moveAction)
  }
  
  func createBrickList(totalBrickCount: Int, inLocation: CGPoint) -> [VJSprite] {
    var
      params:     [String : AnyObject]    = [:],
    
//      spacing:    CGFloat                 = 30.0,
      spacing:    CGFloat                 = 34.0,
      brickList:  [TargetBrick]           = [],
      
      location                            = inLocation
    
    params["xScale"]      = 0.8
    params["yScale"]      = 0.8
    
    params["name"]        = "brick"
    params["image"]       = "Target"
    
    for brickNum in 0 ..< totalBrickCount {
      
      if brickNum % 10 == 0 {
        location.x  = inLocation.x
        location.y  -= 28.0
      }
  
      params["location"]    = NSValue(CGPoint: location)

      brickList         += [TargetBrick(params: params, totalBrickCount: totalBrickCount, brickNum: brickNum)]

      location.x        += spacing
    }

    for brick in brickList { addChild(brick) }

    return brickList
  }
  
  func removeBrick(brick: TargetBrick) {
    brick.removeFromParent()
  }
  
}

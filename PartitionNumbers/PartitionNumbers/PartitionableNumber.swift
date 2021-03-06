//
//  PartitionableNumber.swift
//  TrimSegment
//
//  Created by Dad on 5/7/15.
//  Copyright (c) 2015 Resilia, Inc. All rights reserved.
//

import Foundation
import SpriteKit

class PartitionableNumber : VJSprite {
  var targetNum = 0
  var label : SKLabelNode?
  var goalShape: SKShapeNode?
  
  convenience init(params: [String : AnyObject]) {
    self.init(properties: params)
    
    targetNum = params["targetNum"] as! Int

    label = getPartitionableNumberLabel("\(targetNum)")
    
    label!.position = CGPointMake(-1, -6)
    
    addChild(label!)
  }
  
  func setCompleted() {  
    label!.text = "X"
  }
  
  func removeHighlight() {
      goalShape?.removeFromParent()
  }
  
  func highlightShape() -> SKShapeNode {
    var goalShape = SKShapeNode(rect: self.frame)
    
    goalShape.strokeColor = SKColor.blueColor()
    goalShape.fillColor = SKColor.redColor()
    goalShape.glowWidth = 4
    
    self.goalShape = goalShape
    
    return goalShape
  }
  
  private func getPartitionableNumberLabel(inLabel: String) -> SKLabelNode {
    
    let label          = SKLabelNode(text: inLabel)
    
    label.fontColor    = UIColor.blueColor()
    label.fontSize     = 30
    
    label.xScale       = 0.6
    label.yScale       = 0.6
    
    return label
  }
}


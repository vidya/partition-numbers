//
//  Endpoint.swift
//  TrimSegment
//
//  Created by Dad on 5/7/15.
//  Copyright (c) 2015 Resilia, Inc. All rights reserved.
//

import Foundation

import SpriteKit

class Endpoint : VJSprite {
  var targetNum = 0
  var label : SKLabelNode?
  
  convenience init(params: [String : AnyObject]) {
    self.init(properties: params)
    
    targetNum = params["targetNum"] as! Int

    label = getEndpointLabel("\(targetNum)")
    
    label!.position = CGPointMake(-1, -6)
    
    addChild(label!)
  }
  
  func setCompleted() {  
    label!.text = "X"
  }
  
  private func getEndpointLabel(inLabel: String) -> SKLabelNode {
    
    let label          = SKLabelNode(text: inLabel)
    
    label.fontColor    = UIColor.blueColor()
    label.fontSize     = 30
    
    label.xScale       = 0.6
    label.yScale       = 0.6
    
    return label
  }
}


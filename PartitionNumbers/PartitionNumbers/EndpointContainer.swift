//
//  EndPoint.swift
//  TrimSegment
//
//  Created by Dad on 5/7/15.
//  Copyright (c) 2015 Resilia, Inc. All rights reserved.
//

import Foundation

import SpriteKit


class EndpointContainer : SKNode {
 
  var
    targetNumList     : [Int] = [],
    endpointList      : [Endpoint] = [],
  
    endpointIndex     = 0
  
  convenience init(inLocation: CGPoint) {
    var
      params:     [String : AnyObject]    = [:],
      
      spacing:    CGFloat                 = 30.0,
      brickList:  [TargetBrick]           = [],
      
      location                            = inLocation
    
    params["xScale"]      = 0.9
    params["yScale"]      = 0.9
    
    params["name"]        = "endPoint"
    params["image"]       = "Target"
    
    self.init()

    var targetNum : Int
    
    endpointList = []
    for groupCount in 0 ..< 3 {
      for eltCount in 0 ..< 3 {
        
        // avoid duplicates in target numbers
        //
        do {
          targetNum = Int(arc4random() % 88) + 11
        } while contains(targetNumList, targetNum)

        targetNumList += [targetNum]
        
        params["targetNum"]   = targetNum
        params["location"]    = NSValue(CGPoint: location)

        let endPoint = Endpoint(params: params)
        
        endpointList += [endPoint]
        
        self.addChild(endPoint)
        
        location.x += 36
      }
      
      location.x = inLocation.x
      location.y -= 30
    }
  }
  
  func getNextEndpoint() -> Endpoint? {
    return (endpointIndex < 9) ? endpointList[endpointIndex++] : nil
  }
}
  

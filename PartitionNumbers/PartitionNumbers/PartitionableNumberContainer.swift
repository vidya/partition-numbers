//
//  EndPoint.swift
//  TrimSegment
//
//  Created by Dad on 5/7/15.
//  Copyright (c) 2015 Resilia, Inc. All rights reserved.
//

import Foundation

import SpriteKit


class PartitionableNumberContainer : SKNode {
 
  var
    targetNumList     : [Int] = [],
    partitionableNumberList: [PartitionableNumber] = [],
  
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
   
    // sort target numbers
    //
    for groupCount in 0 ..< 3 {
      for eltCount in 0 ..< 3 {
        
        // avoid duplicates in target numbers
        //
        do {
          targetNum = Int(arc4random() % 88) + 11
        } while contains(targetNumList, targetNum)
        
        targetNumList += [targetNum]
      }
    }
    
    targetNumList.sort(<)
    
    partitionableNumberList = []
    for groupCount in 0 ..< 3 {
      for eltCount in 0 ..< 3 {

        params["targetNum"]   = targetNumList[3 * groupCount + eltCount]
        params["location"]    = NSValue(CGPoint: location)

        let partitionableNumber = PartitionableNumber(params: params)
        
        partitionableNumberList += [partitionableNumber]
        
        self.addChild(partitionableNumber)
        
        location.x += 36
      }
      
      location.x = inLocation.x
      location.y -= 30
    }
  }
  
  func getNextPartitionableNumber() -> PartitionableNumber? {
    return (endpointIndex < 9) ? partitionableNumberList[endpointIndex++] : nil
  }
}
  

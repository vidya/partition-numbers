//
//  ArrowPouch.swift
//  TrimSegment
//
//  Created by Dad on 4/15/15.
//  Copyright (c) 2015 Resilia, Inc. All rights reserved.
//

import Foundation
import SpriteKit

class ArrowPouch : VJSprite {

  var
    arrowList: [Arrow]?
  
  convenience init(properties: [String : AnyObject], userDataDict: NSMutableDictionary) {
    
    self.init(properties: properties)
    
    userData = userDataDict
  }
  
  func createArrows(location: CGPoint) -> [Arrow] {
    var
      params:     [String : AnyObject]    = [:],
      arrowList:  [Arrow]                 = []
    
    let arrowCount = userData!.valueForKey("value")! as! Int

    params["name"]        = "blueArrow"
    params["image"]       = "ArrowBlue"
    
    params["xScale"]      = 0.6
    params["yScale"]      = 0.6
    
    params["location"]    = NSValue(CGPoint: location)
    
    for num in 0 ..< arrowCount {

      let arr = Arrow(params: params)
      arr.userData = userData
      arr.userData!["arrowNumber"] = num
      
      arrowList += [arr]
    }
    
    self.arrowList = arrowList
    
    return arrowList
  }

}


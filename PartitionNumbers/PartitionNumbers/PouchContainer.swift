//
// Created by Dad on 4/13/15.
// Copyright (c) 2015 Resilia, Inc. All rights reserved.
//

import Foundation
import SpriteKit

import SwiftyJSON

class PouchContainer : SKNode {
  
  typealias IntArray = [Int]

  class func callArithmeticAPI(targetNum: Int, completionHandler:(success:Bool, blockArray: [IntArray]) -> Void) {
    var blockArray = [IntArray]()

//    let url     = "http://localhost:3000/api/v1/segments/three_segments/?whole_num=\(targetNum)&low_limit=1&high_limit=\(targetNum)"
    let url     = "http://numapi.herokuapp.com/api/v1/segments/three_segments/?whole_num=\(targetNum)&low_limit=1&high_limit=\(targetNum)"
    
    let myUrl   = NSURL(string: url)
    
    let task = NSURLSession.sharedSession().dataTaskWithURL(myUrl!) {(data, response, error) in
      
      if error != nil {
          println("---> error = \(error)")
        
        completionHandler(success: false, blockArray: blockArray)
        return
      }
      
      let json = JSON(data: data)
      
      println("json: \(json)")
      for (x: String, outDict: JSON) in json {

        let y = outDict.rawValue as! [String : AnyObject]
        
        println("x: \(x)")
        println("y: \(y)")
        
        if x != "output" { continue }
            
        println("outDict: \(outDict)")

        let s1 = outDict["first_segment"].rawValue as! IntArray
        let s2 = outDict["second_segment"].rawValue as! IntArray
        let s3 = outDict["third_segment"].rawValue as! IntArray
        
        blockArray = [s1, s2, s3]
        
        println("blockArray: \(blockArray)")
    }
      
      completionHandler(success: true, blockArray: blockArray)
    }
    
    task.resume()
  }

  private func getPouchLabel(label: String) -> SKLabelNode {
    
    let pouchLabel          = SKLabelNode()
    
    pouchLabel.fontColor    = UIColor.redColor()
    pouchLabel.fontSize     = 28
    
    pouchLabel.text         = label
    
      pouchLabel.xScale       = 0.7
      pouchLabel.yScale       = 0.7
    
    return pouchLabel
  }

  func addArrowPouches(blockArray: [IntArray]) {
    var
      buttonParams:     [String : AnyObject]    = [:],

      spacing:          CGFloat                 = 40.0,
      groupSpacing:     CGFloat                 = 20.0

    println("addArrowPouches(): start")

    removeAllChildren()
    
//    var location = CGPointMake(self.frame.midX + 300, self.frame.midY + 160)
    var location = CGPointMake(self.frame.midX + 300, self.frame.midY + 120)

    for groupCount in 0 ..< 3 {
      for eltCount in 0 ..< 3 {

        let digitIndex = blockArray[groupCount][eltCount] - 1
        
        buttonParams["image"]       = "Target.png"

        buttonParams["location"]    = NSValue(CGPoint: location)

        let userDataDict = ["value" : (digitIndex + 1), "group" : groupCount] as NSMutableDictionary

        let btn = ArrowPouch(properties: buttonParams, userDataDict: userDataDict)
        
        let pouchLabel = getPouchLabel("\(digitIndex + 1)")
        
        pouchLabel.position = CGPointMake(-1, -6)
        
        btn.addChild(pouchLabel)

        self.addChild(btn)

        location.x        += spacing
      }

      location.x        += groupSpacing
    }
  }
  
  func removePouchGroup(groupUsed: Int) {
    
    for pouch in self.children {
      let pouchDict = pouch.userData!
      
      let pouchGroup = pouchDict!["group"] as! Int
      
      if (pouchGroup == groupUsed) { pouch.runAction(SKAction.fadeOutWithDuration(3.0)) }
    }
  }
  
  func getTouchedPouch(location: CGPoint) -> ArrowPouch? {
    
    for btn in children {
      if btn.containsPoint(location) { return btn as? ArrowPouch }
    }
    
    return nil
  }
  

}
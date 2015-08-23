//
// Created by Dad on 4/13/15.
// Copyright (c) 2015 Resilia, Inc. All rights reserved.
//

import Foundation
import SpriteKit

import SwiftyJSON
import Dollar


class ArrowPouchContainer: SKNode {
  
  typealias IntArray = [Int]

  var targetNum : Int?
  
  func setTargetNum(target: Int) {
      targetNum = target
  }
  
  func getBlockTriplet(jsonData: JSON) -> [IntArray] {
    
    var blockTriplet = [IntArray]()
    
    for (x: String, outDict: JSON) in jsonData {
      
      if x == "output" {
        let s1 = outDict["first_segment"].rawValue as! IntArray
        let s2 = outDict["second_segment"].rawValue as! IntArray
        let s3 = outDict["third_segment"].rawValue as! IntArray
        
        blockTriplet = [s1, s2, s3]
        
        break
      }
    }
    
    return blockTriplet
  }
  
  func valueTripletHasDuplicates(valueTriplet: IntArray) -> Bool {
    return (valueTriplet.count != $.uniq(valueTriplet).count)
  }
  
  func blockTripletIsValid(blockTriplet: [IntArray]) -> Bool {
    
    for valueTriplet in blockTriplet {
      if valueTripletHasDuplicates(valueTriplet) { return false }
    }
    
    return true
  }

  func sortBlockTriplet(blockTriplet: [IntArray]) -> [IntArray] {
    
    var sortedBlockTriplet = [IntArray]()
    
    for block in blockTriplet {
      var tmpBlock = block
      tmpBlock.sort(<)
      
      sortedBlockTriplet += [tmpBlock]
    }

    return sortedBlockTriplet
  }
  
  func getBlockTripletFromApi() {
    var blockTriplet = [IntArray]()
    
    let myUrl   = NSURL(string: self.getApiUrlString(targetNum!))
    
    let request = NSURLRequest(URL:myUrl!)

    NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { response,data,error in
      
      if error == nil {        
        let jsonData = JSON(data: data)
        
        blockTriplet = self.getBlockTriplet(jsonData)
        
        if self.blockTripletIsValid(blockTriplet) {
          
          let notificationName = "validTriplet"
          
          let notification = NSNotification(
            name: notificationName,
            object: self,
            
            userInfo: [
              "targetNum"       : self.targetNum!,
              "blockTriplet"    : self.sortBlockTriplet(blockTriplet)
            ]
          )
          
          NSNotificationCenter.defaultCenter().postNotification(notification)
        }
        else {
          println("--> invalid blockTriplet: \(blockTriplet)")
          
          let notificationName = "invalidTriplet"
          
          let notification = NSNotification(
            name: notificationName,
            object: self,
            
            userInfo: [
              "targetNum"       : self.targetNum!,
              "blockTriplet"    : self.sortBlockTriplet(blockTriplet)
            ]
          )
          
          NSNotificationCenter.defaultCenter().postNotification(notification)
        }
      }
      else {
        println("---> error = \(error)")
        
        let notificationName = "apiError"
        
        let notification = NSNotification(
          name: notificationName,
          object: self,
          
          userInfo: ["error" : error]
        )
        
        NSNotificationCenter.defaultCenter().postNotification(notification)
      }
      
    }
  }

  func setInvalidTripletObserver() {
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleInvalidTriplet:", name: "invalidTriplet", object: nil)
  }
  
  @objc func handleInvalidTriplet(notificationObject : AnyObject) {
    print("---> notificationObject = \(notificationObject)")
    
    self.getBlockTripletFromApi()
  }

  func getApiUrlString(targetNum: Int) -> String {
    
    let url     = "http://localhost:3000/api/v1/segments/three_segments/?whole_num=\(targetNum)&low_limit=1&high_limit=\(targetNum)"
    
    //    let url     = "http://numapi.herokuapp.com/api/v1/segments/three_segments/?whole_num=\(targetNum)&low_limit=1&high_limit=\(targetNum)"
    
    return url
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

  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
}

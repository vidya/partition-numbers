
//  GameScene.swift
//  TrimSegment
//
//  Created by Dad on 3/20/15.
//  Copyright (c) 2015 Resilia, Inc. All rights reserved.
//

import SpriteKit


class GameScene: SKScene, SKPhysicsContactDelegate {
  
  enum PhysicsCategory: UInt32 {
    case Arrow = 1
    case Brick = 2
    
    case None = 0
//    case All = UInt32.max.rawValue
 }
  
  var
    pouchContainer             = PouchContainer(),
    targetContainer: TargetContainer?,
    endpointContainer:  EndpointContainer?,
    currentEndpoint: Endpoint?,
    currentTargetNum = 0
  
  var targetsCompleted : Int = 0 {
    didSet {
      if targetsCompleted < 9 {
        setNewEndPoint()
      }
      else {
        endpointContainer?.removeFromParent()
        
        let doneLabel = getDoneLabel("YOU WIN!")
        
        let labelPosition = CGPointMake(position.x + 500, position.y + 400)
        
        doneLabel.position = labelPosition
        
        addChild(doneLabel)
      }
    }
  }
  
  typealias IntArray = [Int]
  

  func didBeginContact(contact: SKPhysicsContact) {
    
    let (firstBody, secondBody) = VJUtil.getBodyPair(contact)
    
    println("firstBody: \(firstBody)")
    println("secondBody: \(secondBody)")

    if (Arrow.hasBodyTypeOf(firstBody) && TargetBrick.hasBodyTypeOf(secondBody)) {

        let arrow = firstBody.node as! Arrow
        let brick = secondBody.node as! TargetBrick
        
        arrowCollideWithBrick(arrow, brick: brick)
        {(success : Bool, allDone: Bool) -> Void in
         self.pouchContainer.removePouchGroup(arrow.getGroup())
          
          self.targetContainer!.removeBrick(brick)
          
          if allDone {
            self.currentEndpoint!.setCompleted()
            
            ++self.targetsCompleted
          }
        }
    }
  }

  private func getDoneLabel(inText: String) -> SKLabelNode {
    
    let label          = SKLabelNode(text: inText)
    
    label.fontColor    = UIColor.blueColor()
    label.fontSize     = 48
    
    label.xScale       = 0.6
    label.yScale       = 0.6
    
    return label
  }

  func arrowCollideWithBrick(arrow:Arrow, brick:TargetBrick, completionHandler:(success : Bool, allDone : Bool) -> Void) {
    
    println("Hit by (brick, arrow.userData): (\(brick.children.first!), \(arrow.userData))")

    let brickLabel = brick.children.first as! SKLabelNode
    let brickNum = brickLabel.text
    
    println("brickNum: \(brickNum)")
    brick.remove()
    
    arrow.remove()

    if brickNum  == "1" {
      completionHandler(success: true, allDone: true)
    }
    else { completionHandler(success: true, allDone: false) }
  }
  
  func initPhysicsWorld() {
    physicsWorld.gravity = CGVectorMake(0, 0)
    physicsWorld.contactDelegate = self
  }
  
  func startGame() {

    self.removeAllChildren()

    initPhysicsWorld()
    
    endpointContainer = EndpointContainer(inLocation: CGPointMake(self.frame.midX - 180, self.frame.midY + 200))
    
    addChild(endpointContainer!)

    setNewEndPoint()
    
    self.addChild(pouchContainer)
  }

  func setNewEndPoint() {
    self.currentEndpoint  = self.endpointContainer!.getNextEndpoint()
    
    self.currentTargetNum = self.currentEndpoint!.targetNum
    
    self.targetContainer = TargetContainer(location: CGPointMake(self.frame.midX - 580, self.frame.midY + 000))
    let location = CGPointMake(self.frame.midX - 124, self.targetContainer!.position.y + 120)
    
    self.targetContainer!.createBrickList(self.currentTargetNum, inLocation: location)
    
    self.addChild(self.targetContainer!)
    
    // use a trailing closure in the call
    //
    PouchContainer.callArithmeticAPI(currentTargetNum) {
      (success:Bool, blockArray: [IntArray]) -> Void in
      
      if success {
        self.pouchContainer.addArrowPouches(blockArray)
      }
      else {
        println("---> callArithmeticAPI fails")
    NSNotificationCenter.defaultCenter().postNotificationName("showAlert", object: nil)
      }
    }
  }
  
  override func didMoveToView(view: SKView) {
    /* Setup your scene here */
    
    startGame()
  }

  func shootArrows(arrows arrowList: [Arrow]) {
    let targetBricks = targetContainer!.children

    var brickNum = targetBricks.count - 1

    var arrowNum = 0
    
    let xOffset = -90.0 as CGFloat
    let yOffset = 352 as CGFloat
    
    for a in arrowList {
      //let brickHalfway   = targetBricks[targetBrick].position.x + 12

      let position = targetBricks[brickNum].position
      
      let (x, y) = (position.x + 16 + xOffset, position.y + yOffset)

      a.moveToTarget(CGPointMake(x, y), arrowCount: ++arrowNum)
      
      --brickNum
      
      self.addChild(a)
    }
  }

//  override func touchesBegan(touches: NSSet, withEvent event: UIEvent)
  override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent)
  {

    for touch: AnyObject in touches {
      let location = touch.locationInNode(self)
      
      if let btn = pouchContainer.getTouchedPouch(location) {
        
        let arrowList = btn.createArrows(location)
        shootArrows(arrows: arrowList)
      }
    }
  }

  override func update(currentTime: CFTimeInterval) {
      /* Called before each frame is rendered */
  }

}
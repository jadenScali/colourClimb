//
//  GameScene.swift
//  Colour Shift
//
//  Created by Jaden Scali on 2022-07-17.
//

import SpriteKit
import GameplayKit

var targetCategory = UInt32(1)
var ballCategory = UInt32(2)
var targetLines: [targetLine] = []

class playScene: SKScene, SKPhysicsContactDelegate {
    
    //lower is faster
    var spinSpeed = 5.0
    var maxSpinSpeed = 1.5
    var sizeMultipler = 3
    var totalTargets = 0
    var layers = 1
    var points = 0
    var round = 0
    var set = 0
    var masterNode = SKNode()
    lazy var pointstxt: SKLabelNode = {
        var label = SKLabelNode(fontNamed: "HelveticaNeue-Thin")
        label.fontSize = 100
        label.zPosition = 1
        label.color = SKColor.white
        label.horizontalAlignmentMode = .center
        label.verticalAlignmentMode = .baseline
        label.text = "0"
        return label
    }()
    
    var currentShapeType = ShapeType.easy
    
    enum ShapeType {
        case side, easy, medium, hard
    }
    
    override func didMove(to view: SKView) {
        
        //view.showsPhysics = true
        physicsWorld.contactDelegate = self
        
        addChild(masterNode)
        
        let boarder = SKSpriteNode()
        boarder.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        let b = SKPhysicsBody(edgeLoopFrom: CGRect(origin: CGPoint(x: -((self.frame.size.width * 1.5) / 2), y: -((self.frame.size.height * 1.5) / 2)), size: CGSize(width: self.frame.size.width * 1.5, height: self.frame.size.height * 1.5)))
        b.friction = 0
        b.restitution = 1
        b.node?.physicsBody?.isDynamic = false
        b.linearDamping = 0
        b.angularDamping = 0
        b.affectedByGravity = false
        b.mass = 10000
        boarder.physicsBody = b
        boarder.name = "boarder"
        boarder.physicsBody?.contactTestBitMask = boarder.physicsBody?.collisionBitMask ?? 0
        boarder.position = CGPoint(x: 0, y: 0)
        masterNode.addChild(boarder)
        pointstxt.position = CGPoint(x: 0, y: -400)
        masterNode.addChild(pointstxt)
        beginRound()
    }
    
    func beginRound() {
        
        let trianglePoints = [
            CGPoint(x: 0 * sizeMultipler, y: 50 * sizeMultipler),
            CGPoint(x: 43 * sizeMultipler, y: -25 * sizeMultipler),
            CGPoint(x: -43 * sizeMultipler, y: -25 * sizeMultipler)
        ]
        let squarePoints = [
            CGPoint(x: 50 * sizeMultipler, y: 50 * sizeMultipler),
            CGPoint(x: 50 * sizeMultipler, y: -50 * sizeMultipler),
            CGPoint(x: -50 * sizeMultipler, y: -50 * sizeMultipler),
            CGPoint(x: -50 * sizeMultipler, y: 50 * sizeMultipler)
        ]
        let trapizoidPoints = [
            CGPoint(x: 40 * sizeMultipler, y: 50 * sizeMultipler),
            CGPoint(x: 65 * sizeMultipler, y: -30 * sizeMultipler),
            CGPoint(x: -65 * sizeMultipler, y: -30 * sizeMultipler),
            CGPoint(x: -40 * sizeMultipler, y: 50 * sizeMultipler)
        ]
        let pentagonPoints = [
            CGPoint(x: 0 * sizeMultipler, y: 50 * sizeMultipler),
            CGPoint(x: 48 * sizeMultipler, y: 15 * sizeMultipler),
            CGPoint(x: 29 * sizeMultipler, y: -40 * sizeMultipler),
            CGPoint(x: -29 * sizeMultipler, y: -40 * sizeMultipler),
            CGPoint(x: -48 * sizeMultipler, y: 15 * sizeMultipler)
        ]
        let hexagonPoints = [
            CGPoint(x: 0 * sizeMultipler, y: 50 * sizeMultipler),
            CGPoint(x: 43 * sizeMultipler, y: 25 * sizeMultipler),
            CGPoint(x: 43 * sizeMultipler, y: -25 * sizeMultipler),
            CGPoint(x: 0 * sizeMultipler, y: -50 * sizeMultipler),
            CGPoint(x: -43 * sizeMultipler, y: -25 * sizeMultipler),
            CGPoint(x: -43 * sizeMultipler, y: 25 * sizeMultipler)
        ]
        let ireggularPentagonPoints = [
            CGPoint(x: 27 * sizeMultipler, y: 50 * sizeMultipler),
            CGPoint(x: 50 * sizeMultipler, y: 9 * sizeMultipler),
            CGPoint(x: 24 * sizeMultipler, y: -50 * sizeMultipler),
            CGPoint(x: -26 * sizeMultipler, y: -50 * sizeMultipler),
            CGPoint(x: -50 * sizeMultipler, y: -29 * sizeMultipler)
        ]
        let starPoints = [
            CGPoint(x: 0 * sizeMultipler, y: 50 * sizeMultipler),
            CGPoint(x: 11 * sizeMultipler, y: 15 * sizeMultipler),
            CGPoint(x: 48 * sizeMultipler, y: 15 * sizeMultipler),
            CGPoint(x: 18 * sizeMultipler, y: -6 * sizeMultipler),
            CGPoint(x: 29 * sizeMultipler, y: -40 * sizeMultipler),
            CGPoint(x: 0 * sizeMultipler, y: -19 * sizeMultipler),
            CGPoint(x: -29 * sizeMultipler, y: -40 * sizeMultipler),
            CGPoint(x: -18 * sizeMultipler, y: -6 * sizeMultipler),
            CGPoint(x: -48 * sizeMultipler, y: 15 * sizeMultipler),
            CGPoint(x: -11 * sizeMultipler, y: 15 * sizeMultipler)
        ]
        let easyShapes = [trianglePoints, squarePoints, trapizoidPoints]
        let mediumShapes = [pentagonPoints, hexagonPoints, ireggularPentagonPoints]
        let hardShapes = [starPoints]
        
        if round % 5 == 0 {
            set = 1
        } else {
            set += 1
        }
        
        print(set)
        
        round += 1
        targetLines = []
        
        roundPopUp()
        
        if set == 1 {
            currentShapeType = .easy
            spawnShape(type: easyShapes)
        } else if set == 5 {
            if round >= 10 {
                let ranNum = Int.random(in: 1...2)
                if ranNum == 1 {
                    currentShapeType = .hard
                    spawnShape(type: hardShapes)
                } else {
                    currentShapeType = .medium
                    spawnShape(type: mediumShapes)
                }
            } else {
                currentShapeType = .medium
                spawnShape(type: mediumShapes)
            }
        } else {
            var mediumShapesCount = 0
            
            if round <= 5 {
                mediumShapesCount = 0
            } else if round <= 10 {
                mediumShapesCount = 1
            } else if round <= 15 {
                mediumShapesCount = 2
            } else {
                mediumShapesCount = 3
            }
            
            if 5 - set <= mediumShapesCount {
                currentShapeType = .medium
                spawnShape(type: mediumShapes)
            } else {
                currentShapeType = .easy
                spawnShape(type: easyShapes)
            }
        }
        
        //you want this to happen after shape spawns
        layers = Int(round / 5) + 1
    }
    
    func spawnShape(type shapes: [[CGPoint]]) {
        
        let ranNum = Int.random(in: 0...shapes.count - 1)
        let sides = shapes[ranNum]
        
        totalTargets = sides.count
        
        if spinSpeed < maxSpinSpeed {
            spinSpeed = maxSpinSpeed
        }
        
        let shape = SKSpriteNode()
        
        for i in Range(0...sides.count - 1) {
            if i < sides.count - 1 {
                let t = targetLine(numOfLayers: layers, startPoint: sides[i], endPoint: sides[i+1])
                shape.addChild(t)
            } else {
                let t = targetLine(numOfLayers: layers, startPoint: sides[i], endPoint: sides[0])
                shape.addChild(t)
            }
        }
        
        shape.position = CGPoint(x: 0, y: 300)
        shape.isHidden = true
        masterNode.addChild(shape)
        
        if round > 1 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                shape.isHidden = false
            }
            
            shape.run(.sequence([
                SKAction.scale(by: 0.05, duration: 0),
                SKAction.wait(forDuration: 1),
                SKAction.scale(by: 20, duration: 1)
            ]))
        } else {
            shape.isHidden = false
            shape.run(.sequence([
                SKAction.scale(by: 0.05, duration: 0),
                SKAction.scale(by: 20, duration: 1)
            ]))
        }
        
        shape.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat.pi * 2.0, duration: TimeInterval(spinSpeed))))
    }
    
    func spawnBall() {
        
        let texture = SKTexture(imageNamed: "ball")
        let ball = SKSpriteNode(texture: texture)
        ball.name = "ball"
        ball.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        ball.physicsBody = SKPhysicsBody(texture: texture, size: texture.size())
        ball.physicsBody?.isDynamic = true
        ball.physicsBody?.allowsRotation = false
        ball.physicsBody?.friction = 0
        ball.physicsBody?.restitution = 1
        ball.physicsBody?.linearDamping = 0
        ball.physicsBody?.angularDamping = 0
        ball.physicsBody?.affectedByGravity = false
        ball.physicsBody!.categoryBitMask = ballCategory
        ball.physicsBody!.contactTestBitMask = targetCategory
        ball.physicsBody!.collisionBitMask = targetCategory
        ball.position = CGPoint(x: 0, y: -700)
        ball.zPosition = 2
        masterNode.addChild(ball)
        
        ball.physicsBody!.velocity.dy = 1000
    }
    
    func endGame() {
        
        self.isPaused = true
        
        let scene = playScene(fileNamed: "GameScene")
        scene?.scaleMode = .aspectFill
        self.view?.presentScene(scene!, transition: SKTransition.fade(withDuration: 1))
    }
    
    func increasePoints(typeHit: ShapeType, popUpPos: CGPoint?) {
        
        switch typeHit {
            
        case .side:
            points += 1
            popUpPoints(points: 1, fontSize: 35, position: popUpPos!)
            break
        case .easy:
            points += 10
            popUpPoints(points: 10, fontSize: 65, position: CGPoint(x: 0, y: 300))
            break
        case .medium:
            points += 20
            popUpPoints(points: 20, fontSize: 65, position: CGPoint(x: 0, y: 300))
            break
        case .hard:
            points += 50
            popUpPoints(points: 50, fontSize: 65, position: CGPoint(x: 0, y: 300))
            break
        }
        pointstxt.text = "\(points)"
    }
    
    func popUpPoints(points: Int, fontSize: CGFloat, position: CGPoint) {
        
        lazy var popUpText: SKLabelNode = {
            let popUpText = SKLabelNode(fontNamed: "HelveticaNeue-Light")
            popUpText.fontSize = fontSize
            popUpText.zPosition = 1
            popUpText.fontColor = SKColor.white
            popUpText.horizontalAlignmentMode = .center
            popUpText.verticalAlignmentMode = .baseline
            popUpText.text = "+\(points)"
            popUpText.position = position
            return popUpText
        }()
        
        self.addChild(popUpText)
        
        let totalDuration = 0.5
        let waitTime = 0.35
        
        popUpText.run(SKAction.move(by: CGVector(dx: 0, dy: 100), duration: totalDuration))
        popUpText.run(.sequence([
            SKAction.wait(forDuration: waitTime),
            SKAction.fadeOut(withDuration: totalDuration - waitTime),
            SKAction.removeFromParent()
        ]))
    }
    
    func newRound() {
        
        var maxLayers = 0
        
        for t in targetLines {
            t.animatedMove()
            maxLayers = t.colors.count
        }
        
        if layers > maxLayers - 1 {
            layers = maxLayers
        }
        spinSpeed -= 0.15
        
        increasePoints(typeHit: currentShapeType, popUpPos: nil)
        
        beginRound()
    }
    
    func roundPopUp() {
        
        lazy var popUpText: SKLabelNode = {
            let popUpText = SKLabelNode(fontNamed: "HelveticaNeue-Thin")
            popUpText.fontSize = 100
            popUpText.zPosition = 1
            popUpText.fontColor = SKColor.white
            popUpText.horizontalAlignmentMode = .center
            popUpText.verticalAlignmentMode = .baseline
            popUpText.text = "Round \(round)"
            popUpText.position = CGPoint(x: 0, y: -1000)
            return popUpText
        }()
        
        addChild(popUpText)
        
        popUpText.run(.sequence([
            SKAction.move(to: CGPoint(x: 0, y: 0), duration: 0.25),
            SKAction.wait(forDuration: 0.5),
            SKAction.move(to: CGPoint(x: 0, y: 1000), duration: 0.25),
            SKAction.removeFromParent()
        ]))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        spawnBall()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        print("COLISION")
        
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        //print("node a \(nodeA)")
        //print("node b \(nodeB)")
        
        if contact.bodyB.node?.name == "ball" {
            ballCollision(between: nodeB, object: nodeA)
        }
    }
    
    func ballCollision(between ball: SKNode, object: SKNode) {
        
        var gotAllTargets = true
        
        if object.name == "target" {
            let target = object.parent as! targetLine
            
            if target.isRed {
                print("GAME OVER")
                endGame()
            } else if !target.isRed {
                increasePoints(typeHit: .side, popUpPos: ball.position)
                let shake = SKAction.shake(initialPosition: masterNode.position, duration: 0.1, amplitudeX: 0, amplitudeY: 100)
                masterNode.run(shake)
                target.changeColor()
                //checks if all targets in targets areRed
                for t in targetLines {
                    if !t.isRed {
                        gotAllTargets = false
                    }
                }
                if gotAllTargets {
                    newRound()
                }
            }
        } else if object.name == "boarder" {
            ball.removeFromParent()
        }
    }
}

extension SKAction {
    class func shake(initialPosition:CGPoint, duration:Float, amplitudeX:Int = 12, amplitudeY:Int = 3) -> SKAction {
        let startingX = initialPosition.x
        let startingY = initialPosition.y
        let numberOfShakes = duration / 0.015
        var actionsArray:[SKAction] = []
        for _ in 1...Int(numberOfShakes) {
            let newXPos = startingX + CGFloat(arc4random_uniform(UInt32(amplitudeX))) - CGFloat(amplitudeX / 2)
            let newYPos = startingY + CGFloat(arc4random_uniform(UInt32(amplitudeY))) - CGFloat(amplitudeY / 2)
            actionsArray.append(SKAction.move(to: CGPoint(x: newXPos, y: newYPos), duration: 0.015))
        }
        actionsArray.append(SKAction.move(to: initialPosition, duration: 0.015))
        return SKAction.sequence(actionsArray)
    }
}

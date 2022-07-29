//
//  tutorialScene.swift
//  Colour Shift
//
//  Created by Jaden Scali on 2022-07-23.
//

import SpriteKit

class tutorialScene: SKScene, SKPhysicsContactDelegate {
    
    var masterNode = SKNode()
    
    lazy var tutorialInstructiontxt: SKLabelNode = {
        var label = SKLabelNode(fontNamed: "HelveticaNeue-Thin")
        label.fontSize = 75
        label.zPosition = 1
        label.color = SKColor.white
        label.horizontalAlignmentMode = .left
        label.verticalAlignmentMode = .baseline
        label.numberOfLines = 0
        label.text = ""
        return label
    }()
    
    var tapHere = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        
        //checks nightmode and sets background colour
        var nightMode = false
        
        if UserDefaults.standard.object(forKey: "nightMode") != nil {
            nightMode = UserDefaults.standard.object(forKey: "nightMode") as! Bool
        }
        if nightMode {
            self.backgroundColor = UIColor.black
        } else {
            self.backgroundColor = #colorLiteral(red: 0.9843137264, green: 0.9137254953, blue: 0.4980392158, alpha: 1)
        }
        
        addChild(masterNode)
        
        //generates invisible boarder slightly bigger than the screen
        //used mainly for despawning objects that go off screen
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
        
        //adds blank intruction text at the bottom of screen
        masterNode.addChild(tutorialInstructiontxt)
        tutorialInstructiontxt.position = CGPoint(x: -280, y: -600)
        
        addTutorialBouncyText()
        determinePart()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //spawns ball
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
    
    func determinePart() {
        
        if currentTutorialPart == 1 {
            tutorialPart1()
        } else if currentTutorialPart == 2 {
            tutorialPart2()
        }
    }
    
    func tutorialPart1() {
        
        targetLines = []
        
        tapHereAni()
        
        tutorialInstructiontxt.text = "Tap anywhere to\nspawn a ball"
        
        let sizeMultipler = 3
        
        let trianglePoints = [
            CGPoint(x: 0 * sizeMultipler, y: 50 * sizeMultipler),
            CGPoint(x: 43 * sizeMultipler, y: -25 * sizeMultipler),
            CGPoint(x: -43 * sizeMultipler, y: -25 * sizeMultipler)
        ]
        spawnShape(numLayers: 1, shapePoints: trianglePoints, spinSpeed: 5)
    }
    
    func tutorialPart2() {
        
        targetLines = []
        
        tutorialInstructiontxt.text = "Some shapes will\nspin faster and\nhave more than\none layer"
        
        let sizeMultipler = 2.5
        
        let squarePoints = [
            CGPoint(x: 50 * sizeMultipler, y: 50 * sizeMultipler),
            CGPoint(x: 50 * sizeMultipler, y: -50 * sizeMultipler),
            CGPoint(x: -50 * sizeMultipler, y: -50 * sizeMultipler),
            CGPoint(x: -50 * sizeMultipler, y: 50 * sizeMultipler)
        ]
        spawnShape(numLayers: 2, shapePoints: squarePoints, spinSpeed: 4)
    }
    
    func endTutorial() {
        
        UserDefaults.standard.set(false, forKey: "wantsTutorial")
        
        masterNode.run(SKAction.move(by: CGVector(dx: 0, dy: 1500), duration: 1))
        
        //tutorial completed animation
        lazy var popUpText: SKLabelNode = {
            let popUpText = SKLabelNode(fontNamed: "HelveticaNeue-Light")
            popUpText.fontSize = 100
            popUpText.zPosition = 1
            popUpText.fontColor = SKColor.white
            popUpText.horizontalAlignmentMode = .center
            popUpText.verticalAlignmentMode = .baseline
            popUpText.numberOfLines = 0
            popUpText.text = "Tutorial\nCompleted"
            popUpText.position = CGPoint(x: 0, y: -1000)
            return popUpText
        }()
        addChild(popUpText)
        popUpText.run(.sequence([
            SKAction.wait(forDuration: 1),
            SKAction.move(to: CGPoint(x: 0, y: -100), duration: 0.5),
            SKAction.wait(forDuration: 1),
            SKAction.move(to: CGPoint(x: 0, y: 1000), duration: 0.5),
            SKAction.removeFromParent()
        ]))
        
        //loads accual game
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            let scene = playScene(fileNamed: "GameScene")
            scene?.scaleMode = .aspectFill
            self.view?.presentScene(scene!)
        }
    }
    
    func addTutorialBouncyText() {
        
        lazy var tutorialText: SKLabelNode = {
            let tutorialText = SKLabelNode(fontNamed: "HelveticaNeue-Light")
            tutorialText.fontSize = 100
            tutorialText.zPosition = 1
            tutorialText.fontColor = SKColor.white
            tutorialText.horizontalAlignmentMode = .center
            tutorialText.verticalAlignmentMode = .baseline
            tutorialText.text = "Tutorial"
            tutorialText.position = CGPoint(x: 0, y: 450)
            return tutorialText
        }()
        
        masterNode.addChild(tutorialText)
        
        tutorialText.run(SKAction.repeatForever(SKAction.sequence([
            SKAction.move(by: CGVector(dx: 0, dy: 50), duration: 1),
            SKAction.wait(forDuration: 0.15),
            SKAction.move(by: CGVector(dx: 0, dy: -50), duration: 1),
            SKAction.wait(forDuration: 0.15)
        ])))
    }
    
    func tapHereAni() {
        
        tapHere = SKSpriteNode(imageNamed: "tapHere")
        tapHere.position = CGPoint(x: 130, y: -15)
        tapHere.alpha = 0
        addChild(tapHere)
        
        tapHere.run(SKAction.repeatForever(.sequence([
            SKAction.fadeAlpha(to: 1, duration: 1),
            SKAction.wait(forDuration: 0.1),
            SKAction.fadeAlpha(to: 0, duration: 1),
            SKAction.wait(forDuration: 0.1)
        ])))
        
        tapHere.run(SKAction.repeatForever(.sequence([
            SKAction.scale(by: 0.8, duration: 1),
            SKAction.wait(forDuration: 0.1),
            SKAction.scale(by: 1.25, duration: 1),
            SKAction.wait(forDuration: 0.1)
        ])))
    }
    
    func spawnShape(numLayers: Int, shapePoints sides: [CGPoint], spinSpeed: Double) {
         
         let shape = SKSpriteNode()
         
        //spawns a line between every point in the array of CGPoints as a child of shape
         for i in Range(0...sides.count - 1) {
             if i < sides.count - 1 {
                 let t = targetLine(numOfLayers: numLayers, startPoint: sides[i], endPoint: sides[i+1])
                 shape.addChild(t)
             } else {
                 let t = targetLine(numOfLayers: numLayers, startPoint: sides[i], endPoint: sides[0])
                 shape.addChild(t)
             }
         }
         shape.position = CGPoint(x: 0, y: 260)
         shape.isHidden = true
         masterNode.addChild(shape)
         
        //shape spawning animation
         if currentTutorialPart > 1 {
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
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        //if anythings hits a ball calls ballCollision
        if contact.bodyB.node?.name == "ball" {
            ballCollision(between: nodeB, object: nodeA)
        }
    }
    
    func ballCollision(between ball: SKNode, object: SKNode) {

        var gotAllTargets = true
        
        if currentTutorialPart == 1 {
            tutorialInstructiontxt.text = "If a ball hits a red\nline you loose, try\nto make all the\nsides red"
            tapHere.removeFromParent()
        }
        
        if object.name == "target" {
            let target = object.parent as! targetLine
            
            if target.isRed {
                
                let haptic = UIImpactFeedbackGenerator(style: .heavy)
                haptic.impactOccurred()
                
                //restarts tutorial
                let scene = playScene(fileNamed: "TutorialScene")
                scene?.scaleMode = .aspectFill
                self.view?.presentScene(scene!, transition: SKTransition.fade(withDuration: 1))
            } else if !target.isRed {
                
                let haptic = UIImpactFeedbackGenerator(style: .soft)
                haptic.impactOccurred()
                
                //screen shake
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
                    
                    for t in targetLines {
                        t.animatedMove()
                    }
                    
                    if currentTutorialPart == 1 {
                        currentTutorialPart += 1
                        determinePart()
                    } else if currentTutorialPart == 2 {
                        endTutorial()
                    }
                }
            }
        } else if object.name == "boarder" {
            //despawns ball if it goes too far off screen
            ball.removeFromParent()
        }
    }
}

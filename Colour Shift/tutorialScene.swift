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
        var label = SKLabelNode(fontNamed: "Messe Duesseldorf")
        label.fontSize = 63
        label.zPosition = 1
        label.fontColor = #colorLiteral(red: 0.9137254902, green: 0.8470588235, blue: 0.6509803922, alpha: 1)
        label.horizontalAlignmentMode = .left
        label.verticalAlignmentMode = .baseline
        label.numberOfLines = 0
        label.text = ""
        return label
    }()
    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        
        self.backgroundColor = #colorLiteral(red: 0.9330000281, green: 0.6079999804, blue: 0, alpha: 1)
        
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
        let texture = SKTexture(imageNamed: "colourClimbBall")
        texture.filteringMode = .nearest
        let hitBoxTexture = SKTexture(imageNamed: "circle")
        let ball = SKSpriteNode(texture: texture)
        ball.size = CGSize(width: 40, height: 40)
        ball.name = "ball"
        ball.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        ball.physicsBody = SKPhysicsBody(texture: hitBoxTexture, size: hitBoxTexture.size())
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
        
        tutorialInstructiontxt.text = "Tap anywhere to\nspawn a ball"
        
        let sizeMultipler = 3.0
        
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
        
        let sizeMultipler = 3.0
        
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
            let label = SKLabelNode(fontNamed: "Messe Duesseldorf")
            label.fontSize = 100
            label.zPosition = 1
            label.fontColor = #colorLiteral(red: 0.9137254902, green: 0.8470588235, blue: 0.6509803922, alpha: 1)
            label.horizontalAlignmentMode = .center
            label.verticalAlignmentMode = .baseline
            label.numberOfLines = 0
            label.text = "Tutorial\nCompleted"
            label.position = CGPoint(x: 0, y: -1000)
            return label
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
            let tutorialText = SKLabelNode(fontNamed: "Messe Duesseldorf")
            tutorialText.fontSize = 100
            tutorialText.zPosition = 1
            tutorialText.fontColor = #colorLiteral(red: 0.9137254902, green: 0.8470588235, blue: 0.6509803922, alpha: 1)
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
    
    func spawnShape(numLayers: Int, shapePoints sides: [CGPoint], spinSpeed: Double) {
         
        let shape = SKSpriteNode()
         
        //spawns a line between every point in the array of CGPoints as a child of shape
        for i in Range(0...sides.count - 1) {
            if i < sides.count - 1 {
                let t = targetLine(numOfLayers: numLayers, startPoint: sides[i], endPoint: sides[i+1], shapeHolder: shape)
                shape.addChild(t)
             } else {
                 let t = targetLine(numOfLayers: numLayers, startPoint: sides[i], endPoint: sides[0], shapeHolder: shape)
                 shape.addChild(t)
             }
        }
        shape.position = CGPoint(x: 0, y: 200)
        shape.isHidden = true
        masterNode.addChild(shape)
         
        //shape spawning animation
        shape.isHidden = false
        shape.run(.sequence([
            SKAction.scale(by: 0.02, duration: 0),
            SKAction.scale(by: 50, duration: 1)
        ]))
        
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

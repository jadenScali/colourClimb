//
//  GameScene.swift
//  Colour Climb
//
//  Created by Jaden Scali on 2022-07-17.
//

import SpriteKit
import GameplayKit

var targetCategory = UInt32(1)
var ballCategory = UInt32(2)
var targetLines: [targetLine] = []

class playScene: SKScene, SKPhysicsContactDelegate {
    
    var bgWidth: CGFloat = -1
    var fgNames = ["forestFg", "highTreesFg", "highTreesFg", "highTreesFg", "treeTopsFg",
                   "mBlueSkyFg", "mBlueSkyFg", "mBlueSkyFg", "mBlueSkyFg", "mBlueSkyTransFg",
                   "mYellowSkyFg", "mYellowSkyFg", "mYellowSkyFg", "mYellowSkyFg", "mYellowSkyTransFg",
                   "mOrangeSkyFg", "mOrangeSkyFg", "mOrangeSkyFg", "mOrangeSkyFg", "mOrangeSkyTransFg",
                   "mSpaceFg", "vMoonFg"]
    var bgNames = ["forestBg", "forestBg", "forestBg", "forestBg", "forestBg",
                   "blueSkyBg", "blueSkyBg", "blueSkyBg", "blueSkyBg", "blueSkyTransBg",
                   "yellowSkyBg", "yellowSkyBg", "yellowSkyBg", "yellowSkyBg", "yellowSkyTransBg",
                   "orangeSkyBg", "orangeSkyBg", "orangeSkyBg", "orangeSkyBg", "orangeSkyTransBg",
                   "spaceBg", "vMoonBg"]
    var groundGroups: [SKNode] = []
    
    //lower spinSpeed means it'll spin faster
    var spinSpeed = 5.0
    var maxSpinSpeed = 2.75
    var sizeMultipler = 3.0
    var totalTargets = 0
    var layers = 1
    var round = 0
    var set = 0
    var popupTextColor = #colorLiteral(red: 0.9137254902, green: 0.8470588235, blue: 0.6509803922, alpha: 1)
    var masterNode = SKNode()
    
    //for stats
    var hiRound = 0
    var gamesPlayed = 0
    var shapesDestroyed = 0
    var linesDestroyed = 0
    var ballsFired = 0
    
    var currentShapeType = ShapeType.easy
    
    var moon: theMoon?
    var moonShapes: [[CGPoint]]?
    
    enum ShapeType {
        case side, easy, medium, hard
    }
    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        isTransitioning = false
        highShape = true
        
        loadStats()
        
        createGrounds(fgName: fgNames[0], bgName: bgNames[0], gSpawn: CGPoint(x: 0, y: 0))
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
        
        beginRound()
    }
    
    override func update(_ currentTime: TimeInterval) {
        moveBg()
    }
    
    func createGrounds(fgName: String, bgName: String, gSpawn: CGPoint) {
        
        let grounds = SKNode()
        grounds.name = "grounds"
        addChild(grounds)
        
        groundGroups += [grounds]
        
        if fgName.first == "m" {
            for i in 0...1 {
                
                let texture = SKTexture(imageNamed: fgName)
                texture.filteringMode = .nearest
                
                let mfg = SKSpriteNode(texture: texture)
                mfg.name = "mfg"
                mfg.size = CGSize(width: self.scene!.size.width, height: self.scene!.size.height)
                mfg.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                mfg.position = CGPoint(x: CGFloat(i) * self.scene!.size.width, y: gSpawn.y)
                mfg.zPosition = -1
                
                grounds.addChild(mfg)
            }
        } else if fgName.first == "v" {
            for i in 0...1 {
                let texture = SKTexture(imageNamed: fgName)
                texture.filteringMode = .nearest
                
                let vfg = SKSpriteNode(texture: texture)
                vfg.name = "vfg"
                vfg.size = CGSize(width: self.scene!.size.width, height: self.scene!.size.height)
                vfg.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                vfg.position = CGPoint(x: gSpawn.x, y: (CGFloat(i) * self.scene!.size.height) + gSpawn.y)
                vfg.zPosition = -1
                
                grounds.addChild(vfg)
            }
        } else {
            let texture = SKTexture(imageNamed: fgName)
            texture.filteringMode = .nearest
            
            let fg = SKSpriteNode(texture: texture)
            fg.size = CGSize(width: self.scene!.size.width, height: self.scene!.size.height)
            fg.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            fg.position = gSpawn
            fg.zPosition = -1
            
            grounds.addChild(fg)
        }
        
        if bgName.first == "v" {
            for i in 0...1 {
                let texture = SKTexture(imageNamed: bgName)
                texture.filteringMode = .nearest
                
                let bg = SKSpriteNode(texture: texture)
                bg.name = "vbg"
                bg.size.height = (self.scene?.size.height)!
                bg.size.width = (self.scene?.size.height)! * 1.686656671664168
                bg.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                bg.position = CGPoint(x: gSpawn.x, y: (CGFloat(i) * self.scene!.size.height) + gSpawn.y)
                bg.zPosition = -2
                
                bgWidth = bg.size.width
                
                grounds.addChild(bg)
            }
        } else {
            for i in 0...1 {
                let texture = SKTexture(imageNamed: bgName)
                texture.filteringMode = .nearest
                
                let bg = SKSpriteNode(texture: texture)
                bg.name = "bg"
                bg.size.height = (self.scene?.size.height)!
                bg.size.width = (self.scene?.size.height)! * 1.686656671664168
                bg.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                bg.position = CGPoint(x: CGFloat(i) * bg.size.width, y: gSpawn.y)
                bg.zPosition = -2
                
                bgWidth = bg.size.width
                
                grounds.addChild(bg)
            }
        }
    }
    
    func moveBg() {
        
        for grounds in groundGroups {
            grounds.enumerateChildNodes(withName: "bg", using: ({
                (node, error) in
                node.position.x -= 2
                
                if node.position.x < -self.bgWidth + (self.scene?.size.width)! {
                    node.position.x += self.bgWidth * 2
                }
            }))
            
            grounds.enumerateChildNodes(withName: "vbg", using: ({
                (node, error) in
                node.position.y -= 8
                
                if node.position.y < 0 {
                    node.position.y += (self.scene?.size.height)! * 2
                }
            }))
            
            grounds.enumerateChildNodes(withName: "mfg", using: ({
                (node, error) in
                node.position.x -= 1
                
                if node.position.x < -(self.scene?.size.width)! {
                    node.position.x += (self.scene?.size.width)! * 2
                }
            }))
            
            grounds.enumerateChildNodes(withName: "vfg", using: ({
                (node, error) in
                node.position.y -= 16
                
                if node.position.y < 0 {
                    node.position.y += (self.scene?.size.height)! * 2
                }
            }))
        }
    }
    
    func tansitionGrounds() {
        
        createGrounds(fgName: fgNames[round], bgName: bgNames[round], gSpawn: CGPoint(x: 0, y: (self.scene?.size.height)!))
        
        for grounds in groundGroups {
            
            if groundGroups.first == grounds {
                grounds.run(SKAction.sequence([
                    SKAction.move(by: CGVector(dx: 0, dy: -(self.scene?.size.height)!), duration: 0.5),
                    SKAction.removeFromParent()
                ]))
            } else {
                grounds.run(SKAction.move(by: CGVector(dx: 0, dy: -(self.scene?.size.height)!), duration: 0.5))
            }
        }
        groundGroups.remove(at: 0)
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
        let bannerPoints = [
            CGPoint(x: 27 * sizeMultipler, y: 50 * sizeMultipler),
            CGPoint(x: -27 * sizeMultipler, y: 50 * sizeMultipler),
            CGPoint(x: -27 * sizeMultipler, y: -50 * sizeMultipler),
            CGPoint(x: 0 * sizeMultipler, y: -25 * sizeMultipler),
            CGPoint(x: 27 * sizeMultipler, y: -50 * sizeMultipler)
        ]
        let irregularHeptagonPoints = [
            CGPoint(x: 37 * sizeMultipler, y: 50 * sizeMultipler),
            CGPoint(x: -29 * sizeMultipler, y: 50 * sizeMultipler),
            CGPoint(x: -37 * sizeMultipler, y: 14 * sizeMultipler),
            CGPoint(x: -50 * sizeMultipler, y: -7 * sizeMultipler),
            CGPoint(x: -35 * sizeMultipler, y: -50 * sizeMultipler),
            CGPoint(x: 35 * sizeMultipler, y: -50 * sizeMultipler),
            CGPoint(x: 50 * sizeMultipler, y: -7 * sizeMultipler)
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
        let clawPoints = [
            CGPoint(x: 35 * sizeMultipler, y: 50 * sizeMultipler),
            CGPoint(x: -35 * sizeMultipler, y: 50 * sizeMultipler),
            CGPoint(x: -50 * sizeMultipler, y: -50 * sizeMultipler),
            CGPoint(x: -12 * sizeMultipler, y: -20 * sizeMultipler),
            CGPoint(x: 12 * sizeMultipler, y: -20 * sizeMultipler),
            CGPoint(x: 50 * sizeMultipler, y: -50 * sizeMultipler)
        ]
        let easyShapes = [trianglePoints, squarePoints, trapizoidPoints]
        var mediumShapes = [pentagonPoints, hexagonPoints, ireggularPentagonPoints]
        var hardShapes = [starPoints, clawPoints]
        
        if round > 10 {
            mediumShapes += [bannerPoints]
            mediumShapes += [irregularHeptagonPoints]
        }
        
        if round % 5 == 0 {
            set = 1
        } else {
            set += 1
        }
        
        round += 1
        targetLines = []
        
        if round > 5 && round <= 10 {
            popupTextColor = #colorLiteral(red: 0.7921568627, green: 0.4039215686, blue: 0.007843137255, alpha: 1)
        } else if round > 10 && round < 15 {
            popupTextColor = #colorLiteral(red: 0, green: 0.07100000232, blue: 0.09799999744, alpha: 1)
        } else if round > 15 {
            hardShapes.removeFirst()
            popupTextColor = #colorLiteral(red: 0.9137254902, green: 0.8470588235, blue: 0.6509803922, alpha: 1)
        } else {
            popupTextColor = #colorLiteral(red: 0.9137254902, green: 0.8470588235, blue: 0.6509803922, alpha: 1)
        }
        
        roundPopUp(txt: "Round \(round)")
        
        //a set resets every 5 levels and it's value otehrwise increases by one each round
        //helps space out harder shapes and make them more common as game progresses
        if set == 1 {
            currentShapeType = .easy
            spawnShape(type: ranPickShape(easyShapes), pos: CGPoint(x: 0, y: 300))
        } else if set == 5 {
            if round >= 10 {
                let ranNum = Int.random(in: 1...2)
                if ranNum == 1 {
                    currentShapeType = .hard
                    spawnShape(type: ranPickShape(hardShapes), pos: CGPoint(x: 0, y: 300))
                } else {
                    currentShapeType = .medium
                    spawnShape(type: ranPickShape(mediumShapes), pos: CGPoint(x: 0, y: 300))
                }
            } else {
                currentShapeType = .medium
                spawnShape(type: ranPickShape(mediumShapes), pos: CGPoint(x: 0, y: 300))
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
                spawnShape(type: ranPickShape(mediumShapes), pos: CGPoint(x: 0, y: 300))
            } else {
                currentShapeType = .easy
                spawnShape(type: ranPickShape(easyShapes), pos: CGPoint(x: 0, y: 300))
            }
        }
        
        if round < 5 {
            layers = 1
        } else if round < 15 {
            layers = 2
        } else {
            layers = 3
        }
    }
    
    func ranPickShape(_ shapes: [[CGPoint]]) -> [CGPoint] {
        
        let ranNum = Int.random(in: 0...shapes.count - 1)
        return shapes[ranNum]
    }
    
    func spawnShape(type sides: [CGPoint], pos: CGPoint) {
        
        totalTargets = sides.count
        
        if spinSpeed < maxSpinSpeed {
            spinSpeed = maxSpinSpeed
        }
        
        let shape = SKSpriteNode()
        
        for i in Range(0...sides.count - 1) {
            if i < sides.count - 1 {
                let t = targetLine(numOfLayers: layers, startPoint: sides[i], endPoint: sides[i+1], shapeHolder: shape)
                shape.addChild(t)
            } else {
                let t = targetLine(numOfLayers: layers, startPoint: sides[i], endPoint: sides[0], shapeHolder: shape)
                shape.addChild(t)
            }
        }
        
        shape.position = pos
        shape.isHidden = true
        masterNode.addChild(shape)
        
        if round > 1 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                shape.isHidden = false
            }
            
            shape.run(.sequence([
                SKAction.scale(by: 0.02, duration: 0),
                SKAction.wait(forDuration: 1),
                SKAction.scale(by: 50, duration: 1)
            ]))
        } else {
            shape.isHidden = false
            shape.run(.sequence([
                SKAction.scale(by: 0.02, duration: 0),
                SKAction.scale(by: 50, duration: 1)
            ]))
        }
        
        shape.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat.pi * 2.0, duration: TimeInterval(spinSpeed))))
    }
    
    func spawnBall() {
        
        if !isTransitioning {
            ballsFired += 1
            
            var texture = SKTexture(imageNamed: "colourClimbBall")
            
            if round > 5 && round <= 10 {
                texture = SKTexture(imageNamed: "colourClimbBallDelightfulOrange")
            } else if round > 10 && round < 15 {
                texture = SKTexture(imageNamed: "colourClimbBallOffBlack")
            }
            
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
    }
    
    func endGame() {
        
        shouldFadeInMainView = true
        self.isPaused = true
        
        gamesPlayed += 1
        updateStats()
        
        var isMusicPlaying = true
        
        if UserDefaults.standard.object(forKey: "musicIsPlaying") != nil {
            isMusicPlaying = UserDefaults.standard.object(forKey: "musicIsPlaying") as! Bool
        }
        
        if isMusicPlaying && round == 22 {
            UserDefaults.standard.set(true, forKey: "musicIsPlaying")
            NotificationCenter.default.post(name: Notification.Name("playBgMusic"), object: nil)
            
            UserDefaults.standard.set(false, forKey: "moonMusicShouldPlay")
            NotificationCenter.default.post(name: Notification.Name("playStopMoonMusic"), object: nil)
        }
        
        //tells gameVC to transition to new scene
        NotificationCenter.default.post(name: Notification.Name("loadMainMenu"), object: nil)
    }
    
    func loadStats() {
        
        if UserDefaults.standard.object(forKey: "hiRound") != nil {
            hiRound = UserDefaults.standard.object(forKey: "hiRound") as! Int
        }
        if UserDefaults.standard.object(forKey: "gamesPlayed") != nil {
            gamesPlayed = UserDefaults.standard.object(forKey: "gamesPlayed") as! Int
        }
        if UserDefaults.standard.object(forKey: "shapesDestroyed") != nil {
            shapesDestroyed = UserDefaults.standard.object(forKey: "shapesDestroyed") as! Int
        }
        if UserDefaults.standard.object(forKey: "linesDestroyed") != nil {
            linesDestroyed = UserDefaults.standard.object(forKey: "linesDestroyed") as! Int
        }
        if UserDefaults.standard.object(forKey: "ballsFired") != nil {
            ballsFired = UserDefaults.standard.object(forKey: "ballsFired") as! Int
        }
    }
    
    func updateStats() {
        
        if round > hiRound {
            hiRound = round
            UserDefaults.standard.set(hiRound, forKey: "hiRound")
        }
        UserDefaults.standard.set(gamesPlayed, forKey: "gamesPlayed")
        UserDefaults.standard.set(shapesDestroyed, forKey: "shapesDestroyed")
        UserDefaults.standard.set(linesDestroyed, forKey: "linesDestroyed")
        UserDefaults.standard.set(ballsFired, forKey: "ballsFired")
    }
    
    func informStats(typeHit: ShapeType, popUpPos: CGPoint?) {
        
        switch typeHit {
            
        case .side:
            linesDestroyed += 1
            popUpText(txt: ".", fontSize: 35, position: popUpPos!)
            break
        case .easy:
            shapesDestroyed += 1
            popUpText(txt: "BOOM", fontSize: 65, position: CGPoint(x: 0, y: 300))
            break
        case .medium:
            shapesDestroyed += 1
            popUpText(txt: "BAM", fontSize: 65, position: CGPoint(x: 0, y: 300))
            break
        case .hard:
            shapesDestroyed += 1
            popUpText(txt: "KAPLOW", fontSize: 65, position: CGPoint(x: 0, y: 300))
            break
        }
    }
    
    func popUpText(txt: String, fontSize: CGFloat, position: CGPoint) {
        
        lazy var popUpText: SKLabelNode = {
            let popUpText = SKLabelNode(fontNamed: "Messe Duesseldorf")
            popUpText.fontSize = fontSize
            popUpText.zPosition = 4
            popUpText.horizontalAlignmentMode = .center
            popUpText.verticalAlignmentMode = .baseline
            popUpText.text = txt
            popUpText.position = position
            popUpText.fontColor = popupTextColor
            return popUpText
        }()
        
        addChild(popUpText)
        
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
        
        //shape breaking animation
        for t in targetLines {
            t.animatedMove()
        }
        
        tansitionGrounds()
        
        spinSpeed -= 0.1125
        
        informStats(typeHit: currentShapeType, popUpPos: nil)
        
        if round != 21 {
            beginRound()
        } else {
            moonBattle()
        }
    }
    
    func roundPopUp(txt: String) {
        
        lazy var popUpText: SKLabelNode = {
            let popUpText = SKLabelNode(fontNamed: "Messe Duesseldorf")
            popUpText.fontSize = 100
            popUpText.zPosition = 4
            popUpText.fontColor = popupTextColor
            popUpText.horizontalAlignmentMode = .center
            popUpText.verticalAlignmentMode = .baseline
            popUpText.text = txt
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
        
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if contact.bodyB.node?.name == "ball" {
            ballCollision(between: nodeB, object: nodeA)
        }
    }
    
    func ballCollision(between ball: SKNode, object: SKNode) {
        
        var gotAllTargets = true
        
        if object.name == "target" {
            let target = object.parent as! targetLine
            
            if target.isRed {
                let haptic = UIImpactFeedbackGenerator(style: .heavy)
                haptic.impactOccurred()
                
                endGame()
            } else if !target.isRed {
                let haptic = UIImpactFeedbackGenerator(style: .soft)
                haptic.impactOccurred()
                
                informStats(typeHit: .side, popUpPos: ball.position)
                
                //camera shake
                let shake = SKAction.shake(initialPosition: masterNode.position, duration: 0.1, amplitudeX: 0, amplitudeY: 100)
                masterNode.run(shake)
                target.changeColor()
                
                //checks if all targets in targets areRed
                for t in targetLines {
                    if !t.isRed {
                        gotAllTargets = false
                    }
                }
                
                if gotAllTargets && round != 22 {
                    newRound()
                } else if gotAllTargets {
                    informStats(typeHit: .hard, popUpPos: nil)
                    moon?.changePhase()
                }
            }
        } else if object.name == "boarder" {
            ball.removeFromParent()
        }
    }
    
    func moonBattle() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(moonBattleSpawnShape), name: Notification.Name("moonBattleSpawnShape"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(moonBattleOver), name: Notification.Name("moonBattleOver"), object: nil)
        
        spinSpeed = 3.5
        round += 1
        targetLines = []
        layers = 3
        popupTextColor = #colorLiteral(red: 0.6078431373, green: 0.1333333333, blue: 0.1490196078, alpha: 1)
        
        roundPopUp(txt: "The Moon")
        
        sizeMultipler = 4.5
        let octagonPoints = [
            CGPoint(x: -50 * sizeMultipler, y: 0 * sizeMultipler),
            CGPoint(x: -35.5 * sizeMultipler, y: 35.5 * sizeMultipler),
            CGPoint(x: 0 * sizeMultipler, y: 50 * sizeMultipler),
            CGPoint(x: 35.5 * sizeMultipler, y: 35.5 * sizeMultipler),
            CGPoint(x: 50 * sizeMultipler, y: 0 * sizeMultipler),
            CGPoint(x: 35.5 * sizeMultipler, y: -35.5 * sizeMultipler),
            CGPoint(x: 0 * sizeMultipler, y: -50 * sizeMultipler),
            CGPoint(x: -35.5 * sizeMultipler, y: -35.5 * sizeMultipler)
        ]
        sizeMultipler = 2.5
        let parallelogramPoints = [
            CGPoint(x: -50 * sizeMultipler, y: 50 * sizeMultipler),
            CGPoint(x: 25 * sizeMultipler, y: 50 * sizeMultipler),
            CGPoint(x: 50 * sizeMultipler, y: -50 * sizeMultipler),
            CGPoint(x: -25 * sizeMultipler, y: -50 * sizeMultipler)
        ]
        sizeMultipler = 3.5
        let imposibleBoxPoints = [
            CGPoint(x: -50 * sizeMultipler, y: 50 * sizeMultipler),
            CGPoint(x: 50 * sizeMultipler, y: 50 * sizeMultipler),
            CGPoint(x: 0 * sizeMultipler, y: 0 * sizeMultipler),
            CGPoint(x: 50 * sizeMultipler, y: -50 * sizeMultipler),
            CGPoint(x: 0 * sizeMultipler, y: 0 * sizeMultipler),
            CGPoint(x: -50 * sizeMultipler, y: -50 * sizeMultipler),
            CGPoint(x: 0 * sizeMultipler, y: 0 * sizeMultipler)
        ]
        
        moonShapes = [octagonPoints, parallelogramPoints, imposibleBoxPoints]
        
        moon = theMoon(sceneHeight: self.frame.size.height, scene: self)
        moon!.size = CGSize(width: self.scene!.size.width, height: self.scene!.size.height)
        addChild(moon!)
        
        self.run(SKAction.sequence([
            SKAction.wait(forDuration: 2.25)
        ]), completion: {
            self.currentShapeType = .hard
            self.spawnShape(type: self.moonShapes![self.moon!.phase - 1], pos: CGPoint(x: 0, y: 300))
        })
    }
    
    @objc func moonBattleSpawnShape() {
        
        if highShape {
            spinSpeed = 5.0
            spawnShape(type: moonShapes![self.moon!.phase - 1], pos: CGPoint(x: 0, y: 300))
        } else {
            spawnShape(type: moonShapes![self.moon!.phase - 1], pos: CGPoint(x: 0, y: -300))
        }
    }
    
    @objc func moonBattleOver() {
        
        endGame()
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

//
//  theMoon.swift
//  Colour Shift
//
//  Created by Jaden Scali on 2022-08-25.
//

import SpriteKit

var highShape = true
var isTransitioning = false

class theMoon: SKSpriteNode {
    
    private var hapticManager: HapticManager?
    var moonClosedTexture = SKTexture(imageNamed: "moonClosed")
    var moonOpenedTexture = SKTexture(imageNamed: "moonOpened")
    var moonHitTexture = SKTexture(imageNamed: "moonHit")
    var sceneH: CGFloat
    var peaceDuration = 5.0
    var phase = 0
    var currentScene: SKScene
    
    init(sceneHeight: CGFloat, scene: SKScene) {
        
        sceneH = sceneHeight
        currentScene = scene
        hapticManager = HapticManager()
        
        moonClosedTexture.filteringMode = .nearest
        moonOpenedTexture.filteringMode = .nearest
        
        super.init(texture: moonClosedTexture, color: UIColor.clear, size: moonClosedTexture.size())
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.position = CGPoint(x: 0, y: sceneH)
        self.zPosition = 1
        
        changePhase()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func spawnAni() {
        
        let moveDown = SKAction.move(by: CGVector(dx: 0, dy: -(sceneH) + 600), duration: 1.5)
        moveDown.timingMode = .easeOut
        
        let moveDownAgain = SKAction.move(by: CGVector(dx: 0, dy: -600), duration: 1)
        moveDownAgain.timingMode = .easeOut
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.25) {
            self.hapticManager?.playSoftRumble()
        }
        
        self.run(SKAction.sequence([
            SKAction.wait(forDuration: 1.5),
            moveDown,
            SKAction.wait(forDuration: 0.25),
            SKAction.sequence([
                SKAction.setTexture(moonOpenedTexture),
                SKAction.repeat(
                    SKAction.sequence([
                        SKAction.move(by: CGVector(dx: 0, dy: 5), duration: 0.05),
                        SKAction.move(by: CGVector(dx: 5, dy: -2.5), duration: 0.05),
                        SKAction.move(by: CGVector(dx: -2.5, dy: 0), duration: 0.05),
                        SKAction.move(by: CGVector(dx: 0, dy: -2.5), duration: 0.05),
                        SKAction.move(by: CGVector(dx: -2.5, dy: 0), duration: 0.05)
                    ]), count: 4),
                SKAction.setTexture(moonClosedTexture),
                SKAction.wait(forDuration: 0.5)
            ]),
            moveDownAgain,
            SKAction.wait(forDuration: 0.25)
        ]), completion: {
            isTransitioning = false
            self.openEye()
        })
    }
    
    func phase2Ani() {
        
        let moveUpLight = SKAction.move(by: CGVector(dx: 0, dy: 500), duration: 2)
        moveUpLight.timingMode = .easeOut
        
        let moveUp = SKAction.move(by: CGVector(dx: 0, dy: 600), duration: 1.5)
        moveUp.timingMode = .easeOut
        
        invertColor()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            self.revertColor()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            highShape = false
            NotificationCenter.default.post(name: Notification.Name("moonBattleSpawnShape"), object: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.hapticManager?.playSoftRumble()
            }
        }
        
        self.run(SKAction.sequence([
            SKAction.setTexture(moonOpenedTexture),
            SKAction.move(by: CGVector(dx: 0, dy: -500), duration: 0.5),
            SKAction.setTexture(moonClosedTexture),
            moveUpLight,
            SKAction.sequence([
                SKAction.setTexture(moonOpenedTexture),
                SKAction.repeat(
                    SKAction.sequence([
                        SKAction.move(by: CGVector(dx: 0, dy: 5), duration: 0.05),
                        SKAction.move(by: CGVector(dx: 5, dy: -2.5), duration: 0.05),
                        SKAction.move(by: CGVector(dx: -2.5, dy: 0), duration: 0.05),
                        SKAction.move(by: CGVector(dx: 0, dy: -2.5), duration: 0.05),
                        SKAction.move(by: CGVector(dx: -2.5, dy: 0), duration: 0.05)
                    ]), count: 4),
                SKAction.setTexture(moonClosedTexture)
            ]),
            SKAction.wait(forDuration: 0.5),
            moveUp,
            SKAction.wait(forDuration: 0.25)
        ]), completion: {
            isTransitioning = false
            self.openEye()
        })
    }
    
    func phase3Ani() {
        
        invertColor()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            self.revertColor()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            highShape = true
            NotificationCenter.default.post(name: Notification.Name("moonBattleSpawnShape"), object: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.hapticManager?.playSoftRumble()
            }
        }
        
        let moveDownLight = SKAction.move(by: CGVector(dx: 0, dy: -500), duration: 2)
        moveDownLight.timingMode = .easeOut
        
        let moveDown = SKAction.move(by: CGVector(dx: 0, dy: -600), duration: 1.5)
        moveDown.timingMode = .easeOut
        
        self.run(SKAction.sequence([
            SKAction.setTexture(moonOpenedTexture),
            SKAction.move(by: CGVector(dx: 0, dy: 500), duration: 0.5),
            SKAction.setTexture(moonClosedTexture),
            moveDownLight,
            SKAction.sequence([
                SKAction.setTexture(moonOpenedTexture),
                SKAction.repeat(
                    SKAction.sequence([
                        SKAction.move(by: CGVector(dx: 0, dy: 5), duration: 0.05),
                        SKAction.move(by: CGVector(dx: 5, dy: -2.5), duration: 0.05),
                        SKAction.move(by: CGVector(dx: -2.5, dy: 0), duration: 0.05),
                        SKAction.move(by: CGVector(dx: 0, dy: -2.5), duration: 0.05),
                        SKAction.move(by: CGVector(dx: -2.5, dy: 0), duration: 0.05)
                    ]), count: 4),
                SKAction.setTexture(moonClosedTexture)
            ]),
            SKAction.wait(forDuration: 0.5),
            moveDown,
            SKAction.wait(forDuration: 0.25)
        ]), completion: {
            isTransitioning = false
            self.invertColor()
            self.openEye()
        })
    }
    
    func phase4Ani() {
        
        while (targetLines.count > 7) {
            targetLines.remove(at: 0)
        }
        for t in targetLines {
            t.finalMoveDown()
        }
        
        self.run(SKAction.sequence([
            SKAction.setTexture(moonClosedTexture),
            SKAction.move(to: CGPoint(x: 0, y: 300), duration: 1)
        ]), completion: {
            self.hapticManager?.playRumble()
            self.revertColor()
            self.fadeBackground()
            self.run(SKAction.sequence([
                SKAction.setTexture(self.moonOpenedTexture),
                SKAction.repeat(
                    SKAction.sequence([
                        SKAction.move(by: CGVector(dx: 0, dy: 20), duration: 0.05),
                        SKAction.move(by: CGVector(dx: 20, dy: -10), duration: 0.05),
                        SKAction.move(by: CGVector(dx: -10, dy: 0), duration: 0.05),
                        SKAction.move(by: CGVector(dx: 0, dy: -20), duration: 0.05),
                        SKAction.move(by: CGVector(dx: -10, dy: 0), duration: 0.05)
                    ]), count: 4)
            ]), completion: {
                self.explodeMoon()
            })
        })
    }
    
    func openEye() {
        
        hapticManager?.playRumble()
        
        for t in targetLines {
            t.tempRed()
        }
        
        self.run(SKAction.sequence([
            SKAction.setTexture(moonOpenedTexture),
            SKAction.repeat(
                SKAction.sequence([
                    SKAction.move(by: CGVector(dx: 0, dy: 10), duration: 0.05),
                    SKAction.move(by: CGVector(dx: 10, dy: -5), duration: 0.05),
                    SKAction.move(by: CGVector(dx: -5, dy: 0), duration: 0.05),
                    SKAction.move(by: CGVector(dx: 0, dy: -5), duration: 0.05),
                    SKAction.move(by: CGVector(dx: -5, dy: 0), duration: 0.05)
                ]), count: 4),
            SKAction.setTexture(moonClosedTexture),
            SKAction.wait(forDuration: peaceDuration)
        ]), completion: {
            if !isTransitioning {
                self.openEye()
            }
        })
        
        spawnRays(3)
    }
    
    func spawnRays(_ amount: Int) {
        
        for i in Range(0...amount-1) {
            
            let delay = 0.25 * Double(i)
            
            let rotateClockwise = i % 2 == 0
            
            let moonRaysTexture = SKTexture(imageNamed: "moonRays")
            moonRaysTexture.filteringMode = .nearest
            
            let rays = SKSpriteNode(texture: moonRaysTexture)
            rays.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            rays.position = CGPoint(x: 0, y: -200)
            rays.zPosition = -1
            
            addChild(rays)
            
            let scaleUp = SKAction.scale(by: 10, duration: 1)
            scaleUp.timingMode = .easeIn
            
            if rotateClockwise {
                rays.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat.pi * 2.0, duration: TimeInterval(2))))
            } else {
                rays.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat.pi * -2.0, duration: TimeInterval(2))))
            }
            
            rays.run(SKAction.sequence([
                SKAction.wait(forDuration: delay),
                scaleUp,
                SKAction.removeFromParent()
            ]))
        }
    }
    
    func invertColor() {
        
        currentScene.filter = CIFilter(name: "CIColorInvert")
        currentScene.shouldEnableEffects = true
    }
    
    func revertColor() {
        
        currentScene.shouldEnableEffects = false
    }
    
    func explodeMoon() {
        
        for (i, t) in targetLines.enumerated() {
            t.animatedSpit(i: i)
        }
        
        let moonPeices = [SKTexture(imageNamed: "moonPiece1"),
                          SKTexture(imageNamed: "moonPiece2"),
                          SKTexture(imageNamed: "moonPiece3"),
                          SKTexture(imageNamed: "moonPiece4"),
                          SKTexture(imageNamed: "moonPiece5"),
                          SKTexture(imageNamed: "moonPiece6"),
                          SKTexture(imageNamed: "moonPiece7"),
                          SKTexture(imageNamed: "moonPiece8"),
                          SKTexture(imageNamed: "moonPiece9")]
        
        self.run(SKAction.setTexture(SKTexture(imageNamed: "blankMoon")))
        
        let mPositions = [CGPoint(x: 1000, y: 1500),
                          CGPoint(x: 1000, y: -1500),
                          CGPoint(x: 500, y: 1500),
                          CGPoint(x: -1000, y: 1500),
                          CGPoint(x: -1500, y: 500),
                          CGPoint(x: -1000, y: -1500),
                          CGPoint(x: -200, y: -1500),
                          CGPoint(x: 300, y: -1500),
                          CGPoint(x: 0, y: -1500)]
        
        for (i, t) in moonPeices.enumerated() {
            
            t.filteringMode = .nearest
            
            let moonP = SKSpriteNode(texture: t)
            
            moonP.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            moonP.size = self.size
            moonP.position = CGPoint(x: 0, y: 0)
            moonP.zPosition = 1
            
            addChild(moonP)
            
            let moveAway = SKAction.move(to: mPositions[i], duration: 1.25)
            moveAway.timingMode = .easeIn
            
            moonP.run(moveAway)
        }
        
        self.run(SKAction.wait(forDuration: 1.5), completion: {
            self.position = CGPoint(x: 0, y: 0)
            
            lazy var moonLabel: SKLabelNode = {
                let popUpText = SKLabelNode(fontNamed: "Messe Duesseldorf")
                popUpText.numberOfLines = 2
                popUpText.fontSize = 150
                popUpText.zPosition = 4
                popUpText.fontColor = #colorLiteral(red: 0, green: 0.07100000232, blue: 0.09799999744, alpha: 1)
                popUpText.horizontalAlignmentMode = .center
                popUpText.verticalAlignmentMode = .center
                popUpText.text = "Moon"
                popUpText.position = CGPoint(x: 0, y: -1100)
                return popUpText
            }()
            
            lazy var slayerLabel: SKLabelNode = {
                let popUpText = SKLabelNode(fontNamed: "Messe Duesseldorf")
                popUpText.numberOfLines = 2
                popUpText.fontSize = 150
                popUpText.zPosition = 4
                popUpText.fontColor = #colorLiteral(red: 0, green: 0.07100000232, blue: 0.09799999744, alpha: 1)
                popUpText.horizontalAlignmentMode = .center
                popUpText.verticalAlignmentMode = .center
                popUpText.text = "Slayer"
                popUpText.position = CGPoint(x: 0, y: -1000)
                return popUpText
            }()
            
            self.addChild(moonLabel)
            self.addChild(slayerLabel)
            
            moonLabel.run(SKAction.move(to: CGPoint(x: 0, y: 150), duration: 1))
            slayerLabel.run(SKAction.sequence([
                SKAction.move(to: CGPoint(x: 0, y: 0), duration: 1),
                SKAction.wait(forDuration: 1)
            ]), completion: {
                NotificationCenter.default.post(name: Notification.Name("moonBattleOver"), object: nil)
            })
        })
    }
    
    func fadeBackground() {
        
        let blackBg = SKSpriteNode(color: #colorLiteral(red: 0.9139999747, green: 0.8470000029, blue: 0.6510000229, alpha: 1), size: CGSize(width: self.size.width * 2, height: self.size.height * 2))
        blackBg.alpha = 0
        blackBg.zPosition = 0
        
        addChild(blackBg)
        
        blackBg.run(SKAction.fadeIn(withDuration: 1))
    }
    
    func changePhase() {
        
        if !isTransitioning {
            isTransitioning = true
            phase += 1
            if phase == 1 {
                spawnAni()
            } else if phase == 2 {
                for t in targetLines {
                    t.animatedMove()
                }
                phase2Ani()
            } else if phase == 3 {
                for t in targetLines {
                    t.animatedMove()
                }
                phase3Ani()
            } else if phase == 4 {
                phase4Ani()
            }
        }
    }
}


//
//  tutorialScene.swift
//  Colour Shift
//
//  Created by Jaden Scali on 2022-07-23.
//

import SpriteKit

class tutorialScene: SKScene, SKPhysicsContactDelegate {
    
    var currentTutorialPart = 1
    
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
    
    override func didMove(to view: SKView) {
        
        //view.showsPhysics = true
        physicsWorld.contactDelegate = self
        
        tutorialInstructiontxt.position = CGPoint(x: -280, y: -400)
        addChild(tutorialInstructiontxt)
        tutorialBouncyText()
        determinePart()
    }
    
    func determinePart() {
        
        if currentTutorialPart == 1 {
            tutorialPart1()
        } else if currentTutorialPart == 2 {
            //t p2
        } else if currentTutorialPart == 3 {
            //t p3
        }
    }
    
    func tutorialBouncyText() {
        
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
        
        addChild(tutorialText)
        
        tutorialText.run(SKAction.repeatForever(SKAction.sequence([
            SKAction.move(by: CGVector(dx: 0, dy: 50), duration: 1),
            SKAction.wait(forDuration: 0.15),
            SKAction.move(by: CGVector(dx: 0, dy: -50), duration: 1),
            SKAction.wait(forDuration: 0.15)
        ])))
    }
    
    func tutorialPart1() {
        
        tutorialInstructiontxt.text = "Tap anywhere to\nspawn a ball"
        
        let sizeMultipler = 3
        
        //spawns triangle shape
        let trianglePoints = [
            CGPoint(x: 0 * sizeMultipler, y: 50 * sizeMultipler),
            CGPoint(x: 43 * sizeMultipler, y: -25 * sizeMultipler),
            CGPoint(x: -43 * sizeMultipler, y: -25 * sizeMultipler)
        ]
        
        spawnShape(numLayers: 1, shapePoints: trianglePoints)
    }
    
     func spawnShape(numLayers: Int, shapePoints sides: [CGPoint]) {
         
         //totalTargets = sides.count
         
         let shape = SKSpriteNode()
         
         for i in Range(0...sides.count - 1) {
             if i < sides.count - 1 {
                 let t = targetLine(numOfLayers: numLayers, startPoint: sides[i], endPoint: sides[i+1])
                 shape.addChild(t)
             } else {
                 let t = targetLine(numOfLayers: numLayers, startPoint: sides[i], endPoint: sides[0])
                 shape.addChild(t)
             }
         }
         
         shape.position = CGPoint(x: 0, y: 280)
         shape.isHidden = true
         addChild(shape)
         
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
         
         shape.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat.pi * 2.0, duration: TimeInterval(5))))
    }
}

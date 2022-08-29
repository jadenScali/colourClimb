//
//  targetLine.swift
//  Colour Shift
//
//  Created by Jaden Scali on 2022-07-17.
//

import SpriteKit

class targetLine: SKNode {
    
    var layers = 0
    var isRed = false
    var lineTextures: [SKTexture] = [
        SKTexture(imageNamed: "shapeLineDarkestRed"),
        SKTexture(imageNamed: "shapeLineCoolGreen"),
        SKTexture(imageNamed: "shapeLineOffBlack"),
        SKTexture(imageNamed: "shapeLineOffWhite")
    ]
    var currentTexture = SKTexture(imageNamed: "shapeLineDarkestRed")
    var line = SKSpriteNode(color: .clear, size: CGSize(width: 1, height: 1))
    var lineImg = SKSpriteNode(texture: SKTexture(imageNamed: "shapeLineDarkestRed"))
    var srtPoint: CGPoint
    var shape: SKSpriteNode
    
    init(numOfLayers: Int, startPoint: CGPoint, endPoint: CGPoint, shapeHolder: SKSpriteNode) {
        
        layers = numOfLayers
        srtPoint = startPoint
        shape = shapeHolder
        
        super.init()
        
        if layers < lineTextures.count {
            currentTexture = lineTextures[layers]
        }
        
        line.anchorPoint = CGPoint(x: 0, y: 0)
        line.name = "target"
        line.position = startPoint
        line.setScale(4)
        
        //draws line
        let dx = endPoint.x - line.position.x
        let dy = endPoint.y - line.position.y
        let length = sqrt(dx*dx + dy*dy)
        let angle = atan2(dy, dx)
        line.xScale = length
        line.zRotation = angle
        
        let hitBoxPath = CGMutablePath()
        hitBoxPath.move(to: CGPoint(x: 0, y: 0))
        hitBoxPath.addLine(to: CGPoint(x: length, y: 0))
        hitBoxPath.closeSubpath()
        
        //adding physicsBody
        line.physicsBody = SKPhysicsBody(edgeChainFrom: hitBoxPath)
        line.physicsBody?.friction = 0
        line.physicsBody?.restitution = 1
        line.physicsBody?.linearDamping = 0
        line.physicsBody?.angularDamping = 0
        line.physicsBody?.isDynamic = false
        
        line.physicsBody!.categoryBitMask = targetCategory
        line.physicsBody!.contactTestBitMask = ballCategory
        line.physicsBody!.collisionBitMask = ballCategory
        targetLines += [self]
        
        self.addChild(line)
        
        currentTexture = lineTextures[layers]
        currentTexture.filteringMode = .nearest
        lineImg.run(SKAction.setTexture(currentTexture))
        lineImg.anchorPoint = CGPoint(x: 0, y: 1)
        lineImg.position = line.position
        lineImg.size.width = line.size.width
        lineImg.size.height = line.size.height * 10
        lineImg.zPosition = 3
        lineImg.zRotation = deg2rad(55 * (lineImg.size.height / lineImg.size.width)) + angle
        
        addChild(lineImg)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func deg2rad(_ number: Double) -> Double {
        return number * .pi / 180
    }
    
    func changeColor() {
        
        layers -= 1
        if layers >= 0 {
            currentTexture = lineTextures[layers]
            currentTexture.filteringMode = .nearest
            lineImg.run(SKAction.setTexture(currentTexture))
        }
        if layers == 0 {
            isRed = true
        }
    }
    
    func tempRed() {
        
        isRed = true
        
        currentTexture = lineTextures[0]
        currentTexture.filteringMode = .nearest
        lineImg.run(SKAction.setTexture(currentTexture))
        
        line.run(SKAction.wait(forDuration: 1), completion: {
            
            if self.layers != 0 {
                self.isRed = false
            }
            
            self.currentTexture = self.lineTextures[self.layers]
            self.currentTexture.filteringMode = .nearest
            self.lineImg.run(SKAction.setTexture(self.currentTexture))
        })
    }
    
    func animatedMove() {
        
        //break animation
        line.physicsBody = nil
        lineImg.run(SKAction.move(to: CGPoint(x: line.position.x * 15, y: line.position.y * 15), duration: 2))
        
        shape.run(.sequence([
            SKAction.wait(forDuration: 2),
            SKAction.removeFromParent()
        ]))
    }
    
    func finalMoveDown() {
        
        line.physicsBody = nil
        shape.run(SKAction.move(to: CGPoint(x: 0, y: 0), duration: 1))
    }
    
    func animatedSpit(i: Int) {
        
        let tPositions = [CGPoint(x: 0, y: 1500),
                          CGPoint(x: 1500, y: 1500),
                          CGPoint(x: 1500, y: -1500),
                          CGPoint(x: 1500, y: -1500),
                          CGPoint(x: -1500, y: -1500),
                          CGPoint(x: -1500, y: -1500),
                          CGPoint(x: -1500, y: 1500)]
        if i < tPositions.count {
            let moveOut = SKAction.move(to: tPositions[i], duration: 1)
            moveOut.timingMode = .easeIn
            
            lineImg.run(moveOut)
        } else {
            let moveOut = SKAction.move(to: CGPoint(x: 0, y: 1500), duration: 1)
            moveOut.timingMode = .easeIn
            
            lineImg.run(moveOut)
        }
        
        shape.run(.sequence([
            SKAction.wait(forDuration: 1),
            SKAction.removeFromParent()
        ]))
    }
}

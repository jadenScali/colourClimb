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
    //ball color UIColor(red: 0.922, green: 0.333, blue: 0.271, alpha: 1)
    var colors = [UIColor.red,
                  UIColor.yellow,
                  UIColor.green,
                  UIColor.blue,
                  UIColor.cyan,
                  UIColor.magenta]
    var currentColor = UIColor.white
    var line = SKSpriteNode(color: .white, size: CGSize(width: 1, height: 1))
    
    init(numOfLayers: Int, startPoint: CGPoint, endPoint: CGPoint) {
        
        layers = numOfLayers
        
        super.init()
        
        currentColor = colors[layers]
        line.color = currentColor
        line.anchorPoint = CGPoint(x: 0, y: 0)
        line.name = "target"
        line.position = startPoint
        line.setScale(2)
        
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
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changeColor() {
        
        layers -= 1
        if layers >= 0 {
            currentColor = colors[layers]
            line.color = currentColor
        }
        if layers == 0 {
            print("final hit?")
            isRed = true
        }
    }
    
    func animatedMove() {
        
        line.physicsBody = nil
        line.run(.sequence([
            SKAction.move(to: CGPoint(x: line.position.x * 20, y: line.position.y * 20), duration: 2),
            SKAction.removeFromParent()
        ]))
    }
}
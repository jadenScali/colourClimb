//
//  tutorialScene.swift
//  Colour Shift
//
//  Created by Jaden Scali on 2022-07-23.
//

import SpriteKit

class tutorialScene: SKScene, SKPhysicsContactDelegate {
    
    override func didMove(to view: SKView) {
        
        //view.showsPhysics = true
        physicsWorld.contactDelegate = self
    }
}

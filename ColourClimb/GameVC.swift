//
//  GameViewController.swift
//  Colour Climb
//
//  Created by Jaden Scali on 2022-07-17.
//

import UIKit
import SpriteKit
import GameplayKit

class GameVC: UIViewController {
    
    var sceneName = "GameScene"

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            
            NotificationCenter.default.addObserver(self, selector: #selector(loadMainMenu), name: Notification.Name("loadMainMenu"), object: nil)
            
            var wantsTutorial = true
            
            if UserDefaults.standard.object(forKey: "wantsTutorial") != nil {
                wantsTutorial = UserDefaults.standard.object(forKey: "wantsTutorial") as! Bool
            }
            
            if wantsTutorial {
                sceneName = "TutorialScene"
            } else {
                sceneName = "GameScene"
            }
            
            //load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: sceneName) {
                //set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                //present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @objc func loadMainMenu() {
        
        //loads main menu with fade animation
        if let skView = self.view as! SKView? {
            UIView.animate(
                withDuration: 0.5,
                delay: 0,
                options: .curveEaseIn,
                animations: {
                    skView.alpha = 0
                }, completion: { finished in
                    self.dismiss(animated: false)
                }
            )
        }
    }
}

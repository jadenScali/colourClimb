//
//  statsVC.swift
//  Colour Climb
//
//  Created by Jaden Scali on 2022-07-22.
//

import UIKit

class statsVC: UIViewController {
    
    @IBOutlet weak var hiRoundtxt: UILabel!
    @IBOutlet weak var moonSlayertxt: UILabel!
    @IBOutlet weak var gamesPlayedtxt: UILabel!
    @IBOutlet weak var shapesDestroyedtxt: UILabel!
    @IBOutlet weak var linesDestroyedtxt: UILabel!
    @IBOutlet weak var ballsFiredtxt: UILabel!
    
    var hiRound = 0
    var slayedMoon = false
    var gamesPlayed = 0
    var shapesDestroyed = 0
    var linesDestroyed = 0
    var ballsFired = 0
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setTextToStats()
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
    
    func loadStats() {
        
        if UserDefaults.standard.object(forKey: "hiRound") != nil {
            hiRound = UserDefaults.standard.object(forKey: "hiRound") as! Int
        }
        if UserDefaults.standard.object(forKey: "slayedMoon") != nil {
            slayedMoon = UserDefaults.standard.object(forKey: "slayedMoon") as! Bool
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
    
    func setTextToStats() {
        
        loadStats()
        if hiRound == 22 {
            hiRoundtxt.text = "The Moon (\(hiRound))"
        } else {
            hiRoundtxt.text = "\(hiRound)"
        }
        if slayedMoon {
            moonSlayertxt.text = "Yes"
        } else {
            moonSlayertxt.text = "No"
        }
        
        gamesPlayedtxt.text = "\(gamesPlayed)"
        shapesDestroyedtxt.text = "\(shapesDestroyed)"
        linesDestroyedtxt.text = "\(linesDestroyed)"
        ballsFiredtxt.text = "\(ballsFired)"
    }
}

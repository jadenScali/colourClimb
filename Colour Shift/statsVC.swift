//
//  statsVC.swift
//  Colour Shift
//
//  Created by Jaden Scali on 2022-07-22.
//

import UIKit

class statsVC: UIViewController {

    @IBOutlet var superView: UIView!
    
    @IBOutlet weak var hiScoretxt: UILabel!
    @IBOutlet weak var hiRoundtxt: UILabel!
    @IBOutlet weak var gamesPlayedtxt: UILabel!
    @IBOutlet weak var shapesDestroyedtxt: UILabel!
    @IBOutlet weak var linesDestroyedtxt: UILabel!
    @IBOutlet weak var ballsFiredtxt: UILabel!
    
    var hiScore = 0
    var hiRound = 0
    var gamesPlayed = 0
    var shapesDestroyed = 0
    var linesDestroyed = 0
    var ballsFired = 0
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        determineColour()
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
    
    func determineColour() {
        
        var nightMode = false
        if UserDefaults.standard.object(forKey: "nightMode") != nil {
            nightMode = UserDefaults.standard.object(forKey: "nightMode") as! Bool
        }
        
        var colour = #colorLiteral(red: 0.9843137264, green: 0.9137254953, blue: 0.4980392158, alpha: 1)
        if nightMode {
            colour = UIColor.black
        } else {
            colour = #colorLiteral(red: 0.9843137264, green: 0.9137254953, blue: 0.4980392158, alpha: 1)
        }
        
        superView.backgroundColor = colour
    }
    
    func loadStats() {
        
        if UserDefaults.standard.object(forKey: "hiScore") != nil {
            hiScore = UserDefaults.standard.object(forKey: "hiScore") as! Int
        }
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
    
    func setTextToStats() {
        
        loadStats()
        
        hiScoretxt.text = "\(hiScore)"
        hiRoundtxt.text = "\(hiRound)"
        gamesPlayedtxt.text = "\(gamesPlayed)"
        shapesDestroyedtxt.text = "\(shapesDestroyed)"
        linesDestroyedtxt.text = "\(linesDestroyed)"
        ballsFiredtxt.text = "\(ballsFired)"
    }
}

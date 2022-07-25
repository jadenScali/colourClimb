//
//  mainMenuVC.swift
//  Colour Shift
//
//  Created by Jaden Scali on 2022-07-17.
//

import UIKit
import SpriteKit
import GameplayKit
import AVFoundation

var musicIsPlaying = false
var shouldFadeInMainView = false

var backGroundMusic: AVAudioPlayer? = {
    guard let url = Bundle.main.url(forResource: "colourShiftLofiSoundtrack", withExtension: "m4a") else {
        return nil
    }
    do {
        //makes not effected by ringer
        try AVAudioSession.sharedInstance().setCategory(.playback)
        
        let audioPlayer = try AVAudioPlayer(contentsOf: url)
        //-1 makes it loop forever
        audioPlayer.numberOfLoops = -1
        return audioPlayer
    } catch {
        return nil
    }
}()

class mainMenuVC: UIViewController {
    
    @IBOutlet weak var tutorialButton: UISwitch!
    @IBOutlet weak var musicButton: UISwitch!
    @IBOutlet weak var nightButton: UISwitch!
    
    @IBOutlet var superView: UIView!
    @IBOutlet weak var shiftTitletxt: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var mainView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playStopMusic()
        determineColour()
        determineTutorialButton()
        
        if UserDefaults.standard.object(forKey: "musicIsPlaying") != nil {
            let musicOn = UserDefaults.standard.object(forKey: "musicIsPlaying") as! Bool
            if musicOn {
                musicButton.isOn = true
            } else if !musicOn {
                musicButton.isOn = false
            }
        } else {
            musicButton.isOn = true
        }
    }
    
    override func viewDidLayoutSubviews() {
        
        currentTutorialPart = 1
        determineColour()
        determineTutorialButton()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        if shouldFadeInMainView {
            shouldFadeInMainView = false
            superView.alpha = 0
            UIView.animate(
                withDuration: 1,
                delay: 0,
                options: .curveEaseOut,
                animations: {
                    self.superView.alpha = 1
                }
            )
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
    
    @IBAction func musicSwitch(_ sender: UISwitch) {
        
        if sender.isOn {
            UserDefaults.standard.set(true, forKey: "musicIsPlaying")
            playStopMusic()
            let haptic = UIImpactFeedbackGenerator(style: .soft)
            haptic.impactOccurred()
        } else {
            UserDefaults.standard.set(false, forKey: "musicIsPlaying")
            playStopMusic()
            let haptic = UIImpactFeedbackGenerator(style: .soft)
            haptic.impactOccurred()
        }
    }
    
    @IBAction func nightSwitch(_ sender: UISwitch) {
        
        if sender.isOn {
            UserDefaults.standard.set(true, forKey: "nightMode")
            determineColour()
        } else {
            UserDefaults.standard.set(false, forKey: "nightMode")
            determineColour()
        }
    }
    
    @IBAction func tutorialSwitch(_ sender: UISwitch) {
        
        if sender.isOn {
            UserDefaults.standard.set(true, forKey: "wantsTutorial")
        } else {
            UserDefaults.standard.set(false, forKey: "wantsTutorial")
        }
    }
    
    @IBAction func dragOutsidePlayButton(_ sender: Any) {
        
        determineColour()
    }
    
    func determineColour() {
        
        var nightMode = false
        if UserDefaults.standard.object(forKey: "nightMode") != nil {
            nightMode = UserDefaults.standard.object(forKey: "nightMode") as! Bool
        }
        
        var colour = #colorLiteral(red: 0.9843137264, green: 0.9137254953, blue: 0.4980392158, alpha: 1)
        if nightMode {
            colour = UIColor.black
            nightButton.isOn = true
        } else {
            colour = #colorLiteral(red: 0.9843137264, green: 0.9137254953, blue: 0.4980392158, alpha: 1)
            nightButton.isOn = false
        }
        
        superView.backgroundColor = colour
        shiftTitletxt.textColor = colour
        playButton.titleLabel?.textColor = colour
        tutorialButton.thumbTintColor = colour
        musicButton.thumbTintColor = colour
        nightButton.thumbTintColor = colour
    }
    
    func determineTutorialButton() {
        
        var wantsTutorial = true
        
        if UserDefaults.standard.object(forKey: "wantsTutorial") != nil {
            wantsTutorial = UserDefaults.standard.object(forKey: "wantsTutorial") as! Bool
        }
        
        if wantsTutorial {
            tutorialButton.isOn = true
        } else {
            tutorialButton.isOn = false
        }
    }
    
    @objc func playStopMusic() {
        
        var musicPlaying = true;
        
        if UserDefaults.standard.object(forKey: "musicIsPlaying") != nil {
            musicPlaying = UserDefaults.standard.object(forKey: "musicIsPlaying") as! Bool
        }
        
        if musicPlaying {
            
            backGroundMusic?.play()
            musicIsPlaying = true
        } else {
            
            backGroundMusic?.stop()
        }
    }
}

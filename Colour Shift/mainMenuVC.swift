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
var currentTutorialPart = 1

var backGroundMusic: AVAudioPlayer? = {
    guard let url = Bundle.main.url(forResource: "colourClimbLofiSoundtrack", withExtension: "m4a") else {
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

var moonMusic: AVAudioPlayer? = {
    guard let url = Bundle.main.url(forResource: "colourClimbLofiMoon", withExtension: "m4a") else {
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
    
    @IBOutlet var superView: UIView!
    @IBOutlet weak var shiftTitletxt: UILabel!
    
    @IBOutlet weak var musicOnOffTxt: UILabel!
    var musicButtonOn = false
    
    @IBOutlet weak var tutorialOnOffTxt: UILabel!
    var tutorialButtonOn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playStopBgMusic()
        UserDefaults.standard.set(true, forKey: "moonMusicShouldPlay")
        determineTutorialButton()
        
        NotificationCenter.default.addObserver(self, selector: #selector(playBgMusic), name: Notification.Name("playBgMusic"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(stopBgMusic), name: Notification.Name("stopBgMusic"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(playStopMoonMusic), name: Notification.Name("playStopMoonMusic"), object: nil)
        
        if UserDefaults.standard.object(forKey: "musicIsPlaying") != nil {
            let musicOn = UserDefaults.standard.object(forKey: "musicIsPlaying") as! Bool
            if musicOn {
                musicButtonOn = false
                musicOnOffTxt.text = "ON"
            } else if !musicOn {
                musicButtonOn = true
                musicOnOffTxt.text = "OFF"
            }
        } else {
            musicButtonOn = true
            musicOnOffTxt.text = "OFF"
        }
    }
    
    override func viewDidLayoutSubviews() {
        
        currentTutorialPart = 1
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        //if coming from gameVC completes animation
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
    
    @IBAction func optionsArrowButton(_ sender: Any) {
        
        let haptic = UIImpactFeedbackGenerator(style: .light)
        haptic.impactOccurred()
    }
    
    @IBAction func playButtonPress(_ sender: Any) {
        let haptic = UIImpactFeedbackGenerator(style: .soft)
        haptic.impactOccurred()
    }
    
    @IBAction func musicOffOnTap(_ sender: Any) {
        
        let haptic = UIImpactFeedbackGenerator(style: .soft)
        haptic.impactOccurred()
        
        if musicButtonOn {
            UserDefaults.standard.set(true, forKey: "musicIsPlaying")
            playStopBgMusic()
            musicOnOffTxt.text = "ON"
            
            musicButtonOn = false
        } else {
            UserDefaults.standard.set(false, forKey: "musicIsPlaying")
            playStopBgMusic()
            musicOnOffTxt.text = "OFF"
            
            musicButtonOn = true
        }
    }
    
    @IBAction func tutorialOffOnTap(_ sender: Any) {
        
        let haptic = UIImpactFeedbackGenerator(style: .soft)
        haptic.impactOccurred()
        
        if tutorialButtonOn {
            UserDefaults.standard.set(true, forKey: "wantsTutorial")
            tutorialOnOffTxt.text = "ON"
            
            tutorialButtonOn = false
        } else {
            UserDefaults.standard.set(false, forKey: "wantsTutorial")
            tutorialOnOffTxt.text = "OFF"
            
            tutorialButtonOn = true
        }
    }
    
    func determineTutorialButton() {
        
        var wantsTutorial = true
        
        if UserDefaults.standard.object(forKey: "wantsTutorial") != nil {
            wantsTutorial = UserDefaults.standard.object(forKey: "wantsTutorial") as! Bool
        }
        
        if wantsTutorial {
            tutorialButtonOn = false
            tutorialOnOffTxt.text = "ON"
        } else {
            tutorialButtonOn = true
            tutorialOnOffTxt.text = "OFF"
        }
    }
    
    @objc func playStopBgMusic() {
        
        var musicPlaying = true;
        
        if UserDefaults.standard.object(forKey: "musicIsPlaying") != nil {
            musicPlaying = UserDefaults.standard.object(forKey: "musicIsPlaying") as! Bool
        }
        
        if musicPlaying {
            
            backGroundMusic?.currentTime = 0
            backGroundMusic?.play()
            musicIsPlaying = true
        } else {
            
            backGroundMusic?.stop()
        }
    }
    
    @objc func playBgMusic() {
        
        backGroundMusic?.currentTime = 0
        backGroundMusic?.play()
    }
    
    @objc func stopBgMusic() {
        
        backGroundMusic?.stop()
    }
    
    @objc func playStopMoonMusic() {
        
        var moonMusicPlaying = true;
        
        if UserDefaults.standard.object(forKey: "moonMusicShouldPlay") != nil {
            moonMusicPlaying = UserDefaults.standard.object(forKey: "moonMusicShouldPlay") as! Bool
        }
        
        if UserDefaults.standard.object(forKey: "musicIsPlaying") as! Bool {
            if moonMusicPlaying {
                UserDefaults.standard.set(false, forKey: "moonMusicShouldPlay")
                moonMusic?.currentTime = 0
                moonMusic?.play()
            } else {
                UserDefaults.standard.set(true, forKey: "moonMusicShouldPlay")
                moonMusic?.stop()
            }
        }
    }
}

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

class mainMenuVC: UIViewController {
    
    @IBOutlet weak var musicButton: UISwitch!
    
    lazy var backGroundMusic: AVAudioPlayer? = {
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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        playStopMusic()
        
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
        } else {
            UserDefaults.standard.set(false, forKey: "musicIsPlaying")
            playStopMusic()
        }
    }
    
    
    @objc func playStopMusic() {
        
        var musicPlaying = true;
        
        if UserDefaults.standard.object(forKey: "musicIsPlaying") != nil {
            musicPlaying = UserDefaults.standard.object(forKey: "musicIsPlaying") as! Bool
        }
        
        if musicPlaying {
            
            backGroundMusic?.play()
        } else {
            
            backGroundMusic?.stop()
        }
    }
}

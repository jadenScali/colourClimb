//
//  optionsVC.swift
//  Colour Climb
//
//  Created by Jaden Scali on 2022-07-21.
//

import UIKit

class optionsVC: UIViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    @IBAction func statsArrowButton(_ sender: Any) {
        
        let haptic = UIImpactFeedbackGenerator(style: .light)
        haptic.impactOccurred()
    }
    
    @IBAction func feedbackArrowButton(_ sender: Any) {
        
        let haptic = UIImpactFeedbackGenerator(style: .light)
        haptic.impactOccurred()
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
}

//
//  feedbackVC.swift
//  Colour Shift
//
//  Created by Jaden Scali on 2022-07-23.
//

import UIKit
import MessageUI

class feedbackVC: UIViewController, MFMailComposeViewControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var contactUsButton: UIButton!
    @IBOutlet weak var feedBackBodyTxt: UILabel!
    
    @IBOutlet weak var contactButtonTxt: UILabel!
    @IBOutlet weak var contactButtonBacking: UIImageView!
    
    var didSendFeedback = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        
        if didSendFeedback {
            feedBackBodyTxt.text = "Thank you for your feedback!"
            contactUsButton.isHidden = true
            
            contactButtonTxt.text = " "
            contactButtonBacking.isHidden = true
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
    
    @IBAction func contactUsButtonPress(_ sender: Any) {
        
        let haptic = UIImpactFeedbackGenerator(style: .soft)
        haptic.impactOccurred()
        
        let vc = MFMailComposeViewController()
        vc.mailComposeDelegate = self
        vc.setSubject("Feedback")
        vc.setToRecipients(["colourclimbhelp@gmail.com"])
        present(vc, animated: true)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        didSendFeedback = true
        controller.dismiss(animated: true)
    }
}

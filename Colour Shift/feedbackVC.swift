//
//  feedbackVC.swift
//  Colour Shift
//
//  Created by Jaden Scali on 2022-07-23.
//

import UIKit
import MessageUI

class feedbackVC: UIViewController, MFMailComposeViewControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var superView: UIView!
    @IBOutlet weak var contactUsButton: UIButton!
    @IBOutlet weak var feedBackBodyTxt: UILabel!
    
    var didSendFeedback = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        
        determineColour()
        
        if didSendFeedback {
            feedBackBodyTxt.text = "Thank you for your feedback!"
            contactUsButton.isHidden = true
        }
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
        contactUsButton.titleLabel?.textColor = colour
    }
    
    @IBAction func dragOutsidePlayButton(_ sender: Any) {
        
        determineColour()
    }
    
    @IBAction func contactUsButtonPress(_ sender: Any) {
        
        let vc = MFMailComposeViewController()
        vc.mailComposeDelegate = self
        vc.setSubject("Feedback")
        vc.setToRecipients(["colourshifthelp@gmail.com"])
        present(vc, animated: true)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        didSendFeedback = true
        controller.dismiss(animated: true)
    }
}

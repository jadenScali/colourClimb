//
//  feedbackVC.swift
//  Colour Shift
//
//  Created by Jaden Scali on 2022-07-23.
//

import UIKit

class feedbackVC: UIViewController {
    
    @IBOutlet var superView: UIView!
    @IBOutlet weak var contactUsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        
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
        
        
    }
}

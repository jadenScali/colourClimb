//
//  optionsVC.swift
//  Colour Shift
//
//  Created by Jaden Scali on 2022-07-21.
//

import UIKit

class optionsVC: UIViewController {

    @IBOutlet var superView: UIView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        determineColour()
    }
    
    override func viewDidLayoutSubviews() {
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
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
}

//
//  mainNC.swift
//  Colour Shift
//
//  Created by Jaden Scali on 2022-07-22.
//

import UIKit

class mainNC: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
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

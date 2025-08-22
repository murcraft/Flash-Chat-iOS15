//
//  WelcomeViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import GhostTypewriter

class WelcomeViewController: UIViewController {

    @IBOutlet weak var titleLabel: TypewriterLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = "⚡️FlashChat"
        titleLabel.startTypewritingAnimation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        titleLabel.restartTypewritingAnimation()
    }
}

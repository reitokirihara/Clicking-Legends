//
//  levelUpViewController.swift
//  Clicking Legends
//
//  Created by UCode on 4/14/18.
//  Copyright © 2018 Reito Kirihara. All rights reserved.
//

import Foundation
import UIKit

class LevelUpViewController: UIViewController {
    
    @IBOutlet var levelLabel: UILabel!
    
    var level: Int = 0
    
    override func viewDidLoad() {
        levelLabel.text = "\(level)"
    }
    
    @IBAction func goBack(){
        dismiss(animated: false, completion: nil)
    }
}


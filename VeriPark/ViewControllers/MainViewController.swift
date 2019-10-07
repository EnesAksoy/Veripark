//
//  ViewController.swift
//  VeriPark
//
//  Created by ENES AKSOY on 7.10.2019.
//  Copyright © 2019 ENES AKSOY. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var iconLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    let buttonText = "IMKB Hisse Senetleri/Endeksler"
    let iconLabelText = "VERİPARK"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.iconLabel.text = self.iconLabelText
        self.nextButton.setTitle(self.buttonText, for: .normal)
    }
}


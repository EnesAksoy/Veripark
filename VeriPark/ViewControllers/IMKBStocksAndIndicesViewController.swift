//
//  IMKBStocksAndIndicesViewController.swift
//  VeriPark
//
//  Created by ENES AKSOY on 7.10.2019.
//  Copyright © 2019 ENES AKSOY. All rights reserved.
//

import UIKit

class IMKBStocksAndIndicesViewController: UIViewController {
    
    @IBOutlet weak var stocksAndIndicesButton: UIButton!
    @IBOutlet weak var IMKBRisingButton: UIButton!
    @IBOutlet weak var IMKBDrop: UIButton!
    @IBOutlet weak var IMKBVolume: UIButton!
    
    let stocksAndIndicesButtonText = "Hisse ve Endeksler"
    let IMKBRisingButtonText = "IMKB Yükselenler"
    let IMKBDropText = "IMKB Düşenler"
    let IMKBVolumeText = "IMKB Hacme Göre"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.IMKBDrop.setTitle(self.IMKBDropText, for: .normal)
        self.IMKBRisingButton.setTitle(self.IMKBRisingButtonText, for: .normal)
        self.IMKBVolume.setTitle(self.IMKBVolumeText, for: .normal)
        self.stocksAndIndicesButton.setTitle(self.stocksAndIndicesButtonText, for: .normal)

    }
}

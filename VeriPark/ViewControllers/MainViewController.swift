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
    
    var iMKBStocksAndIndicesViewController = IMKBStocksAndIndicesViewController()
    
    var symbolArrayInSymbolStr: [String] = []
    var isAuthorization: Bool!
    
    let startRequestViewController = StartRequestViewController()
    
    let buttonText = "IMKB Hisse Senetleri/Endeksler"
    let iconLabelText = "VERİPARK"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.iconLabel.text = self.iconLabelText
        self.nextButton.setTitle(self.buttonText, for: .normal)
        self.isAuthorization = startRequestViewController.startResponse()
    }
    
    @IBAction func button(_ sender: Any) {
        if (self.isAuthorization) {
            StructView.periodName = startRequestViewController.periodChangeName(name: "all")
            startRequestViewController.secondResponse()
        }else {
            self.isAuthorization = startRequestViewController.startResponse()
            showAlert(title: "HATA", message: "Lütfen internetinizi kontrol ediniz ve butona tekrar tıklayınız.")
        }
    }
}

extension UIViewController {
    func showAlert (title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
        self.present(alert,animated:true,completion:nil)
    }
}



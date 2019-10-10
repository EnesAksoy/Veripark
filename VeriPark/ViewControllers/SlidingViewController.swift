//
//  DrawerViewController.swift
//  VeriPark
//
//  Created by ENES AKSOY on 7.10.2019.
//  Copyright © 2019 ENES AKSOY. All rights reserved.
//

import UIKit
import NavigationDrawer

class SlidingViewController: UIViewController, UIAlertViewDelegate {
    
    @IBOutlet weak var veriparkLabel: UILabel!
    @IBOutlet weak var ImkbStocksLabel: UILabel!
    
    @IBOutlet weak var buttonAll: UIButton!
    @IBOutlet weak var buttonIncreasing: UIButton!
    @IBOutlet weak var buttonDecreasing: UIButton!
    @IBOutlet weak var buttonVolume30: UIButton!
    @IBOutlet weak var buttonVolume50: UIButton!
    @IBOutlet weak var buttonVolume100: UIButton!
    
    
    var veriparkLabelValue = "VERIPARK"
    var ImkbStocksLabelValue = "IMKB Hisse Senetleri/Endeksler"
    
    var buttonAllText = "Hiise ve Endeksler"
    var buttonIncreasingText = "Yükselenler"
    var buttonDecreasingText = "Düşenler"
    var buttonVolume30Text = "Hacme Göre-30"
    var buttonVolume50Text = "Hacme Göre-50"
    var buttonVolume100Text = "Hacme Göre-100"
    
    var alert = UIAlertController()
    
    var interactor:Interactor? = nil
    
    
    var deneme = StartRequestViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.veriparkLabel.text = self.veriparkLabelValue
        self.ImkbStocksLabel.text = self.ImkbStocksLabelValue
        
        self.buttonAll.setTitle(self.buttonAllText, for: .normal)
        self.buttonIncreasing.setTitle(self.buttonIncreasingText, for: .normal)
        self.buttonDecreasing.setTitle(self.buttonDecreasingText, for: .normal)
        self.buttonVolume30.setTitle(self.buttonVolume30Text, for: .normal)
        self.buttonVolume50.setTitle(self.buttonVolume50Text, for: .normal)
        self.buttonVolume100.setTitle(self.buttonVolume100Text, for: .normal)
        
        self.buttonVolume30.isHidden = true
        self.buttonVolume50.isHidden = true
        self.buttonVolume100.isHidden = true
        
        
        
        
    }
    
    @IBAction func handleGesture(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        
        let progress = MenuHelper.calculateProgress(translationInView: translation, viewBounds: view.bounds, direction: .Left)
        
        MenuHelper.mapGestureStateToInteractor(
            gestureState: sender.state,
            progress: progress,
            interactor: interactor) {
//                self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func closeBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func buttonAllClicked(_ sender: Any) {
        deneme.startResponse()
        deneme.name = "all"
        
        
        
    }
    @IBAction func buttonIncresingClicked(_ sender: Any) {
        
//        self.deneme.name = "increasing"
        StructView.periodName = deneme.periodChangeName(name: "increasing")
        if (Int(truncating: StructView.secondApiEnter) < 1) {
            showAlert(title: "HATA", message: "Lütfen tekrar deneyiniz.")
        }
        self.deneme.secondResponse()
        self.performSegue(withIdentifier: "slideToDetail", sender: self)
        
////        StructView.periodName = deneme.periodChangeName(name: "increasing")
//
//        if (Int(truncating: StructView.secondApiEnter) < 2) {
////            self.alert = showAlert(title: "HATA", message: "Lütfen tekrar deneyiniz.")
//            self.alert = UIAlertController(title: "HATA", message: "Lütfen tekrar deneyiniz.", preferredStyle: .alert)
//            self.alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
//
//                self.deneme.name = "increasing"
//                self.deneme.secondResponse()
//              //  self.deneme.periodChangeName(name: "increasing")
//                self.performSegue(withIdentifier: "slideToDetail", sender: self)
//
//                }))
//            self.present(alert, animated: true, completion: nil)
//        }
        
    }
    
    
    
    
    
    
    @IBAction func buttonDecreasingClicked(_ sender: Any) {
        self.buttonVolume30.isHidden = false
        self.buttonVolume50.isHidden = false
        self.buttonVolume100.isHidden = false
        
        
    }
    @IBAction func buttonVolume30Clicked(_ sender: Any) {
        
    }
    
    @IBAction func buttonVolume50Clicked(_ sender: Any) {
        
    }
    @IBAction func buttonVolume100Clicked(_ sender: Any) {
        
    }
    
}


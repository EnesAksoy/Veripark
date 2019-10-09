//
//  IMKBStocksAndIndicesDetailsViewController.swift
//  VeriPark
//
//  Created by ENES AKSOY on 9.10.2019.
//  Copyright © 2019 ENES AKSOY. All rights reserved.
//

import UIKit

class IMKBStocksAndIndicesDetailsViewController: UIViewController {

    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var percentDifferenceLabel: UILabel!
    @IBOutlet weak var volumeLabel: UILabel!
    @IBOutlet weak var buyingLabel: UILabel!
    @IBOutlet weak var salesLabel: UILabel!
    @IBOutlet weak var dailyLowLabel: UILabel!
    @IBOutlet weak var dailyHighLabel: UILabel!
    @IBOutlet weak var pieceLabel: UILabel!
    @IBOutlet weak var ceilingLabel: UILabel!
    @IBOutlet weak var baseLabel: UILabel!
    @IBOutlet weak var changeLabel: UILabel!
    
    @IBOutlet weak var symbolValueLabel: UILabel!
    @IBOutlet weak var priceValueLabel: UILabel!
    @IBOutlet weak var percentDiffrenceValueLabel: UILabel!
    @IBOutlet weak var transactionVolumeValueLabel: UILabel!
    @IBOutlet weak var buyingValueLabel: UILabel!
    @IBOutlet weak var salesValueLabel: UILabel!
    @IBOutlet weak var dailyLowValueLabel: UILabel!
    @IBOutlet weak var dailyHighValueLabel: UILabel!
    @IBOutlet weak var pieceValueLabel: UILabel!
    @IBOutlet weak var ceilingValueLabel: UILabel!
    @IBOutlet weak var baseValueLabel: UILabel!
    
    
    let symbolLabelText = "Sembol:"
    let priceLabelText = "Fiyat:"
    let percentDifferenceLabelText = "% Fark:"
    let volumeLabelText = "Hacim:"
    let buyingLabelText = "Alış:"
    let salesLabelText = "Satış:"
    let dailyLowLabelText = "Günlük Düşük:"
    let dailyHighLabelText = "Günlük Yüksek:"
    let pieceLabelText = "Adet:"
    let ceilingLabelText = "Tavan:"
    let baseLabelText = "Taban:"
    let changeLabelText = "Değişim:"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.symbolLabel.text = symbolLabelText
        self.priceLabel.text = priceLabelText
        self.percentDifferenceLabel.text = percentDifferenceLabelText
        self.volumeLabel.text = volumeLabelText
        self.buyingLabel.text = buyingLabelText
        self.salesLabel.text = salesLabelText
        self.dailyLowLabel.text = dailyLowLabelText
        self.dailyHighLabel.text = dailyHighLabelText
        self.pieceLabel.text = pieceLabelText
        self.ceilingLabel.text = ceilingLabelText
        self.baseLabel.text = baseLabelText
        self.changeLabel.text = changeLabelText
        
    
    }
    
    

    

}

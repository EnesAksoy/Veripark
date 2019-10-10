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
    @IBOutlet weak var changeİmageView: UIImageView!
    
    
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
    
    var id = String(StructView.selectedId)
    var encryptIdBase64 : String = ""
    
    var isDown: Bool = false
    var bid: Double = 0.0
    var change: Double = 0.0
    var count: Int = 0
    var difference: Double = 0.0
    var offer: Double = 0.0
    var highest: Double = 0.0
    var lowest: Double = 0.0
    var maximum: Double = 0.0
    var minumum: Double = 0.0
    var price: Double = 0.0
    var volume: Double = 0.0
    var symbol: String = ""
    var symbolDecrypt = ""
    
    
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
        
        if (isDown == false) {
            changeİmageView.image = UIImage(named:"up")!
        } else {
            changeİmageView.image = UIImage(named:"down")!
        }
        
        thirdResponse()
       
    
    }
    
    func thirdResponse () {
        let urlDetail = URL(string:"https://mobilechallange.veripark.com/api/stocks/detail")!
        let session3 = URLSession.shared
        var request3 = URLRequest(url: urlDetail)
        request3.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request3.addValue(StructView.authorization, forHTTPHeaderField: "X-VP-Authorization")
        request3.httpMethod = "POST"
        if let aes = AESS(key: StructView.keyData , iv: StructView.ivData) {
            let encryptId = aes.encrypt(string: id)
            self.encryptIdBase64 = (encryptId?.base64EncodedString(options: NSData.Base64EncodingOptions()))!
        }
        var params3 : [String:String]
        params3 = ["id" : encryptIdBase64]
        do {
            request3.httpBody = try JSONSerialization.data(withJSONObject: params3, options: .prettyPrinted)
        }catch let error {
            print(error.localizedDescription)
        }
        let task = session3.dataTask(with: request3 as URLRequest, completionHandler: { data, response, error in
            guard error == nil else {
                print(error?.localizedDescription ?? "ERROR")
                return
            }
            guard let data = data else {
                return
            }
            do {
                if let json3 = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject] {
                    self.bid = json3["bid"] as! Double
                    //print("bidddddd::::: \(self.bid)")
                    self.isDown = json3["isDown"] as! Bool
                    self.change = json3["channge"] as! Double
                    self.count = json3["count"] as! Int
                    self.difference = json3["difference"] as! Double
                    self.offer = json3["offer"] as! Double
                    self.highest = json3["highest"] as! Double
                    self.lowest = json3["lowest"] as! Double
                    self.maximum = json3["maximum"] as! Double
                    self.price = json3["price"] as! Double
                    self.volume = json3["volume"] as! Double
                    self.symbol = json3["symbol"] as! String
                     if let aes = AESS(key: StructView.keyData! , iv: StructView.ivData!) {
                        let symData = Data(base64Encoded: self.symbol)
                        let symDataString = aes.decrypt(data: symData)
                        self.symbolDecrypt = symDataString!
                       }
                   
                 
                    
                }
            }
            catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
        
    }
}

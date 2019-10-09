//
//  StartRequestViewController.swift
//  VeriPark
//
//  Created by ENES AKSOY on 8.10.2019.
//  Copyright © 2019 ENES AKSOY. All rights reserved.
//

import UIKit
import CryptoSwift
import RNCryptor

class StartRequestViewController: UIViewController {
    
    var aesKey : String = ""
    var aesIV : String = ""
    var authorization : String = ""
    var periodNameBase64 : String = ""
    var symbol : String = ""
    var symbolArrayInSymbolArray: [String] = []
    var symbolArrayInPriceArray: [Double] = []
    var symbolArrayInDifferenceArray: [Double] = []
    var offerArray: [Double] = []
    var volumeArray: [Double] = []
    var bidArray: [Double] = []
    var symbolArrayInSymbolStr: [String] = []
    var returnFirst: [String] = []
    var isDownArray: [Bool] = []
    
    var keyData: Data!
    var ivData: Data!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func startResponse() {
        
            let url = URL(string:"https://mobilechallange.veripark.com/api/handshake/start")!
            let session = URLSession.shared
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            var params : [String : Any]
            params = ["deviceId": "Enes",
                      "systemVersion": "12.2",
                      "platformName": "iOS",
                      "deviceModel": "iPhone XS Max",
                      "manifacturer": "Apple"]
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            } catch let error {
                print(error.localizedDescription)
            }
            let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
                guard error == nil else {
                    print(error?.localizedDescription ?? "ERROR")
                    return
                }
                
                guard let data = data else {
                    return
                }
                do {
                    
                    if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                        //print(json)
                        self.aesKey = json["aesKey"] as! String
                        print("aesKey = \(self.aesKey)")
                        self.aesIV = json["aesIV"] as! String
                        print("aesIV = \(self.aesIV)")
                        self.authorization = json["authorization"] as! String
                        print("authorization = \(self.authorization)")
                        
                    }
                    self.keyData = Data(base64Encoded: self.aesKey)!
                    self.ivData = Data(base64Encoded: self.aesIV)!
                    
                    self.periodChangeName(name: "all")
                    
                    
                } catch let error {
                    print(error.localizedDescription)
                }
            })
            task.resume()
//        semaphore.wait()
//        secondResponse()
//        }
    }
    
    func periodChangeName (name: String) {
        if let aes = AESS(key: self.keyData , iv: self.ivData) {
            let periodNameEncrypt = aes.encrypt(string: name)
            self.periodNameBase64 = (periodNameEncrypt?.base64EncodedString(options: NSData.Base64EncodingOptions()))!
        }
    }
    
    func secondResponse() {
//        DispatchQueue.main.async {
            let url2 = URL(string:"https://mobilechallange.veripark.com/api/stocks/list")!
            let session2 = URLSession.shared
            var request2 = URLRequest(url: url2)
            request2.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request2.addValue(self.authorization, forHTTPHeaderField: "X-VP-Authorization")
            request2.httpMethod = "POST"
            var params2 : [String : String]
            params2 = ["period" : self.periodNameBase64]
            do {
                request2.httpBody = try JSONSerialization.data(withJSONObject: params2, options: .prettyPrinted)
            }catch let error {
                print(error.localizedDescription)
            }
            let task = session2.dataTask(with: request2 as URLRequest, completionHandler: { data, response, error in
                guard error == nil else {
                    print(error?.localizedDescription ?? "ERROR")
                    return
                }
                guard let data = data else {
                    return
                }
                do {
                    print(self.authorization)
                    print(self.periodNameBase64)
                    if let json2 = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? AnyObject {
                        // print(json2)
                        let json2Stocks = json2["stocks"] as! [Dictionary<String,AnyObject>]
                        //                    print(json2Stocks)
                        
                        for stock in json2Stocks {
                            let symbolArray = stock as! [String:AnyObject]
                            self.symbolArrayInSymbolArray.append(symbolArray["symbol"] as! String)
                            self.symbolArrayInPriceArray.append(symbolArray["price"] as! Double)
                            self.symbolArrayInDifferenceArray.append(symbolArray["difference"] as! Double)
                            self.offerArray.append(symbolArray["offer"] as! Double)
                            self.volumeArray.append(symbolArray["volume"] as! Double)
                            self.bidArray.append(symbolArray["bid"] as! Double)
                            self.isDownArray.append(symbolArray["isDown"] as! Bool)
                            
                        }
                        
                        
                        //                    print(self.symbolArrayInSymbol)
                        
                        let keyData = Data(base64Encoded: self.aesKey)
                        let ivData = Data(base64Encoded: self.aesIV)
                        
                        if let abc = AESS(key: keyData! , iv: ivData!) {
                            
                            for item in self.symbolArrayInSymbolArray {
                                let symData = Data(base64Encoded: item)
                                let symDataString = abc.decrypt(data: symData)
                                self.symbolArrayInSymbolStr.append(symDataString!)
                                
                            }
                            
                            print(self.symbolArrayInSymbolStr)
                            StructView.symbolArrayInSymbolStr = self.symbolArrayInSymbolStr
                            StructView.priceArray = self.symbolArrayInPriceArray
                            StructView.differenceArray = self.symbolArrayInDifferenceArray
                            StructView.offerArray = self.offerArray
                            StructView.volumeArray = self.volumeArray
                            StructView.bidArray = self.bidArray
                            StructView.isDownArray = self.isDownArray
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



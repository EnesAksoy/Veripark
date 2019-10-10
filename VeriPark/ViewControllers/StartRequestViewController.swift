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
    //var periodNameBase64 : String = ""
    var symbol : String = ""
    var symbolArrayInSymbolArray: [String] = []
    var symbolArrayInPriceArray: [Double] = []
    var symbolArrayInDifferenceArray: [Double] = []
    var offerArray: [Double] = []
    var volumeArray: [Double] = []
    var bidArray: [Double] = []
    var symbolArrayInSymbolStr: [String] = []
    var isDownArray: [Bool] = []
    var idArray: [Int] = []
    
    var keyData: Data!
    var ivData: Data!
    
    var name : String = "all"
    
    var aaaa = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func startResponse() {
        
            let urlStart = URL(string:"https://mobilechallange.veripark.com/api/handshake/start")!
            let session = URLSession.shared
            var request = URLRequest(url: urlStart)
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
                    
                    StructView.keyData = self.keyData
                    StructView.ivData = self.ivData
                    StructView.authorization = self.authorization
                    
                   //self.periodChangeName(name: self.name)
                    //self.periodChangeName(name: self.name)
                    let valueess = self.periodChangeName(name: self.name)
                   
                    
                    
                    
                } catch let error {
                    print(error.localizedDescription)
                }
            })
            task.resume()
//        semaphore.wait()
//        secondResponse()
//        }
    }
    
    func periodChangeName (name: String) -> String {
        if let aes = AESS(key: StructView.keyData , iv: StructView.ivData) {
            let periodNameEncrypt = aes.encrypt(string: name)
            let periodNameBase64 = (periodNameEncrypt?.base64EncodedString(options: NSData.Base64EncodingOptions()))!
            self.aaaa = periodNameBase64
        }
         return aaaa
    }
    
    func secondResponse() {
//        DispatchQueue.main.async {
            let urlList = URL(string:"https://mobilechallange.veripark.com/api/stocks/list")!
            let session2 = URLSession.shared
            var request2 = URLRequest(url: urlList)
            request2.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request2.addValue(self.authorization, forHTTPHeaderField: "X-VP-Authorization")
            request2.httpMethod = "POST"
            var params2 : [String : String]
            let values = self.periodChangeName(name: name)
            params2 = ["period" : values]
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
                    //print(self.authorization)
                   // print(self.periodNameBase64)
                    if let json2 = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject] {
                       
                        let json2Stocks = json2["stocks"] as! [Dictionary<String,AnyObject>]
                        
                        for stock in json2Stocks {
                            let symbolArray = stock
                            self.symbolArrayInSymbolArray.append(symbolArray["symbol"] as! String)
                            self.symbolArrayInPriceArray.append(symbolArray["price"] as! Double)
                            self.symbolArrayInDifferenceArray.append(symbolArray["difference"] as! Double)
                            self.offerArray.append(symbolArray["offer"] as! Double)
                            self.volumeArray.append(symbolArray["volume"] as! Double)
                            self.bidArray.append(symbolArray["bid"] as! Double)
                            self.isDownArray.append(symbolArray["isDown"] as! Bool)
                            self.idArray.append(symbolArray["id"] as! Int)
                        }
                        let keyData = Data(base64Encoded: self.aesKey)
                        let ivData = Data(base64Encoded: self.aesIV)
                        
                        if let aes = AESS(key: keyData! , iv: ivData!) {
                            
                            for item in self.symbolArrayInSymbolArray {
                                let symData = Data(base64Encoded: item)
                                let symDataString = aes.decrypt(data: symData)
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
                            StructView.idArray = self.idArray
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



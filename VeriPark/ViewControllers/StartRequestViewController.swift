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
    var eee : String = ""
    var symbol : String = ""
    var symbolArrayInSymbol: [String] = []
    var symbolArrayInSymbolStr: [String] = []
    var returnFirst: [String] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func startResponse() {
        DispatchQueue.main.async {
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
                    let keyData = Data(base64Encoded: self.aesKey)
                    let ivData = Data(base64Encoded: self.aesIV)
                    
                    
                    if let abc = AESS(key: keyData! , iv: ivData!) {
                        let asd = abc.encrypt(string: "all")
                        self.eee = (asd?.base64EncodedString(options: NSData.Base64EncodingOptions()))!
                    }
                } catch let error {
                    print(error.localizedDescription)
                }
            })
            task.resume()
        }
    }
    
    func secondResponse() {
        DispatchQueue.main.async {
            let url2 = URL(string:"https://mobilechallange.veripark.com/api/stocks/list")!
            let session2 = URLSession.shared
            var request2 = URLRequest(url: url2)
            request2.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request2.addValue(self.authorization, forHTTPHeaderField: "X-VP-Authorization")
            request2.httpMethod = "POST"
            var params2 : [String : String]
            params2 = ["period" : self.eee]
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
                    print(self.eee)
                    if let json2 = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? AnyObject {
                        // print(json2)
                        let json2Stocks = json2["stocks"] as! [Dictionary<String,AnyObject>]
                        //                    print(json2Stocks)
                        
                        for sss in json2Stocks {
                            let symbolArray = sss as! [String:AnyObject]
                            self.symbolArrayInSymbol.append(symbolArray["symbol"] as! String)
                        }
                        
                        //                    print(self.symbolArrayInSymbol)
                        
                        let keyData = Data(base64Encoded: self.aesKey)
                        let ivData = Data(base64Encoded: self.aesIV)
                        
                        if let abc = AESS(key: keyData! , iv: ivData!) {
                            
                            for avd in self.symbolArrayInSymbol {
                                let symData = Data(base64Encoded: avd)
                                let symDataString = abc.decrypt(data: symData)
                                self.symbolArrayInSymbolStr.append(symDataString!)
                                
                            }
                            
                            print(self.symbolArrayInSymbolStr)
                            StructView.symbolArrayInSymbolStr = self.symbolArrayInSymbolStr
                            
                            //                    let cdb = abc.decrypt(data: asd)
                            //                    let base64 = "HQGJ2Pdvxw+3HBA1RY2cIQ=="
                            //                    let data = Data(base64Encoded: base64)
                            //                    let cdb2 = abc.decrypt(data: data)
                            //                    print("enoli")
                            //                    print(cdb as Any)
                        }
                        
                        //                    self.symbol = json["symbol"] as! String
                        //                    print("symbol =====    \(self.symbol)")
                    }
                }
                catch let error {
                    print(error.localizedDescription)
                }
            })
            task.resume()
        }
    }
}



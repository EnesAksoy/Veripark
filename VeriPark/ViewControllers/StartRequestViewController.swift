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
                
                
                
                
                if let abc = AES(key: self.aesKey , iv: self.aesIV) {
                    print(abc.encrypt(string: "all")!)
                    let asd = abc.encrypt(string: "all")
                    let string = String(bytes: asd!, encoding: .utf8)
                    print(string)
                }
                
                
                
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
    }
}



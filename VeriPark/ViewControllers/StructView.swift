//
//  StructView.swift
//  VeriPark
//
//  Created by ENES AKSOY on 9.10.2019.
//  Copyright © 2019 ENES AKSOY. All rights reserved.
//

import Foundation

struct StructView {
    static var symbolArrayInSymbolStr: [String]!
    static var priceArray: [Double]!
    static var differenceArray: [Double]!
    static var offerArray: [Double]!
    static var volumeArray: [Double]!
    static var bidArray: [Double]!
    static var isDownArray: [Bool]!
    static var idArray: [Int]!
    
    static var selectedId : Int!
    
    static var keyData : Data!
    static var ivData : Data!
    static var authorization: String!
    static var secondApiEnter: NSNumber = 0
    
    static var periodName: String!
    
    static var requestSecond: URLRequest!
}

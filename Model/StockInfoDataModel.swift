//
//  StockInfo.swift
//  StockEMC2_new
//
//  Created by Balagurubaran Kalingarayan on 11/20/18.
//  Copyright © 2018 iAppsCrazy. All rights reserved.
//

import Foundation

struct StockInfoDataModel {
    var label1:labelValue = labelValue()
    var label2:labelValue = labelValue()
    var index:Int = 0
}

struct labelValue {
    var key: String?
    var value: String?
    var symbol:String?
}

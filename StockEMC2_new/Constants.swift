//
//  Constants.swift
//  StockEMC2_new
//
//  Created by Balagurubaran Kalingarayan on 11/17/18.
//  Copyright © 2018 iAppsCrazy. All rights reserved.
//

import Foundation
import UIKit

var selectedStockInfo:shareBasicInfo?
let baseColor = UIColor.white
var stockInfoElement_live:[StockInfoDataModel]?
var statsBasic:[StockInfoDataModel]?
var statsBasic1:[StockInfoDataModel]?

enum MenuListEnum:String {
    case all = "All"
    //case watchList = "Watchlist"
    case dividend  = "Dividend"
    case profit = "Profit"
    case loss   = "Loss"
    case search = "Search"
    case sector = "Sector"
}
let mainMenuItems = ["All","Dividend","Profit","Loss","Search"]

enum SecondaryFilter:String {
    case Latest = "Latest"
    case PriceUp = "High to Low"
    case PriceDown = "Low to High"
}

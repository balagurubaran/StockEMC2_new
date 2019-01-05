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
var stockInfoElement_Day:[StockInfoDataModel]?
var statsBasic:[StockInfoDataModel] = [StockInfoDataModel]()
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

let tc = "</p>App  provides financial data and technical analysis on stocks. We shall not be held liable to and shall not accept any liability, obligation or responsibility whatsoever for any loss or damage for your finances or personal information.</p> <p>All users should consult with their financial advisor before buying or selling any shares. Users should not firmly base their final investment decision upon Application. By accessing our Application you agree and are held liable for your own investment decisions.</p> <p>Different types of investments involve varying degrees of risk, and there can be no assurances that any specific investments will either be suitable or profitable for the App user investment portfolio. No user should assume that any information presented and/or made available on this Apps serves as the receipt of, or a substitute for, personalized individual advice from the advisor or any other professional investor.</p> <p>The information contained on this application is provided for informational purposes only and contains no investment advice or recommendations to buy or sell any specific shares. This is not an offer or solicitation for any particular trading strategy, or confirmation of any transaction.</p> <p>The owners of this Application are not liable for any errors, omissions or misstatements. Any performance data quoted represents past performance and that past performance is not a guarantee of future results. Investments always have a degree of risk, including the potential risk of the loss of the investor’s entire principal.</p> <p>There is no guarantee against any loss.</p> <p>Thank you iextrading.com for the historical data</p>"

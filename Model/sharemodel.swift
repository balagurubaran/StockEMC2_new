//
//  sharemodel.swift
//  PennyPlus
//
//  Created by Balagurubaran Kalingarayan on 11/26/17.
//  Copyright © 2017 Balagurubaran Kalingarayan. All rights reserved.
//

import Foundation
import UIKit

let red = UIColor.init(red: 255.0/255.0, green: 38.0/255.0, blue: 0.0, alpha: 1.0)

class ShareHistory{
    var category:String?
    var low:Float?
    var high:Float?
    var precentage:Float?
    var price:Float?
    var open:Float?
    var lastUpdatedDate:String?
    var priceDifference:Float?
    
}

class Financial{
    var revenue:String?
    var earnings:String?
    var year:String = String()
}

struct KeyState: Codable{
    var marketcap:Double?
    var dividendYield:Float?
    var beta:Float?
    var shortratio:Float?
    var priceToBook:Float?
    var EBITDA:Double?
    var ROC:Float?
    var ROA:Float?
    var grossProfit:Double?
    var profitMargin:Float?
    var currentDebt:Double?
}

class dividends{
    var date:String?
    var price:Float?
}

class shareBasicInfo {
    var shareName:String?
    var companyName:String?
    var sharePriceInfo:Share?
    var backGroundColor:UIColor = UIColor.white
}

class Share{
    var shareSector:String = ""
    var currentPrice:Float?
    var targetPrice:Float?
    var targetPrecentage:Float?
    var dividendsDate:String?
    var dividendsPrice:Float?
    var actualPrice:Float?
    var watchListCount:Int?
    
    var avgExpectedEPS:Float?
    var avgActualEPS:Float?
    
    var weekslow_52:Float = Float()
    var weeklowpercentage_52:Float = Float()
    var comments = "Comments not added"
    
    var isTargetReached : Bool = false
    var addedstockDate:Date?
    var targetreacheddate:Date?
    
    var isNew:Bool? {
        get {
            return (addedstockDate!.addDay(n: 2) >= Date() ) ? true:false
        }
    }
    
    var week:ShareHistory?
    var day:ShareHistory?
    var live:ShareHistory?
    var month:ShareHistory?
    
    var earningCall:EarningCall?
    var dividend:dividends?
    
    var currencySympol:String = "$"
    
    var color : UIColor {
        get {
            if(isTargetReached ){
                return UIColor.init(red: 207/255.0, green: 207/255.0, blue: 142/255.0, alpha: 0.5)
            }else if (Float(targetPrecentage!) < 0.0 ){
                return UIColor.init(red: 255.0/255.0, green: 38.0/255.0, blue: 0.0, alpha: 1.0)
            }else if Float(targetPrecentage!) < 20.0 {
                return  UIColor.init(red:200/255.0, green:189/255.0, blue:105/255.0, alpha: 1.0)
            }else{
                return UIColor.init(red: 27.0/255.0, green: 178.0/255.0, blue: 47.0/255.0, alpha: 1.0)
            }
        }
    }
    
    var lastUpdatedDate:String?
}

class EarningCall{
    var lastCall:String?
    var nextCall:String?
}

class EPS {
    var year: String = ""
    var actual: Double?
    var estimated: Double?
    var Q:String = "Q1"
    var index = 0
    var fiscalEndDate:String = ""
}

struct Sale {
    //var month: String
    var year: Double
    var revenue: Double
    var earnings: Double
}

class TradeVolme{
    var xValue:String?
    var Volume:Int?
}


// New Data Model

struct version1Stats:Decodable{
    var keystats:String?
    var yeardiv:String?
    var eps:String?
    var lastDayTrade:String?
    var tenyearFinDetail:String?
}

typealias Version1YearDiv = [Version1YearDivElement]

struct Version1YearDivElement: Codable {
    let exDate, paymentDate, recordDate, declaredDate: String
    let amount: Double
    let flag, currency, description, frequency: String
    let date: String
}

struct PriceHistory: Codable {
    let chart: [Chart]
}

struct Chart: Codable {
    var date, minute, label: String?
    var high, low, average: Double?
    var volume: Int?
    var notional: Double?
    var numberOfTrades: Int?
    var marketHigh, marketLow, marketAverage: Double?
    var marketVolume: Int?
    var marketNotional: Double?
    var marketNumberOfTrades: Int?
    var chartOpen, close, marketOpen, marketClose: Double?
    var changeOverTime: Double?
    var marketChangeOverTime: Double?
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(
            keyedBy: CodingKeys.self)
        
        date = try container.decode(String?.self, forKey: .date)
        minute = try container.decode(String?.self, forKey: .minute)
        label = try container.decode(String?.self, forKey: .label)
        high = try container.decode(Double?.self, forKey: .high)
        low = try container.decode(Double?.self, forKey: .low)
        average = try container.decode(Double?.self, forKey: .average)
        notional = try container.decode(Double?.self, forKey: .notional)
        numberOfTrades = try container.decode(Int?.self, forKey: .numberOfTrades)
        marketHigh = try container.decode(Double?.self, forKey: .marketHigh)
        marketLow = try container.decode(Double?.self, forKey: .marketHigh)
        marketAverage = try container.decode(Double?.self, forKey: .marketHigh)
        marketVolume = try container.decode(Int?.self, forKey: .marketVolume)
        volume = try container.decode(Int?.self, forKey: .volume)
        marketNotional = try container.decode(Double?.self, forKey: .marketNotional)
        marketNumberOfTrades = try container.decode(Int?.self, forKey: .marketNumberOfTrades)
        chartOpen = try container.decode(Double?.self, forKey: .chartOpen)
        close = try container.decode(Double?.self, forKey: .close)
        marketOpen = try container.decode(Double?.self, forKey: .marketOpen)
        marketClose = try container.decode(Double?.self, forKey: .marketClose)
        changeOverTime = try container.decode(Double?.self, forKey: .changeOverTime)
        marketChangeOverTime = try container.decode(Double?.self, forKey: .marketChangeOverTime)
        
    }
    enum CodingKeys: String, CodingKey {
        case date, minute, label, high, low, average, volume, notional, numberOfTrades, marketHigh, marketLow, marketAverage, marketVolume, marketNotional, marketNumberOfTrades
        case chartOpen = "open"
        case close, marketOpen, marketClose, changeOverTime, marketChangeOverTime
    }
}

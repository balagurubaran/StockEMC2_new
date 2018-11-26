//
//  StockInfoDataHandler.swift
//  StockEMC2_new
//
//  Created by Balagurubaran Kalingarayan on 11/20/18.
//  Copyright © 2018 iAppsCrazy. All rights reserved.
//

import Foundation

class StockInfoDataHandler{
    
    class func setTheLivePriceInfo(){
        var view1 = StockInfoDataModel()
        if let open = selectedStockInfo?.sharePriceInfo?.live?.open , let close = selectedStockInfo?.sharePriceInfo?.live?.price {
            view1.key = "Open"
            view1.value = "\(open)"
            
            view1.key1 = "Close"
            view1.value1 = "\(close)"
            stockInfoElement_live = [view1]
        }
        
        var view2 = StockInfoDataModel()
        if let high = selectedStockInfo?.sharePriceInfo?.live?.high , let low = selectedStockInfo?.sharePriceInfo?.live?.low {
            view2.key = "Low"
            view2.value = "\(low)"
            
            view2.key1 = "High"
            view2.value1 = "\(high)"
            stockInfoElement_live?.append(view2)
        }
    }
    
    class func setTheStats(){
        var view1 = StockInfoDataModel()
        if let value = selectedStockInfo?.sharePriceInfo?.avgExpectedEPS , let value1 = selectedStockInfo?.sharePriceInfo?.avgActualEPS {
            view1.key = "Exp ESP"
            view1.value = "\(value)"
            
            view1.key1 = "Act ESP"
            view1.value1 = "\(value1)"
            statsBasic = [view1]
        }
        
        var view2 = StockInfoDataModel()
        if let value = selectedStockInfo?.sharePriceInfo?.dividendsPrice , let value1 = selectedStockInfo?.sharePriceInfo?.dividendsDate {
            view2.key = "last Div"
            view2.value = "\(value)"
            
            view2.key1 = "Date"
            view2.value1 = value1
            statsBasic?.append(view2)
        }
    }
    
    class func setTheStats1(){
        
        var view1 = StockInfoDataModel()
        view1.key = "Beta"
        view1.value = "\(keyState.beta)"
        
        view1.key1 = "Book Val"
        view1.value1 = "\(keyState.priceToBook)"
        statsBasic1 = [view1]
        
        var view2 = StockInfoDataModel()
        view2.key = "Div Yield"
        view2.value = "\(keyState.dividendyield)"
        
        view2.key1 = "Short Ratio"
        view2.value1 = "\(keyState.shortratio)"
        statsBasic1?.append(view2)
        
        var view3 = StockInfoDataModel()
        view3.key = "ROIC"
        view3.value = "\(keyState.roic)"
        
        view3.key1 = "ROA"
        view3.value1 = "\(keyState.roa)"
        statsBasic1?.append(view3)
    }
}

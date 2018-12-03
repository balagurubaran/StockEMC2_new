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
        stockInfoElement_live?.removeAll()
        var view1 = StockInfoDataModel()
        if let open = selectedStockInfo?.sharePriceInfo?.live?.open , let close = selectedStockInfo?.sharePriceInfo?.live?.price {
            view1.label1.key = "Open"
            view1.label1.value = "$\(open)"
            
            view1.label2.key = "Close"
            view1.label2.value = "$\(close)"
            stockInfoElement_live = [view1]
        }
        
        var view2 = StockInfoDataModel()
        if let high = selectedStockInfo?.sharePriceInfo?.live?.high , let low = selectedStockInfo?.sharePriceInfo?.live?.low {
            view2.label1.key = "Low"
            view2.label1.value = "$\(low)"
            
            view2.label2.key = "High"
            view2.label2.value = "$\(high)"
            stockInfoElement_live?.append(view2)
        }
    }
    
    class func setTheStats(){
        
        statsBasic.removeAll()
        guard let keyState = DataHandler.getTheSelectedStockInfoForView2() else{
            return
        }
        var view1 = StockInfoDataModel()
        let index = EPSData.count - 1
    
        if index >= 0 {
            view1.label1.key = "Expected ESP"
            if let value = EPSData[index].estimated {
                view1.label1.value = "\(value)"
            }else{
                view1.label1.value = "N/A"
            }
            
            
            view1.label2.key = "Actual ESP"
            if let value = EPSData[index].actual {
                view1.label2.value = "\(value)"
            }else{
                view1.label2.value = "N/A"
            }
            statsBasic = [view1]
        }
        
        var view3 = StockInfoDataModel()
        if let value = keyState.marketcap {
            view3.label1.key = "Market Cap"
            view3.label1.value = "\(Utility.convertIntToDollar(number: value))"
        }
        
        if let value = keyState.ebitda {
            view3.label2.key = "EBITDA"
            view3.label2.value = "\(Utility.convertIntToDollar(number: value))"
        }
        statsBasic.append(view3)
        
        var view5 = StockInfoDataModel()
        view5.label1.key = "Dept"
        if let debt = keyState.debt {
            view5.label1.value = "\(Utility.convertIntToDollar(number: debt))"
        }else{
            view5.label1.value = "N/A"
        }
        
        view5.label2.key = ""
        view5.label2.value = ""
        statsBasic.append(view5)
        
        var view4 = StockInfoDataModel()
        view4.label1.key = "Gross profit"
        if let grossprofit = keyState.grossprofit {
            view4.label1.value = "\(Utility.convertIntToDollar(number: grossprofit))"
        }else{
            view4.label1.value = "N/A"
        }
        
        view4.label2.key = "Profit margin"
        if let netprofitmargin = keyState.netprofitmargin {
            view4.label2.value = "\(Utility.convertIntToDollar(number: netprofitmargin))"
        }else{
            view4.label2.value = "N/A"
        }
        statsBasic.append(view4)
        
        var view2 = StockInfoDataModel()
        if let value = selectedStockInfo?.sharePriceInfo?.dividendsPrice , let value1 = selectedStockInfo?.sharePriceInfo?.dividendsDate {
            view2.label1.key = "Dividend"
            view2.label1.value = "$\(value)"
            
            view2.label2.key = "Date"
            view2.label2.value = value1
            statsBasic.append(view2)
        }
    }
    
    class func setTheStats1(){
        statsBasic1?.removeAll()
        guard let keyState = DataHandler.getTheSelectedStockInfoForView2() else{
            statsBasic1 = nil
            return
        }
        var view1 = StockInfoDataModel()
        view1.label1.key = "Beta"
        if let beta = keyState.beta {
            view1.label1.value = "\(beta)"
        }else{
            view1.label1.value = "N/A"
        }
        
        view1.label2.key = "Price/Book"
        if let priceToBook = keyState.priceToBook {
            view1.label2.value = "\(priceToBook)"
            view1.label2.symbol = "x"
        }else{
            view1.label2.value = "N/A"
        }
        
        statsBasic1 = [view1]
        
        var view2 = StockInfoDataModel()
        view2.label1.key = "Div yield"
        if let dividendyield = keyState.dividendyield {
            view2.label1.value = "\(dividendyield)"
            view2.label1.symbol = "%"
        }else{
            view2.label1.value = "N/A"
        }
        
        view2.label2.key = "Short ratio"
        if let shortratio = keyState.shortratio {
            view2.label2.value = "\(shortratio)"
        }else{
            view2.label2.value = "N/A"
        }
        statsBasic1?.append(view2)
        
        var view3 = StockInfoDataModel()
        view3.label1.key = "ROC"
        if let ROC = keyState.ROC{
            view3.label1.value = "\(ROC)"
            view3.label1.symbol = "%"
        }else{
            view3.label1.value = "N/A"
        }
        
        view3.label2.key = "ROA"
        if let roa = keyState.ROA{
            view3.label2.value = "\(roa)"
            view3.label2.symbol = "%"
        }else{
            view3.label2.value = "N/A"
        }
        statsBasic1?.append(view3)
    }
}


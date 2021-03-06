//
//  JSONParser.swift
//  Gradient
//
//  Created by Balagurubaran Kalingarayan on 11/19/17.
//  Copyright © 2017 Balagurubaran Kalingarayan. All rights reserved.
//

import Foundation
import SwiftyJSON
//import SectorCard

fileprivate var stockBasicInfo:[shareBasicInfo] = [shareBasicInfo]()
fileprivate var nonFilterStockBasicInfo:[shareBasicInfo] = [shareBasicInfo]()
//fileprivate let shareDetail =  Share()

var financialData:[Financial] = [Financial]()

var tradeVolumes:[TradeVolme] = [TradeVolme]()
//var sectorDetail:[Sector]?

var appStatsModel = AppStatsModel()

var EPSData:[EPS] = [EPS]()

var founderInvestment:Float = 0
var foundedProfitORLoss:Float = 0
private var keyState:KeyState?
var watchList:Array = [String]()

var selectedIndex = 0;
var searchString = ""


// NewsFeed
//var allNewsFeed = [NewsCardDataModel]()

//struct Sector{
//    var sectorName:String?
//    var allStockCount:String?
//    var profitStockCount:String?
//    var lossStockCount:String?
//}

struct revenue_earning{
    var amount:String
    var year:String
}

class DataHandler{
    
    static var yearDividend:Version1YearDiv?
    static var priceHistory:PriceHistory?
    // mainMenuStickInfo Start
    class func parseTheStockBasicDetail(data:Data){
        stockBasicInfo.removeAll()
        do{
            let allStockBasicInfo = try JSON(data: data)
            for eachStockInfo in allStockBasicInfo {
                if let priceInfor = DataHandler.parseTheCurrnetPriceInfo(priceInfo: eachStockInfo.1) {
                    let stock = shareBasicInfo()
                    stock.shareName = eachStockInfo.1["stockid"].stringValue
                    stock.companyName = eachStockInfo.1["stockname"].stringValue
                    stock.sharePriceInfo = priceInfor
                    stockBasicInfo.append(stock)
                }
            }
            nonFilterStockBasicInfo = stockBasicInfo
        }catch let error{
            print(error.localizedDescription)
        }
    }
    
    class func parseTheApplicationStats(data:Data){
        appStatsModel = AppStatsModel.init()
        do{
            let decoder = JSONDecoder()
            appStatsModel = try decoder.decode(AppStatsModel.self, from: data)
            
        }catch let error{
            let backToString = String(data: data, encoding: String.Encoding.utf8) as String?
            print("appStatsModel Error", error.localizedDescription)
        }
    }
    
    class func getTheMainStockDetail()->[shareBasicInfo] {
//        if(SearchBar.isSearchBarLifeTime){
//            var filterted = isWatchList ?  DataHandler().frameWatchList() : stockBasicInfo
//            
//            filterted = filterted.filter{ ($0.shareName?.contains(getSearchString()))!}
//            if(filterted.count == 0){
//                //isSearchFailed = true
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateTheWatchListStatus"), object: nil, userInfo: nil)
//                isWatchList = false
//                SearchBar.isSearchBarLifeTime = false
//                Utility.showMessage(message: "Stock not listed")
//            }
//            return filterted.count > 0 ? filterted:stockBasicInfo
//        }else if isWatchList{
//            return DataHandler().frameWatchList()
//        }
        return stockBasicInfo;
    }
    
    class func getTheSpecificStockFromshareBasicInfo(stockName:String)->shareBasicInfo?{
        let selected = stockBasicInfo.filter{$0.shareName == stockName}
        if selected.count > 0 {
            return selected[0]
        }
        return nil
    }
    
    func frameWatchList()->[shareBasicInfo]{
        var StockDetail:[shareBasicInfo] = [shareBasicInfo]()
        if let watchList = userDefaults.array(forKey: "watchlist") as? [Dictionary<String,String>] {
            for eachShare in watchList {
                let share = shareBasicInfo()
                share.shareName = eachShare["shareName"]
                share.companyName = eachShare["companyName"]
                StockDetail.append(share)
            }
        }
        return StockDetail
    }
    
    class func getTheStats()->AppStatsModel{
        return appStatsModel
    }
    class func getTheMainMenuStocksCount()->Int{
        return self.getTheMainStockDetail().count
    }
    
    class func getIndexDataFromTheMenuStock(index:Int)->shareBasicInfo{
        let stockDetail = self.getTheMainStockDetail()
        return stockDetail[index]
    }
    
    class func setSelectedIndex(index:Int){
        selectedIndex = index
    }
    
    class func setSearchString(searchValue:String){
        searchString = searchValue
    }
    
    class func getSearchString()->String{
        return searchString
    }
    
    static var selectedSector = ""
    class func filterTheMenu(status:MenuListEnum,filter:String){
        if status.rawValue == "Sector"{
            stockBasicInfo = nonFilterStockBasicInfo.filter{$0.sharePriceInfo?.shareSector.lowercased() == selectedSector.lowercased()}
            secondaryFilter(filter:filter)
            return
        }
        let value:Float = 0.0
        switch status {
        case .all:
                stockBasicInfo = nonFilterStockBasicInfo
        case .dividend:
            stockBasicInfo = nonFilterStockBasicInfo.filter{$0.sharePriceInfo?.dividendsPrice != nil &&  ($0.sharePriceInfo?.dividendsPrice)! > value}
        case .profit:
            stockBasicInfo = nonFilterStockBasicInfo.filter{$0.sharePriceInfo?.live?.priceDifference != nil && ($0.sharePriceInfo?.live?.priceDifference)! >= value}
        case .loss:
            stockBasicInfo = nonFilterStockBasicInfo.filter{$0.sharePriceInfo?.live?.priceDifference != nil && ($0.sharePriceInfo?.live?.priceDifference)! < value}
        case .search:
            stockBasicInfo = nonFilterStockBasicInfo.filter{$0.shareName != nil && $0.shareName == searchString}
        default:
            break
        }
        secondaryFilter(filter:filter)
        
    }
    
    class func secondaryFilter(filter:String){
        let enumValue:SecondaryFilter? = SecondaryFilter(rawValue: filter)
        
        switch enumValue {
        case .Latest?:
            stockBasicInfo = stockBasicInfo.sorted(by: { ($0.sharePriceInfo?.addedstockDate)!.compare(($1.sharePriceInfo?.addedstockDate)!) == .orderedDescending })
        case .PriceDown?:
            stockBasicInfo = stockBasicInfo.sorted{($0.sharePriceInfo?.live?.price)! < ($1.sharePriceInfo?.live?.price)!}
        case .PriceUp?:
            stockBasicInfo = stockBasicInfo.sorted{($0.sharePriceInfo?.live?.price)! > ($1.sharePriceInfo?.live?.price)!}
        default:
          break
        }
    }
    
    // mainMenuStickInfo end
    
    class func parseTheCurrnetPriceInfo(priceInfo:JSON)->Share?{
        
        do{
            let shareDetail =  Share()
            var eachShare = priceInfo
            let localLive = eachShare["live"].dictionaryValue
            shareDetail.live = parseHistory(value: localLive)
            
            let localDay = eachShare["day"].dictionaryValue
            shareDetail.day = parseHistory(value: localDay)
            
            if let currentPrice  = shareDetail.live?.price {
                shareDetail.currentPrice = currentPrice
                
                shareDetail.actualPrice = eachShare["actualPrice"].floatValue
                shareDetail.bestPrice = eachShare["bestPrice"].floatValue
             
   
                shareDetail.avgActualEPS = eachShare["avgActualEPS"].floatValue
                shareDetail.avgExpectedEPS = eachShare["avgExpectedEPS"].floatValue
                
                shareDetail.weekslow_52 = eachShare["weeklow_52"].floatValue
                shareDetail.isTargetReached = eachShare["isTargetReached"].boolValue
                shareDetail.lastUpdatedDate =  shareDetail.live?.lastUpdatedDate//?.formatDateString()
                
                shareDetail.watchListCount =  eachShare["watchlistCount"].intValue
                
                
                shareDetail.comments = eachShare["comments"].stringValue
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = appDateFormat
                
                if let sector =  eachShare["sector"].string{
                    shareDetail.shareSector = sector
                }
                
                if let addedDate = (eachShare["addedstockDate"].stringValue).StringToDate() {
                    shareDetail.addedstockDate = addedDate
                }
                
                if(shareDetail.weekslow_52 > 0.0){
                    shareDetail.weeklowpercentage_52 = (currentPrice/shareDetail.weekslow_52) * 100
                }
                
                shareDetail.dividendsPrice = 0.0
                
                if ((eachShare["lastDivamount"].floatValue) > 0){
                    shareDetail.dividendsPrice = eachShare["lastDivamount"].floatValue
                    shareDetail.dividendsDate = (eachShare["lastdivdate"].string)?.formatDateString()
                    
                    
                    let date = dateFormatter.date(from: shareDetail.dividendsDate!)
                    
                    shareDetail.dividendsDate = dateFormatter.string(from: date!)//String.init(describing: date)
                    
                }
                
                shareDetail.currencySympol = "$";//eachShare.1["currnecysymbol"].string
                
                shareDetail.targetPrice = eachShare["targetprice"].floatValue
                shareDetail.targetPrecentage =  ((shareDetail.targetPrice! - shareDetail.currentPrice!)/shareDetail.currentPrice! )*100//eachShare.1["targetprecentage"].floatValue
                
                let QReportDate:EarningCall = EarningCall()
                for (key,value) in eachShare["earningcall"].dictionaryValue {
                    if key == "last"{
                        QReportDate.lastCall = value.stringValue
                    }else{
                        QReportDate.nextCall = value.stringValue
                    }
                }
                shareDetail.earningCall = QReportDate
                return shareDetail
            }
        }catch let error{
            //print(error.localizedDescription)
            return nil
        }
        return nil
    }
    
    fileprivate class func parseHistory(value:[String:JSON])->ShareHistory{
        let history:ShareHistory = ShareHistory()
        history.low = value["low"]?.floatValue
        history.high = value["high"]?.floatValue
        history.price = value["price"]?.floatValue
        history.open = value["open"]?.floatValue
        history.priceDifference = value["priceDifference"]?.floatValue
        let dateValue = value["lastPriceUpdated"]?.string
        history.lastUpdatedDate = dateValue//?.formatDateString()
        // print(history.open!);
        //history.precentage =  ((currentPrice-history.open!) / history.open!) * 100.0
        return history
    }
    
    //Current Market price view info End
    
    
    //Stock's KeyState start
    
    class func getTheSelectedStockInfoForView2()->KeyState?{
        return keyState
    }
    
    class func parseStats(data:Data){
        do{
            let states:version1Stats = try JSONDecoder.init().decode(version1Stats.self, from: data)
            if let keyStats = states.keystats{
                let data = Data(keyStats.utf8)
                parseKeyState(data: data)
            }
            
            if let eps = states.eps {
                let data = Data(eps.utf8)
                parseTheEPSData(data: data)
            }
            
            if let yeardiv = states.yeardiv {
                let data = Data(yeardiv.utf8)
                parserYearDividend(data: data)
            }
            
            if let lastDayTrade = states.lastDayTrade{
                //lastDayTrade = lastDayTrade.replacingOccurrences(of: "null", with: "nil")
                parseThe30Data(data: Data(lastDayTrade.utf8))
            }
            
            if let tenyearFinDetail = states.tenyearFinDetail {
                let data = Data(tenyearFinDetail.utf8)
                parseTheRevenueData(data: data)
            }
        }catch let error{
            print(error.localizedDescription)
        }
    }
    
    class func parseKeyState(data:Data){
        do{
            keyState = try JSONDecoder.init().decode(KeyState.self, from: data)
        }catch let error{
            print(error.localizedDescription)
        }
        
    }
    //Stock's keystate End
    
    // Year dividend Start
    class func parserYearDividend(data:Data){
        do{
            yearDividend = try JSONDecoder.init().decode(Version1YearDiv.self, from: data)
        }catch let error{
            print(error.localizedDescription)
        }
    }
    // year Divdend End
    
    
    //Stock's Financial Data start
    
    class func parseTheEPSData(data:Data){
        EPSData.removeAll()
        do{
            EPSQLabels.removeAll()
            var index = 0
            let json = try JSON(data: data)
            for eachDetail in json {
                let Allearnings = eachDetail.1
                //let Allearnings = eachFinacialData["earnings"].arrayValue
                
                for data in Allearnings{
                    let epsValue = EPS.init()
                    
                    
                    epsValue.year =  data.1["fiscalPeriod"].stringValue
                    if(epsValue.year.count > 0){
                        epsValue.actual =  data.1["actualEPS"].doubleValue
                        epsValue.Q  = String(epsValue.year.dropLast(epsValue.year.count - 2))
                        var dateValue = data.1["fiscalEndDate"].stringValue
                        epsValue.fiscalEndDate =  dateValue.formatDateString()
                        epsValue.index =  index
                        epsValue.estimated =  data.1["consensusEPS"].doubleValue
                        if(self.checkTheEPSQValide(value: epsValue)){
                            EPSQLabels.append(epsValue.Q)
                            EPSData.append(epsValue)
                        }
                        index = index + 1
                    }
                    
                }
                
            }
        }catch let error{
            print(error.localizedDescription)
        }
        
    }
    
    class func checkTheEPSQValide(value:EPS)->Bool{
        let split = value.year.split(separator: " ")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = appDateFormat //Your New Date format as per requirement change it own
        let newDate = dateFormatter.date(from: value.fiscalEndDate)
        
        //let date = newDate?.getdate()
        let Year = (newDate?.getYear())!
        let month = Int((newDate?.getMonth())!)!
        
        if(split[1] != Year){
            if(split[0] == "Q4" && (month >= 11 || month <= 2)){
                return true
            }
            return false
        }
        
        return true
    }
    
    class func parseTheRevenueData(data:Data){
        financialData.removeAll()
        var revenue:[revenue_earning] = [revenue_earning]()
        var earning:[revenue_earning] = [revenue_earning]()
        do{
            let json = try JSON(data: data)
            
            
            for eachShare in json {
                
                let eachFinacialData = eachShare.1
                let id = eachFinacialData["id"].string
                switch id {
                case Income.Revenues.rawValue?:
                    for (value,key) in eachFinacialData {
                        if (value != "id") {
                            var localValue = value
                            let eachYear = revenue_earning(amount:key.stringValue , year: localValue.formatDateString())
                            revenue.append(eachYear)
                        }
                    }
                    
                case Income.Earnings.rawValue?:
                    for (value,key) in eachFinacialData {
                        if (value != "id") {
                            var localValue = value
                            let eachYear = revenue_earning(amount:key.stringValue , year: localValue.formatDateString())
                            earning.append(eachYear)
                        }
                    }
                    
                default:
                    break
                }
            }
        }catch let error{
            print(error.localizedDescription)
        }
        revenue = revenue.sorted{($0.year < $1.year)}
        earning = earning.sorted{($0.year < $1.year)}

        if (revenue.count > 5){
            revenue = Array(revenue.dropFirst(revenue.count - 5))
            earning = Array(earning.dropFirst(earning.count - 5))
        }

        if(revenue.count > 0){
            
            for eachyear in revenue{
                let eachFinacialData = Financial()
                eachFinacialData.revenue = eachyear.amount
                eachFinacialData.year = eachyear.year
                let filterEarning = earning.filter { ($0.year == eachFinacialData.year)}
                if filterEarning.count > 0 {
                    eachFinacialData.earnings = filterEarning[0].amount
                    financialData.append(eachFinacialData)
                }
                
            }
        }
        
    }
    
    class func removeTheSameYearfromdata(data:revenue_earning)->Bool{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = appDateFormat //Your New Date format as per requirement change it own
        let newDate = dateFormatter.date(from: data.year)
        return true//month > 10 ? true:false
    }
    
    //Stock's Financial Data End
    
    // WatchList Start
    class func getTheSelectedIndex()->Int{
        //return selectedIndex;
        let watchList = self.getThewatchlist()
        if watchList.count > 0{
            return selectedIndex
        }else {
            return 0;
        }
    }
    
    
    class func getThewatchlist()->[Dictionary<String,String>]{
        if let watchList = userDefaults.array(forKey: "watchlist") as? [Dictionary<String,String>] {
            return watchList
        }
        return []
    }
    
    class func isShareExitinWatchList(shareName:String)->Bool {
        let watchList = self.getThewatchlist()
        if watchList.count > 0{
            return watchList.filter{$0["shareName"] == shareName}.count > 0 ? true : false
        }else {
            return false;
        }
    }
    
    //Watchlist End
    
    //30 day Data Start
    class func parseThe30Data(data:Data){
        do{
            priceHistory = try JSONDecoder.init().decode(PriceHistory.self, from: data)
        }catch let error{
            print(error.localizedDescription)
        }
    }
    
    class func consolidatedTradeVolume()->[TradeVolme]?{
        var sumOfTrade = 0
        tradeVolumes.removeAll()
        guard let chartValue = priceHistory?.chart else{
            return tradeVolumes
        }
        for (index,value) in chartValue.enumerated() {
            if index % 30 == 0 && index > 0{
                let TV = TradeVolme()
                TV.xValue = value.minute
                TV.Volume = sumOfTrade
                tradeVolumes.append(TV)
                sumOfTrade = 0
                print(TV.xValue);
            }else if let volume = value.volume {
                sumOfTrade = sumOfTrade + volume
            }
        }
        return tradeVolumes
    }

    //30 day data END
    
    // Sectore Information start
    
    class func setAllSectorDetails(){
//        var sectorList = stockBasicInfo.compactMap{
//            $0.sharePriceInfo?.shareSector
//        }
//        sectorList.removeDuplicates()
//        sectorList = sectorList.filter{$0.count > 0}
//        sectorList = sectorList.sorted{$0 > $1}
//        
//        for eachSector in sectorList {
//            var sector = Sector()
//            sector.sectorName = eachSector
//            if sectorDetail == nil {
//                sectorDetail = [sector]
//            }else{
//                sectorDetail?.append(sector)
//            }
//        }
    }
    
    //Sector Information End
    
    // Sector profit , loss , all stock list
    class func getAPLForStock(sectorName:String)->(All:String,Profit:String,Loss:String){
        let value:Float = 0.0
        let all:String = String(nonFilterStockBasicInfo.filter{$0.sharePriceInfo?.shareSector == sectorName}.count)
        let profit:String = String(nonFilterStockBasicInfo.filter{$0.sharePriceInfo?.shareSector == sectorName && $0.sharePriceInfo?.live?.priceDifference != nil && ($0.sharePriceInfo?.live?.priceDifference)! >= value}.count)
        let loss:String = String(nonFilterStockBasicInfo.filter{$0.sharePriceInfo?.shareSector == sectorName && $0.sharePriceInfo?.live?.priceDifference != nil && ($0.sharePriceInfo?.live?.priceDifference)! < value}.count)
        
        return(all,profit,loss)
    }
    // Sector profit , loss , all stock list End
    
    // Reset TehDetaiview all DataModel
    
    class func resetDetaViewDataHandler(){
        keyState = nil
        statsBasic.removeAll()
        statsBasic1?.removeAll()
    }
    
    // getThe PRofit loass and dividend count
    
    class func setThePLDCount(){
        let value:Float = 0.0
        appStatsModel.profit_count =  String(nonFilterStockBasicInfo.filter{$0.sharePriceInfo?.live?.priceDifference != nil && ($0.sharePriceInfo?.live?.priceDifference)! >= value}.count)
        appStatsModel.loss_count =  String(nonFilterStockBasicInfo.filter{$0.sharePriceInfo?.live?.priceDifference != nil && ($0.sharePriceInfo?.live?.priceDifference)! < value}.count)
        appStatsModel.dividend_count = String(nonFilterStockBasicInfo.filter{$0.sharePriceInfo?.dividendsPrice != nil &&  ($0.sharePriceInfo?.dividendsPrice)! > value}.count)
    }
    
    // News Feed
    
    class func parseTheMarketNews(data:Data){
//        do {
//            let decoder = JSONDecoder()
//            allNewsFeed = try decoder.decode([NewsCardDataModel].self, from: data)
//        }catch let error{
//            print("error")
//        }
    }
}

extension Array {
    
    func getFirstElements(from:Int, upTo position: Int) -> Array<Element> {
        let arraySlice = self[from ..< position]
        return Array(arraySlice)
    }
    
}

extension Array where Element: Equatable {
    mutating func removeDuplicates() {
        var result = [Element]()
        for value in self {
            if !result.contains(value){
                result.append(value)
            }
        }
        self = result
    }
}


//
//  StockDetailViewController.swift
//  StockEMC2_new
//
//  Created by Balagurubaran Kalingarayan on 11/19/18.
//  Copyright © 2018 iAppsCrazy. All rights reserved.
//

import Foundation
import UIKit
import Charts

class StockDetailViewController:UIViewController{
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var stockID: UILabel!
    @IBOutlet weak var companyName: UILabel!
    
    var utility:Utility = Utility()
    var mainContentView:MainContentView = MainContentView.fromNib()
    var targetMainView:MainContentView = MainContentView.fromNib()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.utility.initloadView()
        
        DataHandler.resetDetaViewDataHandler()
        Utility.setScreenName(screenName: "Detail screen", viewController: "StockDetailViewController")
    }
    
    @IBAction func closeStockDetailView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        if let name = selectedStockInfo?.shareName {
            stockID.text = name
        }
        if let name = selectedStockInfo?.companyName {
            companyName.text = name
        }
        
        self.loadTargetMainView()
        self.loadMainContentView()
        mainContentView.removeAllView()
        self.utility.showLoadingView(view: mainContentView)
        if let shareName = selectedStockInfo?.shareName {
            let dispatchGroup = DispatchGroup()
            
            dispatchGroup.enter()
            NetworkHandler.loadTheKeyState(dispatch: dispatchGroup, shareName:shareName)
            
            dispatchGroup.notify(queue: .main) {
                StockInfoDataHandler.setTheLivePriceInfo()
                StockInfoDataHandler.setTheDayPriceInfo()
                StockInfoDataHandler.setTheStats()
                StockInfoDataHandler.setTheStats1()
                
                
                
                self.renderTheLivePriceInfo()
                
                self.renderTheDayPriceInfo()
               // self.mainContentView.addTitle(title: "Why?")
                self.mainContentView.addTitle(title: "Stats")
                self.renderTheBasicStats()

                self.loadTheGraph()
                self.utility.removeLoading(view: self.mainContentView)
            }
        }
    }
    
    func loadTargetMainView(){
        self.view.addSubview(targetMainView)
        targetMainView.backgroundColor = baseColor
        targetMainView.translatesAutoresizingMaskIntoConstraints = false
        
        targetMainView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 0).isActive = true
        targetMainView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        targetMainView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        let heightAnchor = targetMainView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.height)
        heightAnchor.isActive = true
        self.targetMainView.addTitle(title: "Target")
        self.renderTheTargetPrice()
        if let previouslyAddedView = targetMainView.contentView.subviews.last {
            let height = previouslyAddedView.frame.size.height + previouslyAddedView.frame.origin.y
            heightAnchor.constant = height
        }
        targetMainView.layoutIfNeeded()
    }
    

    func loadMainContentView(){
        if let previouslyAddedView = self.view.subviews.last {
            self.view.addSubview(mainContentView)
            mainContentView.backgroundColor = baseColor
            mainContentView.translatesAutoresizingMaskIntoConstraints = false
            
            mainContentView.topAnchor.constraint(equalTo: previouslyAddedView.bottomAnchor, constant: 0).isActive = true
            mainContentView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
            mainContentView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
            let bottom = view.window?.safeAreaInsets.bottom ?? 0.0
            mainContentView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant:-bottom).isActive = true
            self.view.layoutIfNeeded()
        }
    }
    
    //Render the Target detail
    
    func renderTheTargetPrice(){
        if let  targetPrice = selectedStockInfo?.sharePriceInfo {
            var padding = Padding.init()
            padding.trailingAnchor = -10
            padding.leadingAnchor = 10
            padding.topAnchor = 0
            padding.heightAnchor = 110
            let targetPriceView = TargetPriceBaseView.init()
            targetPriceView.translatesAutoresizingMaskIntoConstraints = false
            targetMainView.addView(view: targetPriceView, padding: padding)
            //self.view.addSubview(targetPriceView)
            targetPriceView.loadData(detail: targetPrice)
        }
    }
    
    // Render the Live price info
    
    func renderTheLivePriceInfo(){
        if let local = stockInfoElement_live{
            self.mainContentView.addTitle(title: "Live")
            for (index,eachInfo) in local.enumerated() {
                let stockinfo = StockInfoBaseView.init()
                var padding = Padding.init()
                padding.trailingAnchor = -10
                padding.leadingAnchor = 10
                padding.topAnchor = 0
                padding.heightAnchor = 35
                mainContentView.addView(view: stockinfo, padding: padding)
                stockinfo.loadTheData(info: eachInfo,index:index)
            }
        }
    }

    // Render the Day price info
    
    func renderTheDayPriceInfo(){
        if let local = stockInfoElement_Day{
            self.mainContentView.addTitle(title: "Day")
            for (index,eachInfo) in local.enumerated() {
                let stockinfo = StockInfoBaseView.init()
                var padding = Padding.init()
                padding.trailingAnchor = -10
                padding.leadingAnchor = 10
                padding.topAnchor = 0
                padding.heightAnchor = 35
                mainContentView.addView(view: stockinfo, padding: padding)
                stockinfo.loadTheData(info: eachInfo,index:index)
            }
        }
    }
    
    // Render the basic share stats
    
    func renderTheBasicStats(){
        var padding = Padding.init()
        if statsBasic.count > 0{
            for (index,eachInfo) in statsBasic.enumerated() {
                let stockinfo = StockInfoBaseView.init()
                
                padding.trailingAnchor = -10
                padding.leadingAnchor = 10
                padding.topAnchor = 0
                padding.heightAnchor = 35
                mainContentView.addView(view: stockinfo, padding: padding)
                stockinfo.loadTheData(info: eachInfo,index:index)
            }
        }
        if let local = statsBasic1{
            for (index,eachInfo) in local.enumerated() {
                let stockinfo = StockInfoBaseView.init()
                var padding = Padding.init()
                padding.trailingAnchor = -10
                padding.leadingAnchor = 10
                padding.topAnchor = 0
                padding.heightAnchor = 35
                mainContentView.addView(view: stockinfo, padding: padding)
                stockinfo.loadTheData(info: eachInfo,index:index)
                padding.topAnchor = 0
            }
        }
    }

    func loadTheGraph() {
//        if(!isValidPurchase){
//            return
//        }
        var padding = Padding()
        padding.leadingAnchor = 10
        padding.trailingAnchor = -10
        padding.heightAnchor = 300.0
        padding.topAnchor = 10.0
        
        if let cosolidatedData = DataHandler.consolidatedTradeVolume() {
            if cosolidatedData.count > 0{
                self.mainContentView.addTitle(title: "Day Trade")
                let chartView = getChatBaseView(padding: padding)
                BarView.init().loadVolumeToBarCharView(chartView: chartView, volume: cosolidatedData)
            }
        }
        
        if financialData.count > 0{
            self.mainContentView.addTitle(title: "Revenue")
            let chartView = getChatBaseView(padding: padding)
            BarView.init().loadBarCharRevenue_earning(barChart: chartView, revenue_earnigData: financialData)
        }
        if(EPSData.count > 0){
            self.mainContentView.addTitle(title: "EPS")
            let chartView = getChatBaseView(padding: padding)
            let EPSData = EPSChartData.init()
            EPSData.loadEPSBarCHart(chartView: chartView)
        }
    }
    
    func getChatBaseView(padding:Padding)->BarChartView {
        let  chartView = BarChartView.init(frame: CGRect.zero)
        chartView.translatesAutoresizingMaskIntoConstraints = false
        mainContentView.addView(view: chartView, padding: padding)
        return chartView
    }
    
    func setStyle(chartView:BarChartView,padding:Padding){
        chartView.backgroundColor = UIColor.white
        chartView.layer.cornerRadius = 10.0

        chartView.layer.shadowColor   = UIColor.black.cgColor
        chartView.layer.shadowOffset  = CGSize(width: 0, height: 0)
        chartView.layer.shadowOpacity = 0.5
        chartView.layer.shadowRadius  = 2
        chartView.layer.masksToBounds = false
    }
    
}



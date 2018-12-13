//
//  StockDetailViewController.swift
//  StockEMC2_new
//
//  Created by Balagurubaran Kalingarayan on 11/19/18.
//  Copyright © 2018 iAppsCrazy. All rights reserved.
//

import Foundation
import UIKit


class StockDetailViewController:UIViewController{
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var stockID: UILabel!
    @IBOutlet weak var companyName: UILabel!
    
    var utility:Utility = Utility()
    var mainContentView:MainContentView = MainContentView.fromNib()
    var targetMainView:MainContentView = MainContentView.fromNib()
    var FinanciadetailVIew:FinancialDataView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.utility.initloadView()
        
        DataHandler.resetDetaViewDataHandler()
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
            
            dispatchGroup.enter()
            NetworkHandler.loadTheEPSGraph(dispatch: dispatchGroup, shareName:shareName)
            
            dispatchGroup.enter()
            NetworkHandler.loadTheRevenueGraph(dispatch: dispatchGroup, shareName:shareName)
            
            dispatchGroup.enter()
            NetworkHandler.load30DaysData(dispatch: dispatchGroup, shareName:shareName)
            
            dispatchGroup.notify(queue: .main) {
                StockInfoDataHandler.setTheLivePriceInfo()
                StockInfoDataHandler.setTheStats()
                StockInfoDataHandler.setTheStats1()
                
                
                self.mainContentView.addTitle(title: "Price")
                self.renderTheLivePriceInfo()
               // self.mainContentView.addTitle(title: "Why?")
                self.mainContentView.addTitle(title: "Stats")
                self.renderTheBasicStats()
                self.mainContentView.addTitle(title: "Day Trade")
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
            mainContentView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: (UIDevice.current.userInterfaceIdiom == .pad ? 20 : 0)).isActive = true
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
        
        if(FinanciadetailVIew == nil){
            FinanciadetailVIew = FinancialDataView.init()
            FinanciadetailVIew?.translatesAutoresizingMaskIntoConstraints = false
            if let view = FinanciadetailVIew {
                var padding = Padding()
                padding.leadingAnchor = 10
                padding.trailingAnchor = -10
                padding.heightAnchor = 950.0
                padding.topAnchor = 10.0
                mainContentView.addView(view: view, padding: padding)
                
                //FinanciadetailVIew?.heightAnchor.constraint(equalTo: mainView.heightAnchor, multiplier: 920.0/mainView.frame.size.height).isActive = true
                mainContentView.layoutIfNeeded()
                FinanciadetailVIew?.loadFinacialData()
            }
        }
    }
}


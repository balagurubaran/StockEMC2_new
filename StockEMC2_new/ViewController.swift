//
//  ViewController.swift
//  StockEMC2_new
//
//  Created by Balagurubaran Kalingarayan on 11/11/18.
//  Copyright © 2018 iAppsCrazy. All rights reserved.
//

import UIKit
import Magnetic
import iAppsUtilities
import SectorCard
import DropDown

class ViewController: UIViewController,SectorCardDelegate,StockCardDelegate {

    var mainContentView:MainContentView = MainContentView.fromNib()
    var menuContentView:MainContentView = MainContentView.fromNib()
    var utility:Utility = Utility()
    let secondaryFilter = UIButton.init()
    let secondaryFilterDropDown = DropDown()
    let notificationCenter = NotificationCenter.default
    var subscriptionButton:CustomButton? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        notificationCenter.addObserver(self, selector: #selector(renderView), name: NSNotification.Name(rawValue: "renderView"), object: nil)
        utility.initloadView()
    }
    
    @objc func renderView(){
        DispatchQueue.main.async {
            self.utility.showLoadingView(view: self.view)
            let dispatchGroup = DispatchGroup()
            dispatchGroup.enter()
            NetworkHandler.loadTheStats(dispatch: dispatchGroup)
            
            dispatchGroup.enter()
            NetworkHandler.loadTheStockBasicInfo(dispatch: dispatchGroup)
            
            dispatchGroup.enter()
            HandleSubscription.shared.loadReceipt(completion: { (status) in
                isValidPurchase = status
                dispatchGroup.leave()
            })
            
            self.utility.showLoadingView(view: self.view)
            dispatchGroup.notify(queue: .main) {
                DataHandler.setAllSectorDetails()
                self.loadTheMenuContentView()
                self.loadMainContentView()
                self.utility.removeLoading(view: self.view)
                
                self.notificationCenter.addObserver(self, selector: #selector(self.addsubscriptionButton), name: UIApplication.willEnterForegroundNotification, object: nil)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !userDefaults.bool(forKey: "termsandconditon") {
            self.performSegue(withIdentifier: "termsandconditon", sender: nil)
            return
        }else{
            renderView()
        }
    }
    
    func loadMainContentView(){
        if let previouslyAddedView = self.view.subviews.last {
            self.view.addSubview(mainContentView)
            mainContentView.backgroundColor = baseColor
            mainContentView.translatesAutoresizingMaskIntoConstraints = false

            mainContentView.topAnchor.constraint(equalTo: previouslyAddedView.bottomAnchor, constant: 0).isActive = true
            mainContentView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
            mainContentView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
            mainContentView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
            self.view.layoutIfNeeded()
        }
        loadTheStockList(selectedMenuItem:"All")
        addsubscriptionButton()
    }
    
    func loadTheStockList(selectedMenuItem:String){
        let enumValue:MenuListEnum? = MenuListEnum(rawValue: selectedMenuItem)
        DataHandler.filterTheMenu(status: enumValue!,filter: (secondaryFilter.titleLabel?.text)!)
        if (selectedMenuItem == MenuListEnum.search.rawValue){
            if DataHandler.getTheMainStockDetail().count <= 0 {
                DataHandler.filterTheMenu(status: MenuListEnum.all,filter: (secondaryFilter.titleLabel?.text)!)
                Utility.showMessage(message: "Stock not listed")
            }
        }
        RenderTheStockList()
    }
    
    func RenderTheStockList(){
        mainContentView.removeAllView()
        for (index,eachStock) in DataHandler.getTheMainStockDetail().enumerated() {
            let stockNode = StockListViewBase.init()
            stockNode.delegate = self
            var padding = Padding.init()
            padding.trailingAnchor = -10
            padding.leadingAnchor = 10
            padding.topAnchor = 10
            padding.heightAnchor = 45
            mainContentView.addView(view: stockNode, padding: padding)
            if index % 2 == 0 {
                eachStock.backGroundColor = UIColor.init(red: 0.0/255, green: 0.0/255, blue: 0.0/255,alpha:0.05)
            }else{
                eachStock.backGroundColor = .white
            }
            stockNode.loadTheData(stockBasicInfo: eachStock)
        }
    }
    
    
    func sectorClicked(sectorName: String) {
        DataHandler.selectedSector = sectorName
        loadTheStockList(selectedMenuItem: "Sector")
        resetAllNode()
        print("\(sectorName)")
        
    }
    
    func selectedStock(uniqueID: String) {
        if isValidPurchase == false{
            Utility.showMessage(message:"Need subscription to see the Target price for the stock")
            subscriptionButton?.show()
            return
        }
        if let stockDetail = DataHandler.getTheSpecificStockFromshareBasicInfo(stockName: uniqueID){
            selectedStockInfo = stockDetail
            self.performSegue(withIdentifier: "stockdetail", sender: nil)
        }
    }
}


extension ViewController:SearchBarDelegate {
    func searchBardEndEditing(searchString: String) {
        //fadeOut()
        if(SearchBar.isSearchBarLifeTime && searchString != ""){
            DataHandler.setSearchString(searchValue: searchString)
            loadTheStockList(selectedMenuItem: MenuListEnum.search.rawValue)
        }else{
            if(isWatchList){
                isWatchList = false
            }
            searchBarClosed()
        }
        
    }
    
    func searchBarClosed() {
        SearchBar.isSearchBarLifeTime = false
        
    }
}

struct Padding {
    var topAnchor:CGFloat = 0.0
    var leadingAnchor:CGFloat = 0.0
    var heightAnchor:CGFloat = 0.0
    var trailingAnchor:CGFloat = 0.0
}

class MainContentView:UIView {
    
    @IBOutlet weak var mainScrollview: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentViewHeightConstaint: NSLayoutConstraint!
    var previouslyAddedView:UIView!
    
    func addView(view:UIView,padding:Padding){
        contentView.backgroundColor = baseColor
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: padding.trailingAnchor).isActive = true
        if previouslyAddedView == nil {
            view.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding.topAnchor).isActive = true
        }else {
            view.topAnchor.constraint(equalTo: previouslyAddedView.bottomAnchor, constant: padding.topAnchor).isActive = true
        }
        if padding.heightAnchor > 0.0 {
            view.heightAnchor.constraint(equalToConstant: padding.heightAnchor).isActive = true
        }
        previouslyAddedView = view
        contentView.layoutIfNeeded()
        //print(previouslyAddedView.frame.origin.y + previouslyAddedView.frame.size.height,self.frame.height)
        if self.frame.height <  previouslyAddedView.frame.origin.y + previouslyAddedView.frame.size.height{
            contentViewHeightConstaint.constant = abs((previouslyAddedView.frame.origin.y + previouslyAddedView.frame.size.height) - self.frame.height) + 10
            
        }
    }
    func removeAllView() {
        previouslyAddedView = nil
        for eachView in contentView.subviews {
            eachView.removeFromSuperview()
        }
        //mainScrollview.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
        contentViewHeightConstaint.constant = 0.0
    }
    func addTitle(title:String){
        let label = UILabel.init()
        label.text = title
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.makeOutLine(oulineColor: UIColor.black, foregroundColor: baseColor)
        //label.underline()
        var padding = Padding.init()
        padding.leadingAnchor = 10
        padding.trailingAnchor = -10
        padding.topAnchor = 0
        padding.heightAnchor = 45
        self.addView(view: label, padding: padding)
    }
}

//
//  MainMenu+Extension.swift
//  StockEMC2_new
//
//  Created by Balagurubaran Kalingarayan on 11/18/18.
//  Copyright © 2018 iAppsCrazy. All rights reserved.
//

import Foundation
import UIKit
import Magnetic
import iAppsUtilities
import SectorCard
import DropDown

extension ViewController {

    func loadTheMenuContentView(){
        self.view.addSubview(menuContentView)
        menuContentView.backgroundColor = baseColor
        menuContentView.translatesAutoresizingMaskIntoConstraints = false
        
        menuContentView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: view.window?.safeAreaInsets.top ?? 0.0).isActive = true
        menuContentView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        menuContentView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        let heightAnchor = menuContentView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.height)
        heightAnchor.isActive = true

        menuContentView.addTitle(title: "Menu")
        loadTheMainMenu()
        menuContentView.addTitle(title: "Sector")
        loadSectorView()
        renderTheNewsFeed()
        
        var padding = Padding.init()
        padding.leadingAnchor = 10
        padding.trailingAnchor = -10
        padding.heightAnchor = 0.0
        
        menuContentView.addView(view: titleWithLeftButton(labelText: "Stocks", buttonTitle: "Latest"), padding: padding)
        if let previouslyAddedView = menuContentView.contentView.subviews.last {
            heightAnchor.constant = previouslyAddedView.frame.size.height + previouslyAddedView.frame.origin.y + (UIDevice.current.userInterfaceIdiom == .pad ? 10 : 0)
        }
        menuContentView.layoutIfNeeded()
        
    }
    
    func loadTheMainMenu(){
        let rect = CGRect(x: 0, y: 40, width: self.view.bounds.width, height: 85)
        let magneticView = MagneticView.init(frame: rect)
        magneticView.backgroundColor = baseColor
        magneticView.translatesAutoresizingMaskIntoConstraints = false
        let magnetic = magneticView.magnetic
        magnetic.magneticDelegate = self
        var padding = Padding.init()
        padding.leadingAnchor = 10
        padding.trailingAnchor = -10
        padding.heightAnchor = 85
        menuContentView.addView(view: magneticView, padding: padding)
        for (index,menu) in mainMenuItems.enumerated() {
            let color = UIColor.colors[index]
            let enumValue:MenuListEnum? = MenuListEnum(rawValue: menu)
            var eachMenuStockCount = ""
            switch enumValue {
            case .all?:
                eachMenuStockCount = "\(DataHandler.getTheMainStockDetail().count)"
            case .loss?:
                eachMenuStockCount = appStatsModel.loss_count ?? ""
            case .profit?:
                eachMenuStockCount = appStatsModel.profit_count ?? ""
            case .dividend?:
                eachMenuStockCount = appStatsModel.dividend_count ?? ""
            default:
                break
            }
            let node = Node(text: (mainMenuItems[index] + " " + eachMenuStockCount), image: nil, color: color, radius: 30)
            magnetic.addChild(node)
        }
        magneticView.layoutIfNeeded()
    }
    
    func loadSectorView(){
        let sectorBaseView = SectorCardBaseView.init()
        sectorBaseView.sectorCardDelegate = self
        var padding = Padding.init()
        padding.leadingAnchor = 10
        padding.trailingAnchor = -10
        padding.heightAnchor = 100
        menuContentView.addView(view: sectorBaseView, padding: padding)
        
        var allSectorData = [SectorCardDataModel]()
        if let localSectorCopy = sectorDetail{
            for (index,eachSector) in localSectorCopy.enumerated(){
                var sectorData = SectorCardDataModel()
                sectorData.sectorName = eachSector.sectorName ?? ""
                let APL = DataHandler.getAPLForStock(sectorName: sectorData.sectorName)
                sectorData.sectorFirstValue = APL.All
                sectorData.sectorSecoundValue = APL.Profit
                sectorData.sectorThirdValue = APL.Loss
                sectorData.uniqueID = index
                allSectorData.append(sectorData)
            }
            sectorBaseView.LoadTheDataToScroll(sectorDataModel: allSectorData)
        }
    }
}

// MARK: - MagneticDelegate
extension ViewController: MagneticDelegate {
    
    func magnetic(_ magnetic: Magnetic, didSelect node: Node) {
        let value = node.text?.components(separatedBy: " ")
        for eachNode in magnetic.selectedChildren{
            eachNode.isSelected = false
        }
    
        if let selectedMenu = value {
            node.isSelected = true
            if selectedMenu[0] == MenuListEnum.search.rawValue {
                SearchBar.showSearchBar()
            }else{
                loadTheStockList(selectedMenuItem: selectedMenu[0])
            }
        }
        for view in menuContentView.contentView.subviews {
            if view.isKind(of: SectorCardBaseView.self){
                if let sectorBaseView = view as? SectorCardBaseView {
                    sectorBaseView.removeTheUnderLine()
                }
            }
        }
    }
    
    func magnetic(_ magnetic: Magnetic, didDeselect node: Node) {
        print("didDeselect -> \(node)")
    }
    
    func resetAllNode(){
        for view in menuContentView.contentView.subviews {
            if view.isKind(of: MagneticView.self){
                if let magnecticView = view as? MagneticView {
                    for eachNode in magnecticView.magnetic.selectedChildren{
                        eachNode.isSelected = false
                    }
                }
            }
        }
    }
    
    func titleWithLeftButton(labelText text:String,buttonTitle title:String)->UIView{
        let baseSize = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: 50)
        let labelSize = CGRect.init(x: 0, y: 0, width: 100, height: 40)
        let buttonSize = CGRect.init(x: self.view.frame.size.width - 125, y: 0, width: 100, height: 38)
       
        let baseView = UIView.init(frame: baseSize)
        baseView.translatesAutoresizingMaskIntoConstraints = false
        

        let label = UILabel.init(frame: labelSize)
        label.text = text
        label.font = UIFont.systemFont(ofSize: 18)
        //label.translatesAutoresizingMaskIntoConstraints = false
        label.makeOutLine(oulineColor: UIColor.black, foregroundColor: baseColor)
        baseView.addSubview(label)
        
        secondaryFilter.frame = buttonSize
        secondaryFilter.titleLabel?.font = UIFont.init(name: "Lato-Light", size: 16)
        secondaryFilter.backgroundColor = UIColor.stockEmc2GrayAlpha
        secondaryFilter.layer.cornerRadius = buttonSize.size.height / 2
        secondaryFilter.contentVerticalAlignment = .center
        secondaryFilter.setTitle(title, for: .normal)
        secondaryFilter.setTitleColor(.black, for: .normal)
        secondaryFilter.addTarget(self, action: #selector(filterOrder(sender:)), for: .touchUpInside)
        baseView.addSubview(secondaryFilter)
    
        // The view to which the drop down will appear on
        secondaryFilterDropDown.anchorView = secondaryFilter // UIView or UIBarButtonItem
        secondaryFilterDropDown.bottomOffset = CGPoint(x: -10, y:(secondaryFilterDropDown.anchorView?.plainView.bounds.height)!)
        secondaryFilterDropDown.textFont = UIFont.init(name: "Lato-Light", size: 16)!
        // The list of items to display. Can be changed dynamically
        secondaryFilterDropDown.dataSource = [SecondaryFilter.Latest.rawValue,SecondaryFilter.PriceUp.rawValue, SecondaryFilter.PriceDown.rawValue]
        secondaryFilterDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            DataHandler.secondaryFilter(filter: item)
            self.secondaryFilter.setTitle(item, for: .normal)
            self.RenderTheStockList()
        }
         return baseView
        
    }
    
    @objc func filterOrder(sender:UIButton){
        secondaryFilterDropDown.show()
    }
    
    @objc func addsubscriptionButton(){
        
        if let currentViewController = UIApplication.shared.topMostViewController() {
            if subscriptionButton == nil {
                subscriptionButton = CustomButton.init(frame: CGRect.zero)
                subscriptionButton?.buttonProperty(title: "Subscribe")
                subscriptionButton?.addTarget(self, action:#selector(showSubscribe), for: .touchUpInside)
                subscriptionButton?.isHidden = true
                currentViewController.view.addSubview(subscriptionButton!)
            }else{
                subscriptionButton?.hide()
            }
            if isValidPurchase == true{
                subscriptionButton?.hide()
                return
            }
            subscriptionButton?.show()
        }
    }
    
    @objc func showSubscribe(){
        self.performSegue(withIdentifier: "subscribe", sender: nil)
    }
}

class CustomButton:UIButton {

    func buttonProperty(title:String){
        if let currentViewController = UIApplication.shared.topMostViewController() {
            let size = currentViewController.view.frame.size
            self.frame = CGRect.init(x: (size.width - 200) / 2 , y: size.height + 55, width: 200, height: 50)
            self.layer.cornerRadius = self.frame.size.height / 2
            self.setTitle(title, for: .normal)
            self.backgroundColor = UIColor.stockEmc2Pink
        }
    }
    
    func show(){
        if !self.isHidden {
            return
        }
        if let currentViewController = UIApplication.shared.topMostViewController() {
            self.isHidden = false
            let size = currentViewController.view.frame.size
            UIView.animate(withDuration: 1) {
                self.frame.origin.y = size.height - 55
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            self.hide()
        }
    }
    
    func hide(){
        if let currentViewController = UIApplication.shared.topMostViewController() {
            let size = currentViewController.view.frame.size
            UIView.animate(withDuration: 1, animations: {
                self.frame.origin.y = size.height + 50
            }) { (completed) in
                self.isHidden = true
            }
        }
    }
}

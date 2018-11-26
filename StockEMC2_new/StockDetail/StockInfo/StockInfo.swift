//
//  StockInfo.swift
//  StockEMC2_new
//
//  Created by Balagurubaran Kalingarayan on 11/20/18.
//  Copyright © 2018 iAppsCrazy. All rights reserved.
//

import Foundation
import UIKit

class StockInfoBaseView:UIView {
    
    let stockInfo:StockInfo = StockInfo.fromNib()
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience public init(){
        self.init(frame: CGRect.zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        stockInfo.translatesAutoresizingMaskIntoConstraints = false
        renderTheView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func renderTheView(){
        self.addSubview(stockInfo)
        stockInfo.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        stockInfo.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        stockInfo.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        stockInfo.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        self.layoutIfNeeded()
    }
    
    func loadTheData(info:StockInfoDataModel,index:Int){
        if index % 2 == 0 {
           stockInfo.view1.backgroundColor = UIColor.white
            stockInfo.view2.backgroundColor = UIColor.init(red: 0.0/255, green: 0.0/255, blue: 0.0/255,alpha:0.05)
        }else{
            stockInfo.view1.backgroundColor = UIColor.init(red: 0.0/255, green: 0.0/255, blue: 0.0/255,alpha:0.05)
            stockInfo.view2.backgroundColor = UIColor.white
        }
        if let key = info.key , let value = info.value {
            stockInfo.view1Label1.text = key
            stockInfo.view1Label2.text = "\(value)"
        }
        
        if let key = info.key1 , let value = info.value1 {
            stockInfo.view2Label1.text = key
            stockInfo.view2Label2.text = "\(value)"
        }
    }
}

class StockInfo:UIView {
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view1Label1: UILabel!
    @IBOutlet weak var view1Label2: UILabel!
    
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view2Label1: UILabel!
    @IBOutlet weak var view2Label2: UILabel!
}

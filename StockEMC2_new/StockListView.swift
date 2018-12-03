//
//  StockListView.swift
//  StockEMC2_new
//
//  Created by Balagurubaran Kalingarayan on 11/16/18.
//  Copyright © 2018 iAppsCrazy. All rights reserved.
//

import UIKit

public protocol StockCardDelegate:AnyObject {
    func selectedStock(uniqueID:String)
}

class StockListViewBase:UIView,StockCardDelegate{
    let stockListView:StockListView = StockListView.fromNib()
    public weak var delegate:StockCardDelegate?
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience public init(){
        self.init(frame: CGRect.zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        stockListView.translatesAutoresizingMaskIntoConstraints = false
        renderTheView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func renderTheView(){
        self.addSubview(stockListView)
        stockListView.delegate = self
        stockListView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        stockListView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        stockListView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        stockListView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        self.layoutIfNeeded()
    }
    
    func loadTheData(stockBasicInfo:shareBasicInfo){
       if let stockID = stockBasicInfo.shareName , let companyName = stockBasicInfo.companyName, let priceInfo = stockBasicInfo.sharePriceInfo, let currentPrice = priceInfo.currentPrice, let priceDifference = priceInfo.live?.priceDifference{
            stockListView.stockName.text = stockID
            stockListView.companyName.text = companyName
            stockListView.marketPrice.text = currentPrice.dollarString
            stockListView.backgroundColor = stockBasicInfo.backGroundColor
            stockListView.marketPrice.textColor = priceDifference >= 0 ? UIColor.colors[3] : UIColor.colors[4]
        }  
    }
    
    func selectedStock(uniqueID:String){
        delegate?.selectedStock(uniqueID: uniqueID)
    }
}

class StockListView: UIView {

    @IBOutlet weak var stockName: UILabel!
    @IBOutlet weak var companyName: UILabel!
    @IBOutlet weak var marketPrice: UILabel!
    public weak var delegate:StockCardDelegate?
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func awakeFromNib() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(StockListView.stockSelected))
        self.addGestureRecognizer(gestureRecognizer)
    }

    @objc func stockSelected() {
        if let name = stockName.text{
            delegate?.selectedStock(uniqueID: name)
        }
    }
    
}

extension Float {
    var dollarString:String {
        return String(format: "$%.2f", self)
    }
}

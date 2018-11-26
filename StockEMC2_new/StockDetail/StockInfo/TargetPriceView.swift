//
//  TargetPriceView.swift
//  StockEMC2_new
//
//  Created by Balagurubaran Kalingarayan on 11/21/18.
//  Copyright © 2018 iAppsCrazy. All rights reserved.
//

import Foundation
import UIKit
class TargetPriceBaseView:UIView{
    
    let targetView:TargetPriceView = TargetPriceView.fromNib()
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience public init(){
        self.init(frame: CGRect.zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        targetView.translatesAutoresizingMaskIntoConstraints = false
        renderTheView()
    }
    
    public func renderTheView(){
        self.addSubview(targetView)
        targetView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        targetView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        targetView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        targetView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        self.layoutIfNeeded()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadData(detail:Share?){
        if let actualPrice = detail?.actualPrice , let targetPrice = detail?.targetPrice{
            targetView.bestPrice.text = "Best price: $\(actualPrice)"
            targetView.targetPrice.text = "$\(targetPrice)"
        }
        
        if let margetPrice = selectedStockInfo?.sharePriceInfo?.live?.price {
            targetView.margetPrice.text = "Market price: $\(margetPrice)"
        }
    }
}

class TargetPriceView:UIView{
    @IBOutlet weak var targetPrice: UILabel!
    @IBOutlet weak var bestPrice: UILabel!
    @IBOutlet weak var margetPrice: UILabel!
    
}

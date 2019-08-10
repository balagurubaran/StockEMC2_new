//
//  Robinhood.swift
//  StockEMC2_new
//
//  Created by Guest on 7/13/19.
//  Copyright © 2019 iAppsCrazy. All rights reserved.
//

import Foundation
import UIKit

class Robinhood:UIView {

    
    override func awakeFromNib() {
        setUPPage()
    }
    
    func setUPPage(){
        self.translatesAutoresizingMaskIntoConstraints = false
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(openRobinHood))
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc func openRobinHood(){
        guard let url = URL(string: "http://share.robinhood.com/balaguk") else { return }
        UIApplication.shared.open(url)
    }
}

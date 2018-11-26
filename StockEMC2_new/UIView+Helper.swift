//
//  UIView+Helper.swift
//  StockEMC2_new
//
//  Created by Balagurubaran Kalingarayan on 11/17/18.
//  Copyright © 2018 iAppsCrazy. All rights reserved.
//

import Foundation
import UIKit
extension UIView {
    
    func dropShadow(color:UIColor = .black, scale: Bool = false) {
        let layer           = self.layer
        layer.cornerRadius = 0.0
        layer.shadowColor   = color.cgColor
        layer.shadowOffset  = CGSize(width: 0, height: 1)
        layer.shadowOpacity = 0.5
        layer.shadowRadius  = 2
        //layer.borderWidth = 1.0
    }
}

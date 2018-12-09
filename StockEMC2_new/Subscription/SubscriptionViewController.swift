//
//  SubscriptionViewController.swift
//  stockemc2
//
//  Created by Balagurubaran Kalingarayan on 10/13/18.
//  Copyright © 2018 Balagurubaran Kalingarayan. All rights reserved.
//

import Foundation
import UIKit

class SubscriptionViewController:UIViewController {
    
    override func awakeFromNib() {
         NotificationCenter.default.addObserver(self, selector: #selector(closeView), name: NSNotification.Name(rawValue: "closeView"), object: nil)
    }
    
    @IBAction func paySubscrption(_ sender: Any) {
        if(!isValidPurchase){
            HandleSubscription.shared.purchase()
        }
    }
    
    @IBAction func closeView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func restorePurchase(_ sender: Any) {
        if(!isValidPurchase){
            HandleSubscription.shared.restorePurchases()
        }
    }
}


//
//  UIViewController+Helper.swift
//  StockEMC2_new
//
//  Created by Balagurubaran Kalingarayan on 11/25/18.
//  Copyright © 2018 iAppsCrazy. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func topMostViewController() -> UIViewController {
        if self.presentedViewController == nil {
            return self
        }
        if let navigation = self.presentedViewController as? UINavigationController {
            return navigation.visibleViewController!.topMostViewController()
        }
        if let tab = self.presentedViewController as? UITabBarController {
            if let selectedTab = tab.selectedViewController {
                return selectedTab.topMostViewController()
            }
            return tab.topMostViewController()
        }
        return self.presentedViewController!.topMostViewController()
    }
}

extension UIApplication {
    func topMostViewController() -> UIViewController? {
        return self.keyWindow?.rootViewController?.topMostViewController()
    }
    
    func dismissView(){
        if let visibleViewController = self.keyWindow?.rootViewController?.topMostViewController() {
            visibleViewController.dismiss(animated: true, completion: nil)
        }
    }
}

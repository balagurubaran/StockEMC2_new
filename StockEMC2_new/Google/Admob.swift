//
//  Admob.swift
//  StockEMC2_new
//
//  Created by Balagurubaran Kalingarayan on 2/16/19.
//  Copyright © 2019 iAppsCrazy. All rights reserved.
//

import Foundation
import GoogleMobileAds
import UIKit

class Admob {
    func setUPAds(){
        // Use Firebase library to configure APIs.
        //FirebaseApp.configure()
        
        // Initialize the Google Mobile Ads SDK.
        GADMobileAds.configure(withApplicationID: "ca-app-pub-4013951321415401~2327516721")
    }
    func createAds(rootViewController:UIViewController)->UIView{
        let bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        bannerView.adUnitID = "ca-app-pub-4013951321415401/8210398795"
        bannerView.rootViewController = rootViewController
        bannerView.load(GADRequest())
        return bannerView
    }
}

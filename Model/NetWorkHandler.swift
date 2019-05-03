//
//  NetWorkHandler.swift
//  StockEMC2
//
//  Created by Balagurubaran Kalingarayan on 3/20/18.
//  Copyright © 2018 Balagurubaran Kalingarayan. All rights reserved.
//

import Foundation

class NetworkHandler{
    
    class func loadTheKeyState(dispatch:DispatchGroup,shareName:String){
        let service = Service()
        service.getKeyState(shareName: shareName) { (data) in
            DataHandler.parseStats(data: data)
            dispatch.leave()
        }
    }
    
    class func loadTheStockBasicInfo( dispatch:DispatchGroup){
        let service = Service()
        service.getshareBasicDetail { (data) in
            DataHandler.parseTheStockBasicDetail(data: data)
            dispatch.leave()
        }
    }

    class func loadTheNewsFeed(dispatch:DispatchGroup,shareName:String = "All"){
        let url = "https://rgbtohex.in/pennystock/Version3/newsfeed/getallnews.php"
        Network.init().getData(url) { (data) in
            DataHandler.parseTheMarketNews(data: data)
            dispatch.leave()
        }
    }
}

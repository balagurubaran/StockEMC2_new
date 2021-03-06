//
//  Service.swift
//  PennyPlus
//
//  Created by Balagurubaran Kalingarayan on 12/29/17.
//  Copyright © 2017 Balagurubaran Kalingarayan. All rights reserved.
//

import Foundation

class Service{
    func getKeyState(shareName:String, completion:@escaping (_ Data:Data) -> Void){
        Network.init().getData( newURL + "/getstats.php?stockid=\(shareName)") { (data) in
            completion(data)
        }
    }
    
    func getTheFinancialData(url:String,completion:@escaping (_ Data:Data) -> Void){
        Network.init().getData(url) { (data) in
            completion(data)
        }
    }
    
    func getshareBasicDetail(completion:@escaping (_ Data:Data) -> Void){
        Network.init().getData( newURL + "/getbasicinfo.php?count=100") { (data) in
           
            completion(data)
        }
    }
}

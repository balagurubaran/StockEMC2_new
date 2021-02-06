//
//  String+helper.swift
//  StockEMC2_new
//
//  Created by Balagurubaran Kalingarayan on 11/17/18.
//  Copyright © 2018 iAppsCrazy. All rights reserved.
//

import Foundation

extension String {
    
    public var initials: String {
        var finalString = String()
        var words = components(separatedBy: .whitespacesAndNewlines)
        
        if let firstCharacter = words.first?.first {
            finalString.append(String(firstCharacter))
            words.removeFirst()
        }
        
        if let lastCharacter = words.last?.first {
            finalString.append(String(lastCharacter))
        }
        
        return finalString.uppercased()
    }
    
    public mutating func formatDateString()->String{
        let array = self.split(separator: "-")
        let month = array[1]
        let day = array[2]
        let year = array[0]
        return "\(month)-\(day)-\(year)"
    }
    
    func StringToDate(withFormat format: String = "yyyy-MM-dd HH:mm:ss")-> Date?{

           let dateFormatter = DateFormatter()
           dateFormatter.timeZone = TimeZone(identifier: "Asia/Tehran")
           dateFormatter.locale = Locale(identifier: "fa-IR")
           dateFormatter.calendar = Calendar(identifier: .gregorian)
           dateFormatter.dateFormat = format
           let date = dateFormatter.date(from: self)

           return date

    }
    
    func getDoublePrecious()->String{
        return String.init(format: "%.2f", self)
        
    }
}

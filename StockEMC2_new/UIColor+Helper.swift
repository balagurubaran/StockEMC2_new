//
//  UIColor+Helper.swift
//  StockEMC2_new
//
//  Created by iappscrazy on 2/5/21.
//  Copyright © 2021 iAppsCrazy. All rights reserved.
//

import UIKit

extension UIColor {
    
    @objc open class func colorFromString(_ colorString: String) -> UIColor
    {
    
        let colorString = colorString.lowercased()
        
        if colorString.hasPrefix("#")
        {
            var argb: [UInt] = [255, 0, 0, 0]
            let colorString = colorString.unicodeScalars
            var length = colorString.count
            var index = colorString.startIndex
            let endIndex = colorString.endIndex
            
            index = colorString.index(after: index)
            length = length - 1
            
            if length == 3 || length == 6 || length == 8
            {
                var i = length == 8 ? 0 : 1
                while index < endIndex
                {
                    var c = colorString[index]
                    index = colorString.index(after: index)
                    
                    var val = (c.value >= 0x61 && c.value <= 0x66) ? (c.value - 0x61 + 10) : c.value - 0x30
                    argb[i] = UInt(val) * 16
                    if length == 3
                    {
                        argb[i] = argb[i] + UInt(val)
                    }
                    else
                    {
                        c = colorString[index]
                        index = colorString.index(after: index)
                        
                        val = (c.value >= 0x61 && c.value <= 0x66) ? (c.value - 0x61 + 10) : c.value - 0x30
                        argb[i] = argb[i] + UInt(val)
                    }
                    
                    i += 1
                }
            }
            
            return UIColor(red: CGFloat(argb[1]) / 255.0, green: CGFloat(argb[2]) / 255.0, blue: CGFloat(argb[3]) / 255.0, alpha: CGFloat(argb[0]) / 255.0)
        }
        return UIColor.clear
    }
    
    class func headerTextColor()->UIColor{
        return UIColor.colorFromString("#3EBF89")
    }
    
    class func mainColor()->UIColor{
        return UIColor.colorFromString("#172746")
    }
    
    class func boxColor()->UIColor{
        return UIColor.colorFromString("#273A64")
    }
    
    class func textColor()->UIColor{
        return UIColor.colorFromString("#C0C8D1")
    }
    
    class func stockEmc2Red()->UIColor {
        return UIColor.colorFromString("#d9256d")
    }
    
    class func stockEmc2TealBlue()->UIColor {
        return UIColor.colorFromString("#367588")
    }
    
    class func stockEmc2Green()->UIColor {
        return UIColor.colorFromString("#1e9031")
    }
    
    class func stockEmc2Pink()->UIColor {
        return UIColor.colorFromString("#883675")
    }
    
    class func stockEmc2GrayAlpha()->UIColor {
        return UIColor.colorFromString("#7C7870")
    }
    
    
    class func randomFlatColor() -> UIColor {
        struct RandomColors {
            static let colors: Array<ColorTuple> = [
                (red: 176.0/255, green: 21.0/255, blue: 46.0/255, alpha: 1.0),
                (red: 96.0/255, green: 52.0/255, blue: 142.0/255, alpha: 1.0),
                (red: 177.0/255, green: 178.0/255, blue: 143.0/255, alpha: 1.0),
                (red: 122.0/255, green: 135.0/255, blue: 235.0/255, alpha: 1.0),
            ]
        }
        
        let colorCount = UInt32(RandomColors.colors.count)
        let randomIndex = arc4random_uniform(colorCount)
        let color = RandomColors.colors[Int(randomIndex)]
        
        return UIColor(red: color.red, green: color.green, blue: color.blue, alpha: color.alpha)
    }
    
//    static var random: UIColor {
//        return UIColor(red: .random, green: .random, blue: .random, alpha: 1.0)
//    }
    
    static let colors = [ UIColor(red: 67.0/255.0, green: 67.0/255.0, blue: 67.0/255.0, alpha: 1.0),
                         UIColor(red: 76.0/255.0, green: 187.0/255.0, blue: 249.0/255.0, alpha: 1.0),
                         UIColor(red: 250.0/255.0, green: 0.0/255.0, blue: 20.0/255.0, alpha: 1.0),
                         UIColor(red: 69.0/255.0, green: 59.0/255.0, blue: 205.0/255.0, alpha: 1.0),
                         UIColor(red: 39.0/255.0, green: 170.0/255.0, blue: 86.0/255.0, alpha: 1.0),
                         UIColor(red: 184.0/255.0, green: 140.0/255.0, blue: 100.0/255.0, alpha: 1.0),
                         UIColor(red: 7.0/255.0, green: 207.0/255.0, blue: 197.0/255.0, alpha: 1.0)]
   
}

typealias ColorTuple = (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)


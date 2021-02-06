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
    
    static func fromNib() -> Self {
    
        func instanceFromNib<T: UIView>() -> T {
            
            return UINib(nibName: "\(self)", bundle: nil).instantiate(withOwner: nil, options: nil).first as! T
        }
        
        return instanceFromNib()
    }
    
    func shake(duration: CFTimeInterval) {
                let translation = CAKeyframeAnimation(keyPath: "transform.translation.x");
            translation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
                translation.values = [-5, 5, -5, 5, -3, 3, -2, 2, 0]
                
                let rotation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
                rotation.values = [-5, 5, -5, 5, -3, 3, -2, 2, 0].map {
                    ( degrees: Double) -> Double in
                    let radians: Double = (.pi * degrees) / 180.0
                    return radians
                }
                
                let shakeGroup: CAAnimationGroup = CAAnimationGroup()
                shakeGroup.animations = [translation, rotation]
                shakeGroup.duration = duration
                self.layer.add(shakeGroup, forKey: "shakeIt")
         
    }
    
    static func loadFromXib<T>(fileName:String, withOwner: Any? = nil, options: [AnyHashable : Any]? = nil) -> T where T: UIView
       {
           let bundle = Bundle.main
           let nib = bundle.loadNibNamed(fileName, owner: withOwner, options: options as? [UINib.OptionsKey : Any])//UINib(nibName: fileName, bundle: bundle)
           
           guard let view = nib?.first as? T else {
               fatalError("Could not load view from nib file.")
           }
           return view
       }
       
       static func loadNib(fileName:String) -> UIView {
           let bundle = Bundle.main
           //let nibName = type(of: self).description().components(separatedBy: ".").last!
           let nib = UINib(nibName: fileName, bundle: bundle)
           return nib.instantiate(withOwner: self, options: nil).first as! UIView
       }
       
       func dropShadow(color:UIColor = .black, scale: Bool = false) {
           let layer           = self.layer
           layer.cornerRadius = 0.0
           layer.shadowColor   = color.cgColor
           layer.shadowOffset  = CGSize(width: 0, height: 1)
           layer.shadowOpacity = 0.5
           layer.shadowRadius  = 2
           //layer.borderWidth = 1.0
       }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
    
extension UIViewController {
    
    static func fromNib() -> Self {
    
        func instanceFromNib<T: UIViewController>() -> T {
            
            return UINib(nibName: "\(self)", bundle: nil).instantiate(withOwner: nil, options: nil).first as! T
        }
        
        return instanceFromNib()
    }
}

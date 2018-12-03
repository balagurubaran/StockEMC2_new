//
//  DisclaimerViewController.swift
//  PennyPlus
//
//  Created by Balagurubaran Kalingarayan on 12/24/17.
//  Copyright © 2017 Balagurubaran Kalingarayan. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class DisclaimerViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        if webView != nil{
            
           let content = "<html><head><meta name=\"viewport\" content=\"width=device-width, initial-scale=1\"><style> { font-size: 20px; } </style></head> <body>" + tc + "</body></html>"
            webView.loadHTMLString(content, baseURL: nil)
        }
    }
    
    @IBAction func declineDisclamier(_ sender: Any) {
        let alert = UIAlertController(title: "Information", message: "Are you want decline", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default) { action in
            // perhaps use action.title here
            exit(0)
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .default) { action in
            // perhaps use action.title here
        })
        
        self.present(alert, animated: true)
    }
    @IBAction func closeDisclamier(_ sender: Any) {
        UIView.transition(with: self.view, duration: 1.0, options: .transitionCrossDissolve, animations: {
            userDefaults.set(true, forKey: "termsandconditon")
            userDefaults.synchronize()
            self.dismiss(animated: true, completion: {
                DispatchQueue.main.async {
                    let notificationCenter = NotificationCenter.default
                   // notificationCenter.post(name: NSNotification.Name(rawValue: "renderView"), object: nil)
                }
            })
            //self.showWalkthrough()
        }, completion: nil)
    }
    
}

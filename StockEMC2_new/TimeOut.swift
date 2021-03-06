//
//  TimeOut.swift
//  stockemc2
//
//  Created by Balagurubaran Kalingarayan on 6/23/18.
//  Copyright © 2018 Balagurubaran Kalingarayan. All rights reserved.
//

import UIKit

extension Notification.Name {
    
    static let appTimeout = Notification.Name("appTimeout")
    
}

class TimerApplication: UIApplication {
    
    // the timeout in seconds, after which should perform custom actions
    // such as disconnecting the user
    private var timeoutInSeconds: TimeInterval {
        // 2 minutes
        return 600
    }
    
    private var idleTimer: Timer?
    
    // resent the timer because there was user interaction
    private func resetIdleTimer() {
        if let idleTimer = idleTimer {
            idleTimer.invalidate()
        }
        
        idleTimer = Timer.scheduledTimer(timeInterval: timeoutInSeconds,
                                         target: self,
                                         selector: #selector(TimerApplication.timeHasExceeded),
                                         userInfo: nil,
                                         repeats: true
        )
    }
    
    // if the timer reaches the limit as defined in timeoutInSeconds, post this notification
    @objc private func timeHasExceeded() {
        NotificationCenter.default.post(name: .appTimeout,
                                        object: nil
        )
       // resetIdleTimer()
    }
    
    override func sendEvent(_ event: UIEvent) {
        
        super.sendEvent(event)
        
        if idleTimer != nil {
            return
        }
        
        if let touches = event.allTouches {
            for touch in touches where touch.phase == UITouch.Phase.began {
                self.resetIdleTimer()
            }
        }
    }
}

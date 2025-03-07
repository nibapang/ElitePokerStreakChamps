//
//  LifecycleObserver.swift
//  PokerStreakChamps
//
//  Created by PokerStreakChamps on 2025/3/7.
//


import UIKit

class LifecycleObserver {
    init() {
        let notificationCenter = NotificationCenter.default
        
        // Register for application lifecycle notifications
        notificationCenter.addObserver(self,
                                       selector: #selector(handleWillResignActive),
                                       name: UIApplication.willResignActiveNotification,
                                       object: nil)
        notificationCenter.addObserver(self,
                                       selector: #selector(handleDidBecomeActive),
                                       name: UIApplication.didBecomeActiveNotification,
                                       object: nil)
        notificationCenter.addObserver(self,
                                       selector: #selector(handleDidEnterBackground),
                                       name: UIApplication.didEnterBackgroundNotification,
                                       object: nil)
        notificationCenter.addObserver(self,
                                       selector: #selector(handleWillEnterForeground),
                                       name: UIApplication.willEnterForegroundNotification,
                                       object: nil)
        notificationCenter.addObserver(self,
                                       selector: #selector(handleWillTerminate),
                                       name: UIApplication.willTerminateNotification,
                                       object: nil)
    }
    
    @objc func handleWillResignActive(_ notification: Notification) {
        print("Application will resign active (via notification)")
        
        AppController.applicationWillResignActive(UIApplication.shared)
    }
    
    @objc func handleDidBecomeActive(_ notification: Notification) {
        print("Application did become active (via notification)")
        
        AppController.applicationDidBecomeActive(UIApplication.shared)
    }
    
    @objc func handleDidEnterBackground(_ notification: Notification) {
        print("Application did enter background (via notification)")
        
        AppController.applicationDidEnterBackground(UIApplication.shared)
    }
    
    @objc func handleWillEnterForeground(_ notification: Notification) {
        print("Application will enter foreground (via notification)")
        
        AppController.applicationWillEnterForeground(UIApplication.shared)
    }
    
    @objc func handleWillTerminate(_ notification: Notification) {
        print("Application will terminate (via notification)")
        
        AppController.applicationWillTerminate(UIApplication.shared)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

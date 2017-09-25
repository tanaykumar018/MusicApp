//
//  AppDelegate.swift
//  MusicApp
//
//  Created by Tanay Kumar on 9/24/17.
//  Copyright © 2017 Tanay Kumar. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let tintColor =  UIColor(red: 0/255, green: 100/255, blue: 0/255, alpha: 1)
    var backgroundSessionCompletionHandler: (() -> Void)?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        customizeAppearance()
        return true
    }
    
    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        backgroundSessionCompletionHandler = completionHandler
    }
    
    // MARK - App Theme Customization
    
    private func customizeAppearance() {
        window?.tintColor = tintColor
        UISearchBar.appearance().barTintColor = tintColor
        UINavigationBar.appearance().barTintColor = tintColor
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
    }
}


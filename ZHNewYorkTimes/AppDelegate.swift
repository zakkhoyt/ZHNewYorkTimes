//
//  AppDelegate.swift
//  ZHNewYorkTimes
//
//  Created by Zakk Hoyt on 12/22/15.
//  Copyright © 2015 Zakk Hoyt. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        setupAppearance()
        return true
    }

    func setupAppearance() {
        let attr = [NSForegroundColorAttributeName: UIColor.yellowColor()]
        UINavigationBar.appearance().titleTextAttributes = attr
        UINavigationBar.appearance().barTintColor = UIColor.zhBackgroundColor()
        UINavigationBar.appearance().tintColor = UIColor.zhTintColor()
        UIBarButtonItem.appearance().setTitleTextAttributes(attr, forState: UIControlState.Normal)
        
        UIToolbar.appearance().barTintColor = UIColor.zhBackgroundColor()
        UIToolbar.appearance().tintColor = UIColor.zhTintColor()
        
        UITableViewCell.appearance().backgroundColor = UIColor.zhBackgroundColor()
        UITableView.appearance().backgroundColor = UIColor.zhBackgroundColor()
        
        UIWebView.appearance().backgroundColor = UIColor.zhBackgroundColor()
        UIWebView.appearance().tintColor = UIColor.zhTintColor()
    }

}


//
//  AppDelegate.swift
//  LeanStorageDemoSwift
//
//  Created by lzw on 15/9/1.
//  Copyright (c) 2015年 微信:  lzwjava. All rights reserved.
//

import UIKit
import AVOSCloud

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UITabBarControllerDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        Student.registerSubclass()
        
        AVOSCloud.setApplicationId("ohqhxu3mgoj2eyj6ed02yliytmbes3mwhha8ylnc215h0bgk", clientKey: "6j8fuggqkbc5m86b8mp4pf2no170i5m7vmax5iypmi72wldc")
        AVOSCloud.setAllLogsEnabled(true)
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.rootViewController = rootController()
        window?.makeKeyAndVisible()
        rootController()
        // Override point for customization after application launch.
        return true
    }
    
    private func rootController() -> UIViewController? {
        var tabs: NSMutableArray = NSMutableArray()
        if let path = NSBundle.mainBundle().pathForResource("DemoConfig", ofType: "plist") {
            if let dict = NSDictionary(contentsOfFile: path) {
                var keys: NSArray
                keys = dict.allKeys;
                for i in 0..<keys.count {
                    var key = keys[i] as! String
                    var object: AnyObject? = dict.objectForKey(key)
                    if (object is NSArray) {
                        var listC : DemoListC = DemoListC()
                        listC.title = NSLocalizedString(key, comment:"")
                        listC.contents = object as! [AnyObject];
                        tabs.addObject(listC)
                    } else if (object is NSString) {
                        
                    }
                }
            }
        }
        var tabC = UITabBarController()
        tabC.delegate = self
        tabC.viewControllers = tabs as [AnyObject]
        tabC.selectedIndex = 0
        tabC.title = tabs[tabC.selectedIndex].title
        
        var nav = UINavigationController(rootViewController:tabC)

        return nav;
    }
    
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        tabBarController.title = viewController.title
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}


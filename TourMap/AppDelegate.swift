//
//  AppDelegate.swift
//  TourMap
//
//  Created by Edward Chiang on 11/14/15.
//  Copyright © 2015 Soleil Studio. All rights reserved.
//

import UIKit
import Parse
import XCGLogger

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        Parse.initializeWithConfiguration(ParseClientConfiguration.init(block: { (parseMutableClientConfiguration) -> Void in
            parseMutableClientConfiguration.applicationId = "WL4YP2JOnK9ks4rzNZ9UxKUhqgMIkzX0I9Q77ftF"
            parseMutableClientConfiguration.clientKey = "2swAK4ufGMU980sHacenaO1UykHE7GJUe123s02g"
            parseMutableClientConfiguration.server = "http://timetravelmap.herokuapp.com/parse"
        }))

//        Parse.initializeWithConfiguration(ParseClientConfiguration.init(block: { (parseMutableClientConfiguration) -> Void in
//                    parseMutableClientConfiguration.applicationId = "WL4YP2JOnK9ks4rzNZ9UxKUhqgMIkzX0I9Q77ftF"
//                    parseMutableClientConfiguration.clientKey = "2swAK4ufGMU980sHacenaO1UykHE7GJUe123s02g"
//                    parseMutableClientConfiguration.server = "https://api.parse.com/1/"
//                }))
        
        Event.initialize()
        Graphical.initialize()
        
        // Log setup https://github.com/DaveWoodCom/XCGLogger
        #if DEBUG
            XCGLogger.defaultInstance().setup(.Debug, showThreadName: true, showLogLevel: true, showFileNames: true, showLineNumbers: true, writeToFile:nil, fileLogLevel: .Info)
        #else
            XCGLogger.defaultInstance().setup(.Warning, showThreadName: true, showLogLevel: true, showFileNames: true, showLineNumbers: true, writeToFile:nil, fileLogLevel: .Warning)
        #endif
        
        return true
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


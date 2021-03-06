//
//  AppDelegate.swift
//  WalkingTheDog
//
//  Created by Application Development on 7/14/17.
//  Copyright © 2017 cagocapps. All rights reserved.
//

import UIKit
import Firebase
import GoogleMobileAds
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        let ref = Database.database().reference()
        GADMobileAds.configure(withApplicationID: "ca-app-pub-9578859157437430~1781136107")
        SQLHelper.sharedInstance.setListeners(ref: ref)
        if let userSettings = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? UserWalkingTheDogSettings{
            userSettings.currentDog = userSettings.defaultDog
            userSettings.dogsOnWalk = userSettings.defDogsOnWalk
            let today = Date()
            if Calendar(identifier: Calendar.Identifier.gregorian).startOfDay(for: today) != Calendar(identifier: Calendar.Identifier.gregorian).startOfDay(for: userSettings.lastTimeSynced){
                SQLHelper.sharedInstance.resetDogs(ref: ref)
                userSettings.lastTimeSynced = today
            }
        }
        let center = UNUserNotificationCenter.current()
        let options: UNAuthorizationOptions = [.alert]
        center.requestAuthorization(options: options, completionHandler: { (granted, error) in
            if !granted {
                print("authorization didn't work")
            }})
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        let identifier = "WalkingTheDogNotification"
        let center = UNUserNotificationCenter.current()
        
        center.removeDeliveredNotifications(withIdentifiers: [identifier])
        center.removePendingNotificationRequests(withIdentifiers: [identifier])
    }
    
    var filePath: String{
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        return (url!.appendingPathComponent("Data").path)
    }


}


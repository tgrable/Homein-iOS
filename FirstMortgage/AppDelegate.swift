//
//  AppDelegate.swift
//  FirstMortgage
//
//  Created by Timothy C Grable on 10/28/15.
//  Copyright © 2015 Trekk Design. All rights reserved.
//

import UIKit
import Parse
import Bolts
import Fabric
import Answers
import Crashlytics


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)) {
            // [Optional] Power your app with Local Datastore. For more info, go to
            // https://parse.com/docs/ios_guide#localdatastore/iOS
            Parse.enableLocalDatastore()
            
            // Initialize Parse.
            Parse.setApplicationId("oc8vD41spZ2C9BZdxTP9uVmngI88bTnIJVA99xMZ",
                clientKey: "yUeoRTYblcdr8UJe6tJFg2u1kcA9KOuRsCwBccfd")
            
            // [Optional] Track statistics around application opens.
            PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
            
            PFACL.setDefaultACL(PFACL(), withAccessForCurrentUser: true)
            
            if let user = PFUser.currentUser() {
//                user.setObject(Tracker.sharedInstance().getUserIdentifier(), forKey: "localUserIdentifier")
                user.saveInBackgroundWithBlock({ (success, error) -> Void in
                    if let error = error {
//                        Tracker.sharedInstance().trackParseError(error)
                        // reset the user by clearing out the keychain items
                        print("\(error)")
                        PFUser.logOut()
                    }
                    else if success {
                        let installation = PFInstallation.currentInstallation()
                        installation.setObject(user, forKey: "user")
                        installation.saveInBackground()
                    }
                })
            }

//            Fabric.with([Answers.self, Crashlytics.self])
            
  
//            Fabric.sharedSDK().debug = true
//            Fabric.with([Crashlytics.self()])
            

            
        }
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

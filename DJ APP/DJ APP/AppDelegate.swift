//
//  AppDelegate.swift
//  DJ APP
//
//  Created by arturo ho on 8/24/17.
//  Copyright © 2017 Marquel and Micajuine App Team. All rights reserved.
//

import UIKit
import Firebase
import GooglePlaces
import GoogleMaps
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DJ APP")
        container.loadPersistentStores(completionHandler: {
            (storeDescription, error) in
            print(storeDescription)
            /*if let error = error as? NSError? {
                fatalError("Unresolved error \(error)")
            }*/
            })
        return container
    }()
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let error = error as NSError
                fatalError("Unresolved error \(error)")
            }
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
                
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        let storyboard = UIStoryboard(name: "breakOffStoryboard", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "breakOff")
        window?.rootViewController = initialViewController
        
        GMSPlacesClient.provideAPIKey("AIzaSyDe-HPBTtaESQvqk2ixTcMXNSlcGK1JJ7o")
        GMSServices.provideAPIKey("AIzaSyBPKOJvebe0Vp09zm_YTGcKAWeT2GndO20")
        
        // get current number of times app has been launched
        let currentCount = UserDefaults.standard.integer(forKey: "launchCount")
        
        // increment received number by one
        UserDefaults.standard.set(currentCount+1, forKey:"launchCount")
        
        // save changes to disk
        UserDefaults.standard.synchronize()
        
        UserDefaults.standard.set(0, forKey: "browseDJVisitCount")
        
        return true
    }

//    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
//        let handled = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
//
//        return handled
//    }
    
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
    }


}


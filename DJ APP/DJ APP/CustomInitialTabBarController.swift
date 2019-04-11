//
//  CustomInitialTabBarController.swift
//  DJ APP
//
//  Created by Marquel Hendricks on 1/16/18.
//  Copyright © 2018 Marquel and Micajuine App Team. All rights reserved.
//

import UIKit
import Firebase
import GoogleMaps

class CustomInitialTabBarController: UITabBarController {

    var guestID:String?
    
    let mapController = MapViewController()
    //let djTableView = DJTableViewController()
    let radioTableView = RadioDJsListController()
    var collectionsVC = DJMenuViewController()
    
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sb = UIStoryboard(name: "breakOffStoryboard", bundle: nil)
        let browseCollectionView = sb.instantiateViewController(withIdentifier: "BrowseDJsViewController") as! BrowseDJsViewController
        
        
        let mapNavController = UINavigationController()
        mapController.tabBarItem.title = "Map"
        mapController.tabBarItem.image = UIImage(named: "pin-map-7")
        mapNavController.viewControllers = [mapController]
    
        let djNavController = UINavigationController()
        collectionsVC.tabBarItem.title = "Live DJs"
        collectionsVC.tabBarItem.image = UIImage(named: "text-list-7")
        djNavController.viewControllers = [collectionsVC]
        
        let radioNavController = UINavigationController()
        radioTableView.tabBarItem.title = "Live Radio DJs"
        radioTableView.tabBarItem.image = UIImage(named: "text-list-7")
        radioNavController.viewControllers = [radioTableView]
        
        let browseNavController = UINavigationController()
        browseCollectionView.tabBarItem.title = "Browse All DJs"
        browseCollectionView.tabBarItem.image = UIImage(named: "icons8-dj-filled-20")
        browseNavController.viewControllers = [browseCollectionView]
        
        
        tabBar.barTintColor = UIColor.black
        tabBar.tintColor = UIColor(red: 214/255, green: 29/255, blue: 1, alpha:1.0)
        
        viewControllers = [mapNavController,djNavController,radioNavController,browseNavController]
        
        self.selectedIndex = 0
        //UIApplication.shared.statusBarStyle = .default
    }
    
    func handleBack() {
        do {
            try Auth.auth().signOut()
        }
        catch let error as NSError {
            print("Error with signing out of firebase: \(error.localizedDescription)")
        }
        dismiss(animated: true, completion: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setGuestIDs(id: String) {
        mapController.guestID = id
        collectionsVC.guestID = id
        radioTableView.guestID = id
        self.guestID = id
    }

}

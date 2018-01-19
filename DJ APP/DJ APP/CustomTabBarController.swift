//
//  CustomTabBarController.swift
//  DJ APP
//
//  Created by arturo ho on 9/28/17.
//  Copyright © 2017 Marquel and Micajuine App Team. All rights reserved.
//

import UIKit
import Firebase

class CustomTabBarController: UITabBarController {

    var dj: UserDJ?
    var guestID: String?
    
    let songController = SongTableViewController()
    let searchTrackController = SearchTrackViewController()
    let homeController = HomeViewController()
    let profilePicker = profileTabForCustomTabBarViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let songNavController = UINavigationController()
        songNavController.tabBarItem.title = "Songs"
        songNavController.tabBarItem.image = UIImage(named: "listIcon")
        songNavController.viewControllers = [songController]
    
        let profileNavController = UINavigationController()
        profilePicker.tabBarItem.title = "DJ Profile"
        profilePicker.tabBarItem.image = UIImage(named: "bioIcon")
        profileNavController.viewControllers = [profilePicker]
        
        searchTrackController.tabBarItem.title = "Search"
        searchTrackController.tabBarItem.image = UIImage(named: "searchIcon")
        
        homeController.tabBarItem.title = "DJ List"
        homeController.tabBarItem.image = UIImage(named: "Home-50")
    
        tabBar.barTintColor = UIColor.black
        tabBar.tintColor = UIColor.purple

        viewControllers = [homeController, songNavController, searchTrackController,profileNavController]
        
        self.selectedIndex = 1;
    }
    
    //Remove all results from search table when you move to a different screen... maybe not the best if I
    //Can't clear the text from search bar
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let index = item.index(ofAccessibilityElement: item)
        if (index != 2) {
            searchTrackController.results.removeAll()
            UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
            searchTrackController.searchController.isActive = false
        }
        else {
            UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setDJsAndGuestID(dj: UserDJ, id: String) {
        profilePicker.dj = dj
        songController.dj = dj
        searchTrackController.dj = dj
        homeController.djID = dj.uid
        self.dj = dj
        
        profilePicker.guestID = id
        songController.guestID = id
        searchTrackController.guestID = id
        homeController.guestID = id
        self.guestID = id
        
        if let uid = dj.uid {
            homeController.setUpRefs(uidKey: uid, id: id)
        }
        else {
            print("dj from set did not have uid")
        }
    }
}

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
    let searchController = SearchTrackViewController()
    let homeController = HomeViewController()
    let profileController = DJPRofileViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let songNavController = UINavigationController()
        songNavController.tabBarItem.title = "Songs"
        songNavController.tabBarItem.image = UIImage(named: "listIcon")
        songNavController.viewControllers = [songController]
    
        //let profileNavController = UINavigationController()
        profileController.tabBarItem.title = "DJ Profile"
        profileController.tabBarItem.image = UIImage(named: "bioIcon")
        //profileNavController.viewControllers = [profilePicker]
        
        let searchTrackController = UINavigationController()
        searchTrackController.tabBarItem.title = "Request a Song"
        searchTrackController.tabBarItem.image = UIImage(named: "searchIcon")
        searchTrackController.viewControllers = [searchController]

        
        homeController.tabBarItem.title = "DJ List"
        homeController.tabBarItem.image = UIImage(named: "Home-50")
    
        tabBar.barTintColor = UIColor.black
        tabBar.tintColor = UIColor.white

        viewControllers = [homeController, songNavController, searchTrackController, profileController]
        
        self.selectedIndex = 1;
        
        // Doing Pink Selection indicator.
        let numberOfItems = CGFloat((self.tabBar.items!.count))
        
        let tabBarItemSize = CGSize(width: (self.tabBar.frame.width) / numberOfItems,
                                    height: (self.tabBar.frame.height))
        
        self.tabBar.selectionIndicatorImage
            = UIImage.imageWithColor(color: UIColor(red: 214/255, green: 29/255, blue: 1, alpha:1.0),
                                     size: tabBarItemSize).resizableImage(withCapInsets: .zero)
        
        self.tabBar.frame.size.width = self.view.frame.width + 4
        self.tabBar.frame.origin.x = -2
        
    }
    
  
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let index = item.index(ofAccessibilityElement: item)
        if (index != 2) {
            searchController.results.removeAll()
            UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
            searchController.searchController.isActive = false
        }
        else {
            UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setDJsAndGuestID(dj: UserDJ, id: String) {
        profileController.dj = dj
        songController.dj = dj
        searchController.dj = dj
        homeController.djID = dj.uid
        self.dj = dj
        
        profileController.guestID = id
        songController.guestID = id
        searchController.guestID = id
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

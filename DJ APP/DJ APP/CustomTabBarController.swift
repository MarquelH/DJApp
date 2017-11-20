//
//  CustomTabBarController.swift
//  DJ APP
//
//  Created by arturo ho on 9/28/17.
//  Copyright © 2017 Marquel and Micajuine App Team. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {
    var dj: UserDJ?
    
    let songController = SongTableViewController()
    let searchTrackController = SearchTrackViewController()
    let profileController = DJPRofileViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let songNavController = UINavigationController()
        songNavController.tabBarItem.title = "Songs"
        songNavController.tabBarItem.image = UIImage(named: "listIcon")
        songNavController.viewControllers = [songController]
        
        searchTrackController.tabBarItem.title = "Search"
        searchTrackController.tabBarItem.image = UIImage(named: "searchIcon")
        
        profileController.tabBarItem.title = "DJ Profile"
        profileController.tabBarItem.image = UIImage(named: "bioIcon")
    
        tabBar.barTintColor = UIColor.black
        tabBar.tintColor = UIColor.purple

//        self.navigationController?.tabBarController?.tabBar.tintColor = UIColor(red: 214/255, green: 29/255, blue: 1, alpha:1.0)

        
        viewControllers = [songNavController,searchTrackController,profileController]
    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let index = item.index(ofAccessibilityElement: item)
        if (index != 1) {
            searchTrackController.results.removeAll()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

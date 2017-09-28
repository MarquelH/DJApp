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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup Tab Bar
        let songController = SongTableViewController()
        songController.dj = dj
        songController.tabBarItem.title = "Songs"
        
        let djListController = DJTableViewController()
        djListController.tabBarItem.title = "DJs"
        
        let searchTrackController = SearchTrackViewController()
        searchTrackController.tabBarItem.title = "Search"
        
        viewControllers = [djListController, songController, searchTrackController]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //Show navigation bar
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Hide navigation bar
        self.navigationController?.isNavigationBarHidden = true
    }
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if (item.tag == 0) {
            print("Home Clicked")
        }
    }
}

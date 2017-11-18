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
        
      
        songController.tabBarItem.title = "Songs"
        songController.tabBarItem.image = UIImage(named: "listIcon")
        songController.customTabBarController = self
        
        let songNavController = UINavigationController()
        songNavController.viewControllers = [songController]

        
        //Not a Navigation Controller
        searchTrackController.tabBarItem.title = "Search"
        searchTrackController.tabBarItem.image = UIImage(named: "searchIcon")
        
    
        
        profileController.tabBarItem.title = "DJ Profile"
        profileController.tabBarItem.image = UIImage(named: "bioIcon")
        //profileController.tabBarItem.badgeColor = UIColor(red: 214/255, green: 29/255, blue: 1, alpha: 0.5)
 
        
        
        viewControllers = [songNavController,searchTrackController,profileController]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        songController.dj = dj
        profileController.dj = dj
    }
    
    func dissmissTabBar() {
        self.dismiss(animated: true, completion: nil)
    }
    

}

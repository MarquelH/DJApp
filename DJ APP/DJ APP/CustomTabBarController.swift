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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let songNavController = UINavigationController(rootViewController: songController)
        songController.tabBarItem.title = "Songs"
        songController.tabBarItem.image = UIImage(named: "listIcon")
        songController.customTabBarController = self
        
        
        searchTrackController.tabBarItem.title = "Search"
        searchTrackController.tabBarItem.image = UIImage(named: "searchIcon")
        
        viewControllers = [songNavController, searchTrackController]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        songController.dj = dj
    }
    
    func dissmissTabBar() {
        self.dismiss(animated: true, completion: nil)
    }
    

}

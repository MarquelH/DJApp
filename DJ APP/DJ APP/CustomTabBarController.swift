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
    let profileController = DJPRofileViewController()
    let homeController = HomeViewController()
    
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
        
        homeController.tabBarItem.title = "DJ List"
        homeController.tabBarItem.image = UIImage(named: "Home-50")
    
        tabBar.barTintColor = UIColor.black
        tabBar.tintColor = UIColor.purple

//        self.navigationController?.tabBarController?.tabBar.tintColor = UIColor(red: 214/255, green: 29/255, blue: 1, alpha:1.0)

        viewControllers = [homeController, songNavController, searchTrackController, profileController]
        
        self.selectedIndex = 1;
        
    }
    

    //Remove all results from search table when you move to a different screen... maybe not the best if I
    //Can't clear the text from search bar
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let index = item.index(ofAccessibilityElement: item)
        if (index != 2) {
            searchTrackController.results.removeAll()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setGuestID(id: String) {
        songController.guestID = id
        searchTrackController.guestID = id
        profileController.guestID = id
    }
    
    func setDJs(dj: UserDJ) {
        profileController.dj = dj
        songController.dj = dj
        searchTrackController.dj = dj
        self.dj = dj
    }
    
    
    //remove observers from SongTableViewController
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let uid = dj?.uid, let name = dj?.djName, let handle = songController.handle {
            Database.database().reference().child("SongList").child(uid).removeObserver(withHandle: handle)
        }
        else {
            print("tabbar being removed does not have dj")
        }
    }
}

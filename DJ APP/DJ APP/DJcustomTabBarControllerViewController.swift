//
//  DJcustomTabBarControllerViewController.swift
//  DJ APP
//
//  Created by Marquel Hendricks on 1/4/18.
//  Copyright © 2018 Marquel and Micajuine App Team. All rights reserved.
//

import UIKit
import Firebase

class DJcustomTabBarControllerViewController: UITabBarController {

     var dj: UserDJ?
    
    let scheduleController = TabBarToAddEventViewController()
    let goLiveController = DJSongTableViewController()
    //let addEventController = addEventViewController()
    let profileController = TabBarToProfileViewController()
    let messagesController = MessagesViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.barTintColor = UIColor.black
        tabBar.tintColor = UIColor.purple
        
        goLiveController.tabBarItem.title = "Go Live"
        goLiveController.tabBarItem.image = UIImage(named: "bioIcon")
        
        scheduleController.tabBarItem.title = "Schedule"
        scheduleController.tabBarItem.image = UIImage(named: "searchIcon")
        
        profileController.tabBarItem.title = "Profile"
        profileController.tabBarItem.image = UIImage(named: "bioIcon")
        
        messagesController.tabBarItem.title = "Messages"
        messagesController.tabBarItem.image = UIImage(named: "Home-50")
        

//        viewControllers = [schedule,goLive,addEvent,profile,messages]
        viewControllers = [goLiveController, scheduleController, profileController,  messagesController]

    }

    
    func setDJs(dj: UserDJ) {
        goLiveController.dj = dj
        scheduleController.dj = dj
        profileController.dj = dj
        messagesController.dj = dj
        self.dj = dj
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   

}

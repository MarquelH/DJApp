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
    
    let schedule = scheduleViewController()
    let goLive = DJSongTableViewController()
    let addEvent = addEventViewController()
    let profile = DJSideProfileViewController()
    let messages = MessagesViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.barTintColor = UIColor.black
        tabBar.tintColor = UIColor.purple
        
        schedule.dj = dj
        goLive.dj = dj
        addEvent.dj = dj
        profile.dj = dj
        messages.dj = dj
        
        viewControllers = [schedule,goLive,addEvent,profile,messages]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

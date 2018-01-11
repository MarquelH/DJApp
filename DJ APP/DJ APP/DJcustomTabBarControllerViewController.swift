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
    
    let scheduleController = scheduleViewController()
    let goLiveController = DJSongTableViewController()
    let addEventController = addEventViewController()
    let profileController = DJSideProfileViewController()
    let messagesController = MessagesViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.barTintColor = UIColor.black
        tabBar.tintColor = UIColor.purple
        

        sendDJToViews()
    }

    
    
    func sendDJToViews() {
        //Setting DJ's according to view type.
        for theView in viewControllers! {
            if let v1 = theView as? scheduleViewController{
                v1.dj = dj
            }
            else if let v2 = theView as? DJSongTableViewController{
                v2.dj = dj
            }
            else if let v3 = theView as? addEventViewController{
                v3.dj = dj
            }
            else if let v4 = theView as? DJSideProfileViewController{
                v4.dj = dj
            }
            else if let v5 = theView as? MessagesViewController{
                v5.dj = dj
            }
            else if let v6 = theView as? NavForTableViewController{
                v6.dj = dj
            }
            else{
                print("Not the right view controller")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   

}

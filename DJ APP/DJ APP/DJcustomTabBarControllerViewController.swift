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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.barTintColor = UIColor.black
        tabBar.tintColor = UIColor(red: 214/255, green: 29/255, blue: 1, alpha:1.0)
        sendDJToViews()
    }

    
    
    func sendDJToViews() {
        //Setting DJ's according to view type.
        //print(self.viewControllers!)
        for theView in self.viewControllers! {
            if let v1 = theView as? scheduleViewController{
                //print("PUTTING IT HERE1")
                v1.dj = dj
            }
            else if let v2 = theView as? DJSongTableViewController{
                //print("PUTTING IT HERE2")
                v2.dj = dj
            }
            else if let v3 = theView as? addEventViewController{
                //print("PUTTING IT HERE3")
                v3.dj = dj
            }
            else if let v4 = theView as? DJSideProfileViewController{
                //print("PUTTING IT HERE4")
                v4.dj = dj
            }
            else if let v5 = theView as? MessagesTableViewController{
                //print("PUTTING IT HERE5")
                v5.dj = dj
            }
            else if let v6 = theView as? NavForTableViewController{
                //print("PUTTING IT HERE6")
                v6.dj = dj
            }
            else{
                //print(theView)
                //print("Not the right view controller")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   

}

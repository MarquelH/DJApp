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
        tabBar.tintColor = UIColor.white
        

        sendDJToViews()
        
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

    
    
    func sendDJToViews() {
        //Setting DJ's according to view type.
        for theView in self.viewControllers! {
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
            else if let v5 = theView as? MessagesTableViewController{
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

//
//  CustomInitialTabBarController.swift
//  DJ APP
//
//  Created by Marquel Hendricks on 1/16/18.
//  Copyright © 2018 Marquel and Micajuine App Team. All rights reserved.
//

import UIKit
import Firebase
import GoogleMaps

class CustomInitialTabBarController: UITabBarController {

    var guestID:String?
    
    let mapController = MapViewController()
    let djTableView = DJTableViewController()
    var myConstant: CGFloat = 0
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let mapNavController = UINavigationController()
        mapController.tabBarItem.title = "Map of DJs"
        mapController.tabBarItem.image = UIImage(named: "pin-map-7")
        mapNavController.viewControllers = [mapController]
    
        let djNavController = UINavigationController()
        djTableView.tabBarItem.title = "List of DJs"
        djTableView.tabBarItem.image = UIImage(named: "text-list-7")
        djNavController.viewControllers = [djTableView]
        
        tabBar.barTintColor = UIColor.black
        tabBar.tintColor = UIColor.purple
        
        viewControllers = [mapNavController,djNavController]
        
        self.selectedIndex = 0
        UIApplication.shared.statusBarStyle = .default
        
      
        /*if UIScreen.main.bounds.size.height == 480 {
            // iPhone 4
            myConstant = 10
        } else if UIScreen.main.bounds.size.height == 568 {
            // iPhone 5
            myConstant = 20
        } else if UIScreen.main.bounds.size.width == 375 {
            // iPhone 6
            myConstant = 30
        } else if UIScreen.main.bounds.size.width == 414 {
            // iPhone 6+
            myConstant = 40
        }
        
        var myConstraint = NSLayoutConstraint (item: myButton,
                                               attribute: NSLayoutAttribute.Top,
                                               relatedBy: NSLayoutRelation.Equal,
                                               toItem: self.view,
                                               attribute: NSLayoutAttribute.Top,
                                               multiplier: 1,
                                               constant: myConstant)
        self.view.addConstraint(myConstraint)*/
    }
    
    func handleBack() {
        do {
            try Auth.auth().signOut()
        }
        catch let error as NSError {
            print("Error with signing out of firebase: \(error.localizedDescription)")
        }
        dismiss(animated: true, completion: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setGuestIDs(id: String) {
        mapController.guestID = id
        djTableView.guestID = id
        self.guestID = id
    }

}
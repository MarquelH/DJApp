//
//  DJTabController.swift
//  DJ APP
//
//  Created by Marquel Hendricks on 12/22/17.
//  Copyright © 2017 Marquel and Micajuine App Team. All rights reserved.
//

import UIKit
import Firebase

class DJTabController: UITabBarController {
    
    let homeController = schedulingViewController()
    let addEventCont = addEventViewController()
    let djRoot = DJRootViewController()
    let eventsTable = EventsTableViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.view.backgroundColor = UIColor.white
        
        tabBar.barTintColor = UIColor.black
        tabBar.tintColor = UIColor.purple
        
        viewControllers = [eventsTable,addEventCont]
    }
    
    @IBAction func addTapped(_ sender: Any) {
        present(addEventCont, animated: true, completion: nil)
    }
    
    @IBAction func backTapped(_ sender: Any) {
        present(djRoot, animated: true, completion: nil)
    }
    
    
    
}

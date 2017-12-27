//
//  DJTabController.swift
//  DJ APP
//
//  Created by Marquel Hendricks on 12/22/17.
//  Copyright © 2017 Marquel and Micajuine App Team. All rights reserved.
//

import UIKit

class DJTabController: UITabBarController {
    
    let homeController = schedulingViewController()
    let addEventCont = addEventViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.view.backgroundColor = UIColor.white
        
        tabBar.barTintColor = UIColor.black
        tabBar.tintColor = UIColor.purple
        
        //viewControllers = [homeController,addEventCont]
    }
    
    @IBAction func addTapped(_ sender: Any) {
        
    }
    
    
}

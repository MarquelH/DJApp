//
//  TabBarToAddEventViewController.swift
//  DJ APP
//
//  Created by arturo ho on 1/8/18.
//  Copyright © 2018 Marquel and Micajuine App Team. All rights reserved.
//

import UIKit

class TabBarToAddEventViewController: UIViewController {

    var dj: UserDJ?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //Again, if you check for DJ in viewdidload it will fail.
    //Thus you have to check for it before this view appears and then
    //present teh storyboard.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if dj != nil {
            handleSchedulingEnter()
        }
        else {
            print("view will appear does not have DJ")
        }
    }

    func handleSchedulingEnter(){
        
        let storyboard = UIStoryboard(name: "ScehdulingStoryboard", bundle:nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "scheduleView") as! scheduleViewController
        controller.dj = dj
        self.present(controller, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

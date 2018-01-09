//
//  TabBarToProfileViewController.swift
//  DJ APP
//
//  Created by arturo ho on 1/8/18.
//  Copyright © 2018 Marquel and Micajuine App Team. All rights reserved.
//

import UIKit

class TabBarToProfileViewController: UIViewController {

    var dj: UserDJ?
    
    //The view loads when you instantiate it in the parent view controller
    //this means that it has not assigned DJ to this controller.
    //thus if you try to use DJ here, it will fail.
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //Thus you have to do your user DJ assignemnts here.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if dj != nil {
            handleDJProfileEnter()
        }
        else {
            print("view will appear does not have DJ")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    func handleDJProfileEnter(){
        guard let currDj = dj else {
            print("Tabbar to profile has no dj")
            return
        }
        let storyboard = UIStoryboard(name: "ScehdulingStoryboard", bundle:nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "DJSideProfileController") as! DJSideProfileViewController
        controller.dj = currDj
        self.present(controller, animated: true, completion: nil)
    }
}

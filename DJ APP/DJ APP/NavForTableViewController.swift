//
//  NavForTableViewController.swift
//  DJ APP
//
//  Created by Marquel Hendricks on 1/10/18.
//  Copyright © 2018 Marquel and Micajuine App Team. All rights reserved.
//

import UIKit
import Firebase

class NavForTableViewController: UINavigationController {

    var dj: UserDJ?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for child in self.childViewControllers {
            if let v1 = child as? DJSongTableViewController{
                v1.dj = dj
            }
            if let v2 = child as? MessagesTableViewController{
                //print("PUTTING IT HEREEEEE")
                v2.dj = dj
            }
            if let v3 = child as? scheduleViewController{
                v3.dj = dj
            }
            if let v4 = child as? addEventViewController{
                v4.dj = dj
            }
            if let v5 = child as? DJSideProfileViewController{
                v5.dj = dj
            }
            else{
                //print(child)
                //print("Unrecognized VC")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

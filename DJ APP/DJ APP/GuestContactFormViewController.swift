//
//  GuestContactFormViewController.swift
//  DJ APP
//
//  Created by Marquel Hendricks on 1/19/18.
//  Copyright © 2018 Marquel and Micajuine App Team. All rights reserved.
//

import UIKit

class GuestContactFormViewController: UIViewController {

    var dj: UserDJ?
    var guestID: String?
    
    
    @IBOutlet weak var djContactFormLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLabel()
        // Do any additional setup after loading the view.
    }
    
    func setupLabel(){
        djContactFormLabel.adjustsFontSizeToFitWidth = true
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

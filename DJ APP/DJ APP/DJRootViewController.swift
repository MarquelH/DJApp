//
//  DJRootViewController.swift
//  DJ APP
//
//  Created by arturo ho on 8/28/17.
//  Copyright © 2017 Marquel and Micajuine App Team. All rights reserved.
//

import UIKit
import Firebase

class DJRootViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        self.view.backgroundColor = UIColor.white
    }
    
    func setupNavigationBar() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
    }
    
    
    func handleLogout() {
        let fireAuth = Auth.auth()
        
        do {
            try fireAuth.signOut()
        } catch let signoutError as NSError {
            print("Error signing out: %@", signoutError)
        }
        
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
    }


}

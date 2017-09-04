//
//  DJRootViewController.swift
//  DJ APP
//
//  Created by arturo ho on 8/28/17.
//  Copyright © 2017 Marquel and Micajuine App Team. All rights reserved.
//

import UIKit

class DJRootViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()

        self.view.backgroundColor = UIColor.white
    }
    
    // Not sure why the below didn't work.... (I see no nav bar)
    func setupNavigationBar() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleCancel))
    }
    
    func handleCancel() {
        print("Pop off stack")
        self.navigationController?.popViewController(animated: true)
    }


}

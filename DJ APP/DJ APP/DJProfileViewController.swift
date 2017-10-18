//
//  DJProfileViewController.swift
//  DJ APP
//
//  Created by Marquel Hendricks on 10/12/17.
//  Copyright © 2017 Marquel and Micajuine App Team. All rights reserved.
//

import UIKit
import FirebaseDatabase

class DJPRofileViewController: UIViewController {
    
    var dj: UserDJ?
    var customTabBarController: CustomTabBarController?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Exo-Thin", size : 19) as Any]
        setupViews()
        self.view.backgroundColor = UIColor.gray
        self.navigationController?.navigationBar.barTintColor = UIColor.clear
        self.navigationController?.navigationBar.backgroundColor = UIColor.clear
    }
    lazy var profilePic: UIImageView = {
        let pp = UIImageView()
        pp.alpha = 0.85
        pp.image = UIImage(named: "usernameIcon")
        pp.contentMode = .scaleAspectFill
        pp.layer.cornerRadius = 60
        pp.clipsToBounds = true
        pp.layer.borderWidth = 1.0
        pp.layer.borderColor = UIColor.black.cgColor
        pp.translatesAutoresizingMaskIntoConstraints = false
        //pp.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleImageSelection)))
        return pp
    }()
    
    let hometownLabel: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = UIColor.clear
        lbl.textColor = UIColor.black
        lbl.font = UIFont(name: "Exo-Thin", size : 25)
        lbl.text = "Hometown"
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let separator: UIView = {
        let s = UIView()
        s.translatesAutoresizingMaskIntoConstraints = false
        s.backgroundColor = UIColor.black
        return s
    }()

    //hometown, dj name, genre, twitter/IG

    
    func setupViews() {
        if let name = dj?.djName {
            //self.navigationItem.title = "\(name)" + "'s Profile"
        }
        //self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleBack))
        //self.navigationItem.leftBarButtonItem?.tintColor = UIColor(red: 214/255, green: 29/255, blue: 1, alpha:1.0)
        view.addSubview(profilePic)
        view.addSubview(hometownLabel)
        
        profilePic.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profilePic.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 14).isActive = true
        profilePic.widthAnchor.constraint(equalToConstant: 135).isActive = true
        profilePic.heightAnchor.constraint(equalToConstant: 135).isActive = true
        
        hometownLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        hometownLabel.topAnchor.constraint(equalTo: profilePic.bottomAnchor, constant: 43).isActive = true
        hometownLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        
    }
    
    
}





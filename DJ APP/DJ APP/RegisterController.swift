//
//  RegisterController.swift
//  DJ APP
//
//  Created by arturo ho on 8/28/17.
//  Copyright © 2017 Marquel and Micajuine App Team. All rights reserved.
//

import UIKit

class RegisterController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundImage: UIImageView = UIImageView(frame: view.bounds)
        backgroundImage.image = UIImage(named: "djBackgroundImage")
        backgroundImage.contentMode = .scaleAspectFill
        view.insertSubview(backgroundImage, at: 0)
        
        setupViews()
    }
    
    let profilePic: UIImageView = {
        let pp = UIImageView()
        pp.image = UIImage(named: "usernameIcon")
        pp.contentMode = .scaleAspectFit
        pp.layer.cornerRadius = 12
        pp.clipsToBounds = true
        pp.layer.borderWidth = 3.0
        pp.layer.borderColor = UIColor.white.cgColor
        pp.translatesAutoresizingMaskIntoConstraints = false
        return pp
    }()
    
    func setupViews(){
        
        view.addSubview(profilePic)
        
        
        profilePic.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profilePic.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -65).isActive = true
        profilePic.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -35).isActive = true
        profilePic.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
}

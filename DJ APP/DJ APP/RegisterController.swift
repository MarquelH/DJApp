//
//  RegisterController.swift
//  DJ APP
//
//  Created by arturo ho on 8/28/17.
//  Copyright © 2017 Marquel and Micajuine App Team. All rights reserved.
//

import UIKit

class RegisterController: UIViewController {

//    let profilePic: UIImageView = {
//        let pp = UIImageView()
//        pp.image = UIImage(named: "usernameIcon")
//        pp.contentMode = .scaleAspectFit
//        pp.layer.cornerRadius = 30
//        pp.clipsToBounds = true
//        pp.layer.borderWidth = 1.0
//        pp.layer.borderColor = UIColor.black.cgColor
//        pp.translatesAutoresizingMaskIntoConstraints = false
//        return pp
//    }()
    
    let profilePicButton: UIButton = {
        let ppb = UIButton(type: UIButtonType.custom)
        let image = UIImage(named: "usernameIcon")
        ppb.addTarget(self, action: #selector(handlePicTapped), for: .touchUpInside)
        ppb.setImage(image, for: .normal)
        ppb.translatesAutoresizingMaskIntoConstraints = false
        return ppb
    }()
    
    let cancelButton: UIBarButtonItem = {
        let cb = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        return cb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let backgroundImage: UIImageView = UIImageView(frame: view.bounds)
//        backgroundImage.image = UIImage(named: "djBackgroundImage")
//        backgroundImage.contentMode = .scaleAspectFill
//        view.insertSubview(backgroundImage, at: 0)

        view.backgroundColor = UIColor.white
        
       
        setupNavigationBar()
        setupViews()
    }

    func setupNavigationBar() {
        self.navigationItem.title = "Enter Info"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(handleCancel))
    }
    
    func setupViews(){
        view.addSubview(profilePicButton)
        
        profilePicButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profilePicButton.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 25).isActive = true
        profilePicButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        profilePicButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    func handlePicTapped() {
        print("Add image here...")
    }
    
    func handleCancel() {
        print("Dissmissing register controller")
        self.dismiss(animated: true, completion: nil)
    }
}

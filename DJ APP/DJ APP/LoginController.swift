//
//  LoginController.swift
//  DJ APP
//
//  Created by arturo ho on 8/24/17.
//  Copyright © 2017 Marquel and Micajuine App Team. All rights reserved.
//

import UIKit

class LoginController: UIViewController {
 
    let djGuestLoginButton: UIButton = {
        let lb = UIButton(type: .system)
        lb.setTitle("Login", for: .normal)
        lb.backgroundColor = UIColor.brown
        lb.layer.cornerRadius = 40
        lb.layer.borderWidth = 2
        lb.layer.borderColor = UIColor.white.cgColor
        lb.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    let usernameContainer: UIView = {
        let cv = UIView()
        cv.backgroundColor = UIColor(white: 1, alpha: 0.5)
        cv.layer.masksToBounds = true
        cv.layer.cornerRadius = 30
        cv.layer.borderWidth = 2
        cv.layer.borderColor = UIColor.white.cgColor
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    let passwordContainer: UIView = {
        let cv = UIView()
        cv.backgroundColor = UIColor(white: 1, alpha: 0.5)
        cv.layer.masksToBounds = true
        cv.layer.cornerRadius = 30
        cv.layer.borderWidth = 2
        cv.layer.borderColor = UIColor.white.cgColor
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
  
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        view.backgroundColor = UIColor.green
    }

    func setupViews() {
        view.addSubview(djGuestLoginButton)
        view.addSubview(usernameContainer)
        view.addSubview(passwordContainer)
        
        //ios 9 constraints x,y,w,h
        usernameContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        usernameContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        usernameContainer.heightAnchor.constraint(equalToConstant: 60).isActive = true
        usernameContainer.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        
        passwordContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        passwordContainer.topAnchor.constraint(equalTo: usernameContainer.bottomAnchor, constant: 12).isActive = true
        passwordContainer.heightAnchor.constraint(equalToConstant: 60).isActive = true
        passwordContainer.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        
        djGuestLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        djGuestLoginButton.topAnchor.constraint(equalTo: passwordContainer.bottomAnchor, constant: 24).isActive = true
        djGuestLoginButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
        djGuestLoginButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        
    }
    

}

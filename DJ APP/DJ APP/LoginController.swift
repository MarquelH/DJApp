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
        lb.backgroundColor = UIColor.black.withAlphaComponent(0.25)
        lb.layer.cornerRadius = 40
        lb.layer.borderWidth = 1
        lb.layer.borderColor = UIColor.white.cgColor
        lb.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    let usernameContainer: UIView = {
        let cv = UIView()
        cv.backgroundColor = UIColor(white: 1, alpha: 0.5)
        cv.layer.masksToBounds = true
        cv.layer.cornerRadius = 30
        cv.layer.borderWidth = 0.5
        cv.layer.borderColor = UIColor.black.cgColor
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    let passwordContainer: UIView = {
        let cv = UIView()
        cv.backgroundColor = UIColor(white: 1, alpha: 0.5)
        cv.layer.masksToBounds = true
        cv.layer.cornerRadius = 30
        cv.layer.borderWidth = 0.5
        cv.layer.borderColor = UIColor.black.cgColor
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
  
    let usernameTextField: UITextField = {
        let tf = UITextField()
        tf.font = UIFont.boldSystemFont(ofSize: 20)
        tf.placeholder = "Username"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.font = UIFont.boldSystemFont(ofSize: 20)
        tf.isSecureTextEntry = true
        tf.placeholder = "Password"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let usernameImage: UIImageView = {
        let ui = UIImageView()
        ui.image = UIImage(named: "usernameIcon")
        ui.contentMode = .scaleAspectFill
        ui.translatesAutoresizingMaskIntoConstraints = false
        return ui
    }()
    
    let passwordImage: UIImageView = {
        let ui = UIImageView()
        ui.translatesAutoresizingMaskIntoConstraints = false
        ui.contentMode = .scaleAspectFill
        ui.image = UIImage(named: "passwordIcon")
        return ui
    }()
    

    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundImage: UIImageView = UIImageView(frame: view.bounds)
        backgroundImage.image = UIImage(named: "djBackgroundImage")
        backgroundImage.contentMode = .scaleAspectFill
        view.insertSubview(backgroundImage, at: 0)
        
        setupViews()
      
        
    }

    func setupViews() {
        view.addSubview(djGuestLoginButton)
        view.addSubview(usernameContainer)
        view.addSubview(passwordContainer)
        usernameContainer.addSubview(usernameTextField)
        usernameContainer.addSubview(usernameImage)
        passwordContainer.addSubview(passwordTextField)
        passwordContainer.addSubview(passwordImage)
        
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
        
        
        usernameImage.centerYAnchor.constraint(equalTo: usernameContainer.centerYAnchor).isActive = true
        usernameImage.leftAnchor.constraint(equalTo: usernameContainer.leftAnchor, constant: 12).isActive = true
        usernameImage.heightAnchor.constraint(equalToConstant: 25).isActive = true
        usernameImage.widthAnchor.constraint(equalToConstant: 25).isActive = true
        
        
        passwordImage.centerYAnchor.constraint(equalTo: passwordContainer.centerYAnchor).isActive = true
        passwordImage.leftAnchor.constraint(equalTo: usernameContainer.leftAnchor, constant: 12).isActive = true
        passwordImage.heightAnchor.constraint(equalToConstant: 25).isActive = true
        passwordImage.widthAnchor.constraint(equalToConstant: 25).isActive = true
        
        
        usernameTextField.topAnchor.constraint(equalTo: usernameContainer.topAnchor, constant: 5).isActive = true
        usernameTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        usernameTextField.rightAnchor.constraint(equalTo: usernameContainer.rightAnchor, constant: -12).isActive = true
        usernameTextField.leftAnchor.constraint(equalTo: usernameImage.rightAnchor, constant: 12).isActive = true
        
        
        passwordTextField.topAnchor.constraint(equalTo: passwordContainer.topAnchor, constant: 5).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        passwordTextField.rightAnchor.constraint(equalTo: passwordContainer.rightAnchor, constant: -12).isActive = true
        passwordTextField.leftAnchor.constraint(equalTo: passwordImage.rightAnchor, constant: 12).isActive = true
        
        
    }
    

}

//
//  ViewController.swift
//  DJ APP
//
//  Created by arturo ho on 9/3/17.
//  Copyright © 2017 Marquel and Micajuine App Team. All rights reserved.
//

import UIKit

class RegisterController: UIViewController {

    var loginController: LoginController?
    
    let headphonesLogo: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "headphones")
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleAspectFill
        return img
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
    
    let usernameTextField: UITextField = {
        let htf = UITextField()
        htf.placeholder = "Email"
        htf.clearButtonMode = .whileEditing
        htf.translatesAutoresizingMaskIntoConstraints = false
        return htf
    }()
    
    let passwordTextField: UITextField = {
        let htf = UITextField()
        htf.placeholder = "Password"
        htf.clearButtonMode = .whileEditing
        htf.isSecureTextEntry = true
        htf.translatesAutoresizingMaskIntoConstraints = false
        return htf
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
    
    let reenterPasswordTextField: UITextField = {
        let htf = UITextField()
        htf.placeholder = "Confirm Password"
        htf.clearButtonMode = .whileEditing
        htf.isSecureTextEntry = true
        htf.translatesAutoresizingMaskIntoConstraints = false
        return htf
    }()
    let reenterPasswordContainer: UIView = {
        let cv = UIView()
        cv.backgroundColor = UIColor(white: 1, alpha: 0.5)
        cv.layer.masksToBounds = true
        cv.layer.cornerRadius = 30
        cv.layer.borderWidth = 0.5
        cv.layer.borderColor = UIColor.black.cgColor
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    let backgroundImage: UIImageView = {
        let bi = UIImageView()
        bi.image = UIImage(named: "headphonesImage")
        bi.translatesAutoresizingMaskIntoConstraints = false
        bi.contentMode = .scaleAspectFill
        bi.layer.masksToBounds = true
        return bi
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = UIColor.clear
        setupNavigationBar()
        setupViews()
    }
    
    func handleCancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    //Present Addinfo controller and pass in
    func handleContinue() {
        guard let username = usernameTextField.text, let password = passwordTextField.text, let passwordAgain = reenterPasswordTextField.text else {
            return
        }
        
        //Check if the username and password are valid 
        if (username != "" && password != "" && password == passwordAgain) {
            let addInfoController = AddInfoController()
            addInfoController.loginController = loginController
            addInfoController.username = username
            addInfoController.password = password
            self.navigationController?.pushViewController(addInfoController, animated: true)
        }
        else {
            let alert = UIAlertController(title: "Invalid Entries", message: "Username and password must be valid", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: { action in
                self.usernameTextField.text = ""
                self.passwordTextField.text = ""
                self.reenterPasswordTextField.text = ""
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func setupNavigationBar() {
        self.navigationItem.title = "Login Information"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(handleContinue))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 214/255, green: 29/255, blue: 1, alpha:1.0)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor(red: 214/255, green: 29/255, blue: 1, alpha:1.0)
    }
    
    func setupViews() {
        view.addSubview(backgroundImage)
        view.addSubview(passwordContainer)
        view.addSubview(reenterPasswordContainer)
        view.addSubview(usernameContainer)
        view.addSubview(headphonesLogo)
        usernameContainer.addSubview(usernameTextField)
        passwordContainer.addSubview(passwordTextField)
        reenterPasswordContainer.addSubview(reenterPasswordTextField)

        //let quarterHeight = view.frame.height / 3
        
        backgroundImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        backgroundImage.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        backgroundImage.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        backgroundImage.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
        
        headphonesLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        headphonesLogo.topAnchor.constraint(equalTo: reenterPasswordContainer.bottomAnchor, constant: 115).isActive = true
        headphonesLogo.heightAnchor.constraint(equalToConstant: 45).isActive = true
        headphonesLogo.widthAnchor.constraint(equalToConstant: 105).isActive = true
        
        
        usernameTextField.leftAnchor.constraint(equalTo: usernameContainer.leftAnchor, constant: 10).isActive = true
        usernameTextField.topAnchor.constraint(equalTo: usernameContainer.topAnchor, constant: 5).isActive = true
        usernameTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        usernameTextField.widthAnchor.constraint(equalTo: usernameContainer.widthAnchor, constant: -15).isActive = true

        usernameContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        usernameContainer.topAnchor.constraint(equalTo: view.topAnchor, constant: 145).isActive = true
        usernameContainer.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -15).isActive = true
        usernameContainer.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        passwordTextField.leftAnchor.constraint(equalTo: passwordContainer.leftAnchor, constant: 10).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: passwordContainer.topAnchor, constant: 5).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: passwordContainer.widthAnchor, constant: -15).isActive = true
        
        passwordContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        passwordContainer.topAnchor.constraint(equalTo: usernameContainer.bottomAnchor, constant: 36).isActive = true
        passwordContainer.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -15).isActive = true
        passwordContainer.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        reenterPasswordTextField.leftAnchor.constraint(equalTo: reenterPasswordContainer.leftAnchor, constant: 10).isActive = true
        reenterPasswordTextField.topAnchor.constraint(equalTo: reenterPasswordContainer.topAnchor, constant: 5).isActive = true
        reenterPasswordTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        reenterPasswordTextField.widthAnchor.constraint(equalTo: reenterPasswordContainer.widthAnchor, constant: -15).isActive = true
        
        reenterPasswordContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        reenterPasswordContainer.topAnchor.constraint(equalTo: passwordContainer.bottomAnchor, constant: 36).isActive = true
        reenterPasswordContainer.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -15).isActive = true
        reenterPasswordContainer.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
    }
}

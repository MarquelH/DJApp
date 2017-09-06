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
    
    
    let usernameTextField: UITextField = {
        let htf = UITextField()
        htf.placeholder = "     Username"
        htf.backgroundColor = UIColor(white: 1, alpha: 0.5)
        htf.layer.masksToBounds = true
        htf.layer.cornerRadius = 25
        htf.layer.borderWidth = 0.5
        htf.layer.borderColor = UIColor.black.cgColor
        htf.clearButtonMode = .whileEditing
        htf.translatesAutoresizingMaskIntoConstraints = false
        return htf
    }()
    
    let logoGo: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "GO")
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    let logoDJ: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "DJ")
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    let passwordTextField: UITextField = {
        let htf = UITextField()
        htf.placeholder = "     Password"
        htf.backgroundColor = UIColor(white: 1, alpha: 0.5)
        htf.layer.masksToBounds = true
        htf.layer.cornerRadius = 25
        htf.layer.borderWidth = 0.5
        htf.layer.borderColor = UIColor.black.cgColor
        htf.clearButtonMode = .whileEditing
        htf.isSecureTextEntry = true
        htf.translatesAutoresizingMaskIntoConstraints = false
        return htf
    }()
    
    let reenterPasswordTextField: UITextField = {
        let htf = UITextField()
        htf.placeholder = "     Confirm Password"
        htf.backgroundColor = UIColor(white: 1, alpha: 0.5)
        htf.layer.masksToBounds = true
        htf.layer.cornerRadius = 25
        htf.layer.borderWidth = 0.5
        htf.layer.borderColor = UIColor.black.cgColor
        htf.clearButtonMode = .whileEditing
        htf.isSecureTextEntry = true
        htf.translatesAutoresizingMaskIntoConstraints = false
        return htf
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backgroundImage: UIImageView = UIImageView(frame: view.bounds)
        backgroundImage.image = UIImage(named: "headphonesImage")
        backgroundImage.contentMode = .scaleAspectFill
        view.insertSubview(backgroundImage, at: 0)
        setupNavigationBar()
        setupViews()
    }
    
    func handleCancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    //Present Addinfo controller and pass in
    func handleContinue() {
        guard let username = usernameTextField.text, let password = passwordTextField.text, let passwordAgain = reenterPasswordTextField.text else {
            print("Not valid input ")
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
            print ("You must have good login inputs")
        }
        
    }
    
    func setupNavigationBar() {
        self.navigationItem.title = "Login Information"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(handleContinue))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
    }
    
    func setupViews() {
        view.addSubview(usernameTextField)
        view.addSubview(passwordTextField)
        view.addSubview(reenterPasswordTextField)
        view.addSubview(logoGo)
        view.addSubview(logoDJ)


        let quarterHeight = view.frame.height / 3
        
        usernameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        usernameTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: quarterHeight).isActive = true
        usernameTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        usernameTextField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -17).isActive = true

        logoGo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoGo.topAnchor.constraint(equalTo: reenterPasswordTextField.bottomAnchor, constant: 63).isActive = true
        logoGo.heightAnchor.constraint(equalToConstant: 27).isActive = true
        logoGo.widthAnchor.constraint(equalToConstant: 70).isActive = true
        
        
        logoDJ.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 1).isActive = true
        logoDJ.topAnchor.constraint(equalTo: logoGo.bottomAnchor, constant: 10).isActive = true
        logoDJ.heightAnchor.constraint(equalToConstant: 27).isActive = true
        logoDJ.widthAnchor.constraint(equalToConstant: 70).isActive = true
        
        
        passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 36).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -17).isActive = true
        
        reenterPasswordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        reenterPasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 36).isActive = true
        reenterPasswordTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        reenterPasswordTextField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -17).isActive = true
        
    }
}

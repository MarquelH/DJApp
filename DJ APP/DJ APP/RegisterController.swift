//
//  ViewController.swift
//  DJ APP
//
//  Created by arturo ho on 9/3/17.
//  Copyright © 2017 Marquel and Micajuine App Team. All rights reserved.
//

import UIKit
import LocalAuthentication

class RegisterController: UIViewController, UITextFieldDelegate {

    var loginController: DJLoginController?
    
    let headphonesLogo: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "headphones")
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    let usernameContainer: UIView = {
        let cv = UIView()
        cv.backgroundColor = UIColor.black
        cv.layer.masksToBounds = true
        cv.layer.cornerRadius = 30
        cv.layer.borderWidth = 0.5
        cv.layer.borderColor = UIColor.white.cgColor
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    let usernameTextField: UITextField = {
        let htf = UITextField()
        let placeHolderText = "Email"
        htf.attributedPlaceholder = NSAttributedString(string: placeHolderText,
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        htf.clearButtonMode = .whileEditing
        htf.translatesAutoresizingMaskIntoConstraints = false
        htf.backgroundColor = UIColor.black
        htf.textColor = UIColor.white
        htf.font = UIFont(name: "BebasNeue-Regular", size: 20)
        return htf
    }()
    
    let passwordTextField: UITextField = {
        let htf = UITextField()
        let placeHolderText = "Password (Must be at least 6 characters)"
        htf.attributedPlaceholder = NSAttributedString(string: placeHolderText,
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        htf.backgroundColor = UIColor.black
        htf.clearButtonMode = .whileEditing
        htf.isSecureTextEntry = true
        htf.translatesAutoresizingMaskIntoConstraints = false
        htf.textColor = UIColor.white
        htf.font = UIFont(name: "BebasNeue-Regular", size: 20)
        return htf
    }()
    
    let passwordContainer: UIView = {
        let cv = UIView()
        cv.backgroundColor = UIColor.black
        cv.layer.masksToBounds = true
        cv.layer.cornerRadius = 30
        cv.layer.borderWidth = 0.5
        cv.layer.borderColor = UIColor.white.cgColor
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    let reenterPasswordTextField: UITextField = {
        let htf = UITextField()
        let placeHolderText = "Confirm Password"
        htf.attributedPlaceholder = NSAttributedString(string: placeHolderText,
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        htf.clearButtonMode = .whileEditing
        htf.isSecureTextEntry = true
        htf.textColor = UIColor.white
        htf.translatesAutoresizingMaskIntoConstraints = false
        htf.font = UIFont(name: "BebasNeue-Regular", size: 20)
        return htf
    }()
    let reenterPasswordContainer: UIView = {
        let cv = UIView()
        cv.backgroundColor = UIColor.black
        cv.layer.masksToBounds = true
        cv.layer.cornerRadius = 30
        cv.layer.borderWidth = 0.5
        cv.layer.borderColor = UIColor.white.cgColor
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    /*let backgroundImage: UIImageView = {
        let bi = UIImageView()
        bi.image = UIImage(named: "headphonesImage")
        bi.translatesAutoresizingMaskIntoConstraints = false
        bi.contentMode = .scaleAspectFill
        bi.layer.masksToBounds = true
        return bi
    }()*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = UIColor.clear
        setupNavigationBar()
        setupViews()
        self.usernameTextField.delegate = self
        self.passwordTextField.delegate = self
        self.reenterPasswordTextField.delegate = self
        self.view.backgroundColor = UIColor.black
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @objc func handleCancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    //Present Addinfo controller and pass in
    @objc func handleContinue() {
        guard let username = usernameTextField.text, let password = passwordTextField.text, let passwordAgain = reenterPasswordTextField.text else {
            return
        }
        
        let realUsername = username.trimmingCharacters(in: .whitespaces)
        let realPassword = password.trimmingCharacters(in: .whitespaces)
        let realConfirmPassword = passwordAgain.trimmingCharacters(in: .whitespaces)
        
        //Check if the username and password are valid 
        if (realUsername != "" && realPassword != "" && realPassword == realConfirmPassword) {
            let addInfoController = AddInfoController()
            addInfoController.loginController = loginController
            addInfoController.username = realUsername
            addInfoController.password = realPassword
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
        self.navigationItem.title = "Login Creds"
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont(name: "BebasNeue-Regular", size: 40) as Any]
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(handleContinue))
        //self.navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 214/255, green: 29/255, blue: 1, alpha:1.0)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        //self.navigationItem.leftBarButtonItem?.tintColor = UIColor(red: 214/255, green: 29/255, blue: 1, alpha:1.0)
    }
    
    func setupViews() {
        view.addSubview(passwordContainer)
        view.addSubview(reenterPasswordContainer)
        view.addSubview(usernameContainer)
        view.addSubview(headphonesLogo)
        usernameContainer.addSubview(usernameTextField)
        passwordContainer.addSubview(passwordTextField)
        reenterPasswordContainer.addSubview(reenterPasswordTextField)

        //let quarterHeight = view.frame.height / 3
        
        
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

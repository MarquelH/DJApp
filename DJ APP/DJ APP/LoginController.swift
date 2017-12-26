//
//  LoginController.swift
//  DJ APP
//
//  Created by arturo ho on 8/24/17.
//  Copyright © 2017 Marquel and Micajuine App Team. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController, UINavigationControllerDelegate {
    
    let djGuestLoginButton: UIButton = {
        let lb = UIButton(type: .system)
        lb.setTitle("Login", for: .normal)
        lb.setTitleColor(UIColor.white, for: .normal)
        lb.backgroundColor = UIColor.black.withAlphaComponent(0.25)
        lb.layer.cornerRadius = 40
        lb.layer.borderWidth = 1
        lb.layer.borderColor = UIColor.white.cgColor
        lb.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        lb.addTarget(self, action: #selector(handleLoginEnter), for: .touchUpInside)
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
        tf.placeholder = "Email"
        tf.clearButtonMode = UITextFieldViewMode.whileEditing
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.font = UIFont.boldSystemFont(ofSize: 20)
        tf.isSecureTextEntry = true
        tf.placeholder = "Password"
        tf.clearButtonMode = UITextFieldViewMode.whileEditing
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
    
    lazy var djOrGuestSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: [ "Guest Login","DJ Login",])
        sc.backgroundColor = UIColor.blue.withAlphaComponent(0.25)
        sc.tintColor = UIColor.white
        sc.selectedSegmentIndex = 0
        sc.layer.cornerRadius = 12
        sc.layer.masksToBounds = true
        sc.layer.borderWidth = 1
        sc.addTarget(self, action: #selector(handleLoginEnterChange), for: .valueChanged)
        sc.translatesAutoresizingMaskIntoConstraints = false
        return sc
    }()
    
    let notUserLabel: UIButton = {
        let btn = UIButton(type: .system)
        let lightblue = UIColor.white.withAlphaComponent(0.75)
        btn.setTitle("Don't have an account? Sign up here", for: .normal)
        btn.setTitleColor(lightblue, for: .normal)
        btn.titleLabel?.font = UIFont.italicSystemFont(ofSize: 15)
        btn.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let logoInLogin: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "headphones")
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleAspectFill
        return img
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

//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//    }
    
    var loginButtonTopAnchor: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //show all fonts
//        for family: String in UIFont.familyNames
//        {
//            print("\(family)")
//            for names: String in UIFont.fontNames(forFamilyName: family)
//            {
//                print("== \(names)")
//            }
//        }

        let backgroundImage: UIImageView = UIImageView(frame: view.bounds)
        backgroundImage.image = UIImage(named: "djBackgroundImage")
        backgroundImage.contentMode = .scaleAspectFill
        
        view.insertSubview(backgroundImage, at: 0)

        setupViews()
        handleLoginEnterChange()
    }

    
    
    //Handle what shows when you hit login or enter (UISegmentedController)
    func handleLoginEnterChange() {
        if (djOrGuestSegmentedControl.selectedSegmentIndex == 1) {
            djGuestLoginButton.setTitle("Login", for: .normal)
          //  djGuestLoginButton.setTitleColor(UIColor.blue, for: .normal)
          //  usernameContainer.isHidden = false
            passwordContainer.isHidden = false
          //  usernameImage.isHidden = false
            passwordImage.isHidden = false
            passwordTextField.isHidden = false
           // usernameTextField.isHidden = false
            notUserLabel.isHidden = false
            loginButtonTopAnchor?.constant = 25
        }
        else {
            loginButtonTopAnchor?.constant = -55
            notUserLabel.isHidden = true
          //  usernameContainer.isHidden = true
            passwordContainer.isHidden = true
         //   usernameImage.isHidden = true
            passwordImage.isHidden = true
            passwordTextField.isHidden = true
          //  usernameTextField.isHidden = true
            djGuestLoginButton.setTitle("Enter", for: .normal)
        }
    }
    
    //Handle what happens when you hit login/enter button
    func handleLoginEnter() {
        //login was hit
        if (djOrGuestSegmentedControl.selectedSegmentIndex == 1){
            handleLogin()
        }
        //Guest enter was hit
        else {
            handleGuestEnter()
        }
    }
    
    func handleRegister() {
        let registerController = RegisterController()
        registerController.loginController = self
        let navController = UINavigationController(rootViewController: registerController)
        let backgroundImage: UIImageView = UIImageView(frame: view.bounds)
        backgroundImage.image = UIImage(named: "headphonesImage")
        backgroundImage.contentMode = .scaleAspectFill
        navController.view.insertSubview(backgroundImage, at: 0)
        navController.view.backgroundColor = UIColor.black
        
        present(navController, animated: true, completion: nil)
    }
    
    func handleLogin() {
        guard let email = usernameTextField.text, let password = passwordTextField.text else {
            print("Login info was invalid")
            return
        }
        Auth.auth().signIn(withEmail: email, password: password, completion: {(user, error) in
            
            //There was an error signing in, reset text fields.
            if let error = error {
                print ("Error signing in: ")
                print(error.localizedDescription)
                self.usernameTextField.text = ""
                self.passwordTextField.text = ""
            }
            //Else there was no error and we gucci
            else {
                
                //Check if the user is validated by us
                guard let uid = Auth.auth().currentUser?.uid else {
                    return
                }
                
                Database.database().reference().child("users").child(uid).observe(.value, with: {(snapshot) in
                    if let dictionary = snapshot.value as? [String: AnyObject] {
                       
                        guard let validated = dictionary["validated"] as? Bool else {
                            return
                        }
                        
                        //If user is validated, present DJRootViewController
                        if (validated) {
                            
                            //Create DJ variable, and store the dictionary snapshot into it.
                            if let name = dictionary["djName"] as? String, let age = dictionary["age"] as? Int, let currentLocation = dictionary["currentLocation"] as? String, let email = dictionary["email"] as? String, let genre = dictionary["genre"] as? String, let hometown = dictionary["hometown"] as? String, let validated =  dictionary["validated"] as? Bool, let profilePicURL = dictionary["profilePicURL"] as? String{
                                
                                let dj = UserDJ(age: age, currentLocation: currentLocation, djName: name, email: email, genre: genre, hometown: hometown, validated: validated, profilePicURL: profilePicURL, uid: uid)
                                
                                //Send DJ to DJRootViewController
                                let djRootViewController = DJRootViewController()
                                djRootViewController.dj = dj
                                
                                let djNavController = UINavigationController(rootViewController: djRootViewController)
                                self.present(djNavController, animated: true, completion: nil)
                                
                            }
                            else {
                                print("Parsing the DJ went wrong")
                            }
           
                            
                            
                        }
                        else {
                            print ("user is not validated")
                            return
                        }
                    }
                })
            }
        })
    }
    
    func handleGuestEnter() {
        guard let email = usernameTextField.text, email != "" else {
            print("Username is empty")
            return
        }
        
        let djTableViewController = DJTableViewController()
        let djTableNavController = UINavigationController(rootViewController: djTableViewController)
        djTableNavController.delegate = self
        
        
        //check if the email already exists in the database
        let isFoundTuple = guestIsPresentInDatabase(guestEmail: email)
        
        //Found in database
        if isFoundTuple.0 {
            print("Found")
            djTableViewController.guestID = isFoundTuple.key
        }
        //Not found in database, add it in
        else {
            print("Not found in database")
            let ref = Database.database().reference().child("guests")
            let key = ref.childByAutoId().key
            djTableViewController.guestID = key
            let values = ["email":email]
            ref.child(key).setValue(values)
        }
        
        present(djTableNavController, animated: true, completion: nil)
    }
    
    func guestIsPresentInDatabase(guestEmail: String) -> (isPresent: Bool, key: String) {
        var foundKey: String = ""
        var found: Bool = false
        
        
//        Database.database().reference().child("guests").observeSingleEvent(of: .value, with: {(snapshot) in
//            
//            for x in snapshot.children {
//                print(x)
//            }
//            
//        }, withCancel: nil)
        
        Database.database().reference().child("guests").observeSingleEvent(of: .value, with: {(snapshot) in
            if snapshot.exists() {
                print("snap exists")
            }
            else {
                print("No exist")
            }
            if let dictionary = snapshot.value as? [String: AnyObject] {

                for (key,value) in dictionary {
                    dump(key)
                    dump(value)
                    if let email = value["email"] as? String, email == guestEmail {
                        print("Guestemail: \(guestEmail)\nDB Email:\(email)")
                        //return (true, key)
                        foundKey = key
                        found = true
                    }

                }

            }

        }, withCancel: nil)
//        Database.database().reference().child("guests").removeAllObservers()
        return (found, foundKey)
    }
    
    func setupViews() {
        view.addSubview(djGuestLoginButton)
        view.addSubview(usernameContainer)
        view.addSubview(passwordContainer)
        view.addSubview(djOrGuestSegmentedControl)
        view.addSubview(notUserLabel)
        view.addSubview(logoInLogin)
        view.addSubview(logoGo)
        view.addSubview(logoDJ)
        usernameContainer.addSubview(usernameTextField)
        usernameContainer.addSubview(usernameImage)
        passwordContainer.addSubview(passwordTextField)
        passwordContainer.addSubview(passwordImage)
        
        //ios 9 constraints x,y,w,h
        usernameContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        usernameContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        usernameContainer.heightAnchor.constraint(equalToConstant: 60).isActive = true
        usernameContainer.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        
        logoGo.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -75).isActive = true
        logoGo.bottomAnchor.constraint(equalTo: djOrGuestSegmentedControl.topAnchor, constant: -25).isActive = true
        logoGo.topAnchor.constraint(equalTo: logoInLogin.topAnchor, constant: 75)
        logoGo.heightAnchor.constraint(equalToConstant: 10).isActive = true
        logoGo.widthAnchor.constraint(equalToConstant: 75).isActive = true
        
        
        logoDJ.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 75).isActive = true
        logoDJ.bottomAnchor.constraint(equalTo: djOrGuestSegmentedControl.topAnchor, constant: -25).isActive = true
        logoDJ.heightAnchor.constraint(equalToConstant: 10).isActive = true
        logoDJ.widthAnchor.constraint(equalToConstant: 75).isActive = true
        
        
        logoInLogin.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoInLogin.bottomAnchor.constraint(equalTo: djOrGuestSegmentedControl.topAnchor, constant: -65).isActive = true
        logoInLogin.topAnchor.constraint(equalTo: view.topAnchor, constant: 30)
        logoInLogin.heightAnchor.constraint(equalToConstant: 60).isActive = true
        logoInLogin.widthAnchor.constraint(equalToConstant: 125).isActive = true
        
        
        notUserLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        notUserLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        notUserLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        notUserLabel.topAnchor.constraint(equalTo: djGuestLoginButton.bottomAnchor).isActive = true
        
        
        djOrGuestSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        djOrGuestSegmentedControl.bottomAnchor.constraint(equalTo: usernameContainer.topAnchor, constant: -15).isActive = true
        djOrGuestSegmentedControl.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        djOrGuestSegmentedControl.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        
        passwordContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        passwordContainer.topAnchor.constraint(equalTo: usernameContainer.bottomAnchor, constant: 12).isActive = true
        passwordContainer.heightAnchor.constraint(equalToConstant: 60).isActive = true
        passwordContainer.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        
        
        djGuestLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        //have to se this to a variable to change it later
        loginButtonTopAnchor = djGuestLoginButton.topAnchor.constraint(equalTo: passwordContainer.bottomAnchor, constant: 50)
        loginButtonTopAnchor?.isActive = true
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


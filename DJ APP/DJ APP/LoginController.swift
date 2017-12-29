//
//  LoginController.swift
//  DJ APP
//
//  Created by arturo ho on 8/24/17.
//  Copyright © 2017 Marquel and Micajuine App Team. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

class LoginController: UIViewController, UINavigationControllerDelegate, FBSDKLoginButtonDelegate {
    
    var guestSnapshot: [String: AnyObject]?
    
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
    
    let fbLoginButton = FBSDKLoginButton()
    
    let customFBLogin: UIButton =  {
        let cb = UIButton(type: .system)
        cb.setTitle("FB Login", for: .normal)
        cb.addTarget(self, action: #selector(handleCustomLogin), for: .touchUpInside)
        cb.translatesAutoresizingMaskIntoConstraints = false
        return cb
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
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil  {
            print("Error occured with the login")
        }
        else {
            print("Facebook did login")
        }
        getEmailAddress()
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did logout")
    }
    
    func handleCustomLogin () {
        FBSDKLoginManager().logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print("Custom login error: \(error?.localizedDescription)")
            }
            else {
                self.getEmailAddress()
            }
        }
    }

    func getEmailAddress() {
        let accessToken = FBSDKAccessToken.current()
        guard let token = accessToken?.tokenString else {
            return
        }
        print("Access token: \(token)")
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start { (connection, result, error) in
            if error != nil {
                print("Failed to start graph request: \(error ?? "-1" as! Error)")
                return
            }
            print (result)
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getGuestSnapshot()
    }

    
    func getGuestSnapshot() {
        Database.database().reference().child("guests").observeSingleEvent(of: .value, with: {(snapshot) in

            DispatchQueue.main.async {
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    self.guestSnapshot = dictionary
                }
            }
        }, withCancel: nil)
    }
    
    //Handle what shows when you hit login or enter (UISegmentedController)
    func handleLoginEnterChange() {
        if (djOrGuestSegmentedControl.selectedSegmentIndex == 1) {
            djGuestLoginButton.setTitle("Login", for: .normal)
            passwordContainer.isHidden = false
            passwordImage.isHidden = false
            passwordTextField.isHidden = false
            notUserLabel.isHidden = false
            fbLoginButton.isHidden = true
            loginButtonTopAnchor?.constant = 25
        }
        else {
            loginButtonTopAnchor?.constant = -55
            notUserLabel.isHidden = true
            passwordContainer.isHidden = true
            passwordImage.isHidden = true
            passwordTextField.isHidden = true
            fbLoginButton.isHidden = false
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
                            
                            //Create DJ object, and store the dictionary snapshot into it.
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
            print("Username is empty, or snap did not load")
            return
        }
        
        let djTableViewController = DJTableViewController()
        let djTableNavController = UINavigationController(rootViewController: djTableViewController)
        djTableNavController.delegate = self
        
        
        //Found in database
        let isFoundTuple = isFound(guestEmail: email)
        if isFoundTuple.0 {
            djTableViewController.guestID = isFoundTuple.key
        }
        //Not found in database, add it in
        else {
            let ref = Database.database().reference().child("guests")
            let key = ref.childByAutoId().key
            djTableViewController.guestID = key
            let values = ["email":email]
            ref.child(key).setValue(values)
        }
        
        present(djTableNavController, animated: true, completion: nil)
    }
    
    func isFound(guestEmail: String) ->(found: Bool, key: String) {
        if let workingSnap = self.guestSnapshot {
            for (k,v) in workingSnap {
                if let email = v["email"] as? String, email == guestEmail {
                    return (true, k)
                }
               
            }
        }
        else {
            print("Guest Snap did not load")
        }
        return (false, "")
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
        view.addSubview(fbLoginButton)
        view.addSubview(customFBLogin)

        usernameContainer.addSubview(usernameTextField)
        usernameContainer.addSubview(usernameImage)
        passwordContainer.addSubview(passwordTextField)
        passwordContainer.addSubview(passwordImage)

        setupFbButton()
        
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
        
        fbLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        fbLoginButton.topAnchor.constraint(equalTo: djGuestLoginButton.bottomAnchor, constant: 24).isActive = true
        fbLoginButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        fbLoginButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    
        customFBLogin.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        customFBLogin.topAnchor.constraint(equalTo: fbLoginButton.bottomAnchor, constant: 24).isActive = true
        customFBLogin.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        customFBLogin.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func setupFbButton() {
        fbLoginButton.translatesAutoresizingMaskIntoConstraints = false
        fbLoginButton.delegate = self
        fbLoginButton.readPermissions = ["email"]
        fbLoginButton.layer.borderColor = UIColor.white.cgColor
        fbLoginButton.layer.masksToBounds = true
        fbLoginButton.layer.cornerRadius = 20
        fbLoginButton.layer.borderWidth = 2
    }
    
}


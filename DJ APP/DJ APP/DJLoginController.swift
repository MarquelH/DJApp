//
//  LoginController.swift
//  DJ APP
//
//  Created by arturo ho on 8/24/17.
//  Copyright © 2017 Marquel and Micajuine App Team. All rights reserved.
//

import UIKit
import Firebase
import GoogleMaps
import GooglePlaces

class DJLoginController: UIViewController, UINavigationControllerDelegate, UITextFieldDelegate {
    
    
    var guestSnapshot: [String: AnyObject]?
    var djSnapshot: [String: AnyObject]?
    
    
    let djGuestLoginButton: UIButton = {
        let lb = UIButton(type: .system)
        lb.setTitle("Login", for: .normal)
        lb.setTitleColor(UIColor.white, for: .normal)
        lb.backgroundColor = UIColor.black.withAlphaComponent(0.25)
        lb.layer.cornerRadius = 40
        lb.layer.borderWidth = 1
        lb.layer.borderColor = UIColor.white.cgColor
        lb.titleLabel?.font = UIFont(name: "Mikodacs", size: 35)
        lb.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
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
        let sc = UISegmentedControl(items: ["Login to DJ Mode Below"])
        sc.backgroundColor = UIColor.blue.withAlphaComponent(0.25)
        sc.tintColor = UIColor.white
        sc.selectedSegmentIndex = 0
        sc.layer.cornerRadius = 12
        sc.layer.masksToBounds = true
        sc.layer.borderWidth = 1
        sc.translatesAutoresizingMaskIntoConstraints = false
        return sc
    }()
    
    let notUserLabel: UIButton = {
        let btn = UIButton(type: .system)
        let lightblue = UIColor.white.withAlphaComponent(0.75)
        btn.setTitle("Don't have a DJ account? Register Here!", for: .normal)
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
    
    let backButton: UIButton = {
        let btn = UIButton(type: .system)
        let image = UIImage(named: "icons8-rewind-50") as UIImage!
        btn.setImage(image, for: .normal)
        btn.addTarget(self, action: #selector(backToBreakOff), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    
    
    var loginButtonTopAnchor: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backgroundImage: UIImageView = UIImageView(frame: view.bounds)
        backgroundImage.image = UIImage(named: "djBackgroundImage")
        backgroundImage.contentMode = .scaleAspectFill
        
        view.insertSubview(backgroundImage, at: 0)
        
        setupViews()
        setupTextFields()
        
        self.usernameTextField.delegate = self
        self.passwordTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getSnapshots()
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    @objc func setupTextFields() {
        passwordContainer.isHidden = false
        passwordImage.isHidden = false
        passwordTextField.isHidden = false
        notUserLabel.isHidden = false
        loginButtonTopAnchor?.constant = 25
    }
    
    @objc func backToBreakOff() {
        let storyboard = UIStoryboard(name: "breakOffStoryboard", bundle: nil)
        let breakOff = storyboard.instantiateViewController(withIdentifier: "breakOff") as! BreakoffController
        present(breakOff, animated: true, completion: nil)
    }
    
    func checkIfUserIsAlreadyLoggedIn() {
        //If guest is currently signed in, then his stuff is in the database, so find it
        if Auth.auth().currentUser != nil {
            if let email = Auth.auth().currentUser?.email {
                print(email)
                guard let guestSnap = self.guestSnapshot else {
                    print("guest snap did not load")
                    return
                }
                //if guest is found then present DJ Tableview
                let isFoundTuple = isFound(snapshot: guestSnap, guestEmail: email)
                if (isFoundTuple.0) {
                    checkIfValidated(uid: isFoundTuple.key)
                }
                    //Else check if the dj is found then present DJ root view
                else {
                    guard let djSnap = self.djSnapshot else {
                        print("Dj Snap did not load")
                        return
                    }
                    let djFoundTuple = isFound(snapshot: djSnap, guestEmail: email)
                    if (djFoundTuple.0) {
                        checkIfValidated(uid: djFoundTuple.key)
                    }
                        //Else not in either database, but still signed in so sign out
                    else {
                        print("User was logged in but not found in user or guest database. So will now logout")
                        do {
                            try Auth.auth().signOut()
                        }
                        catch let error as NSError {
                            print("Error with signing out of firebase: \(error.localizedDescription)")
                        }
                    }
                }
            }
            else {
                print("Error with already signed in ")
            }
            
        }
        else {
            print("no user logged in")
        }
    }
    
    func getSnapshots() {
        Database.database().reference().child("guests").observeSingleEvent(of: .value, with: {(snapshot) in
            
            DispatchQueue.main.async {
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    self.guestSnapshot = dictionary
                }
            }
            //get users
            Database.database().reference().child("users").observeSingleEvent(of: .value, with: {(snapshot) in
                
                DispatchQueue.main.async {
                    if let dictionary = snapshot.value as? [String: AnyObject] {
                        self.djSnapshot = dictionary
                    }
                    self.checkIfUserIsAlreadyLoggedIn()
                }
            }, withCancel: nil)
            
        }, withCancel: nil)
        
    }
    
    @objc func handleRegister() {
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
    
    @objc func handleLogin() {
        guard let email = usernameTextField.text, let password = passwordTextField.text else {
            let alert = UIAlertController(title: "Invalid Entries", message: "Username and password must be valid", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: { action in
                self.usernameTextField.text = ""
                self.passwordTextField.text = ""
            }))
            self.present(alert, animated: true, completion: nil)
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
                let alert = UIAlertController(title: "Invalid Login", message: "Error logging in with the given username and password! Please Re-enter.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: { action in
                    self.usernameTextField.text = ""
                    self.passwordTextField.text = ""
                }))
                self.present(alert, animated: true, completion: nil)
            }
                //Else there was no error and we gucci
            else {
                
                //Check if the user is validated by us
                guard let uid = Auth.auth().currentUser?.uid else {
                    return
                }
                self.checkIfValidated(uid: uid)
            }
        })
    }
    
    func checkIfValidated(uid: String) {
        
        guard let djSnap = self.djSnapshot else {
            print("djsnapshot did not load in check if validated")
            return
        }
        
        for (key, dictionary) in djSnap {
            if key == uid {
                guard let validated = dictionary["validated"] as? Bool else {
                    print("Dj not validated")
                    return
                }
                
                //If user is validated, present DJRootViewController
                if (validated) {
                    
                    //Create DJ object, and store the dictionary snapshot into it.
                    if let name = dictionary["djName"] as? String, let age = dictionary["age"] as? Int, let currentLocation = dictionary["currentLocation"] as? String, let email = dictionary["email"] as? String, let genre = dictionary["genre"] as? String, let hometown = dictionary["hometown"] as? String, let twitter = dictionary["twitterOrInstagram"] as? String, let validated =  dictionary["validated"] as? Bool, let profilePicURL = dictionary["profilePicURL"] as? String{
                        
                        let dj = UserDJ(age: age, currentLocation: currentLocation, djName: name, email: email, genre: genre, hometown: hometown, validated: validated, profilePicURL: profilePicURL, uid: uid, twitter: twitter)
                        
                        //Send DJ to Dj Tab Bar Controller
                        
                        if validated == true {
                            
                            let storyboard = UIStoryboard(name: "ScehdulingStoryboard", bundle: nil)
                            let tabbarController = storyboard.instantiateViewController(withIdentifier: "tabBarView") as! DJcustomTabBarControllerViewController
                            tabbarController.dj = dj
                            
                            present(tabbarController, animated: true, completion: nil)
                        }
                        else{
                            let alert = UIAlertController(title: "Skrt!", message: "You must be validated in order to be a DJ.", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in
                                print("I was pressed")
                                self.navigationController?.popViewController(animated: true)
                            }))
                            
                            self.present(alert, animated: true, completion: nil)
                        }
                        
                        
                        
                    }
                    else {
                        print("Parsing the DJ went wrong")
                    }
                }
            }
        }
    }
    
    func handleLogout() {
        do {
            try Auth.auth().signOut()
        }
        catch let error as NSError {
            print("Error with signing out of firebase: \(error.localizedDescription)")
        }
        dismiss(animated: true, completion: nil)
        
    }
    
    //returns key and true if found in the given snapshot
    func isFound(snapshot: [String: AnyObject], guestEmail: String) ->(found: Bool, key: String) {
        for (k,v) in snapshot {
            if let email = v["email"] as? String, email.lowercased() == guestEmail {
                return (true, k)
            }
            
        }
        return (false, "")
    }
    
    
    
    func setupViews() {
        UIApplication.shared.statusBarStyle = .lightContent
        view.addSubview(djGuestLoginButton)
        view.addSubview(usernameContainer)
        view.addSubview(passwordContainer)
        view.addSubview(djOrGuestSegmentedControl)
        view.addSubview(notUserLabel)
        view.addSubview(logoInLogin)
        view.addSubview(logoGo)
        view.addSubview(logoDJ)
        view.addSubview(backButton)
        
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
        logoInLogin.heightAnchor.constraint(equalToConstant: 60).isActive = true
        logoInLogin.widthAnchor.constraint(equalToConstant: 125).isActive = true
        
        
        notUserLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        notUserLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -13).isActive = true
        notUserLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        notUserLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        
        djOrGuestSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        djOrGuestSegmentedControl.bottomAnchor.constraint(equalTo: usernameContainer.topAnchor, constant: -15).isActive = true
        djOrGuestSegmentedControl.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        djOrGuestSegmentedControl.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        
        passwordContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        passwordContainer.topAnchor.constraint(equalTo: usernameContainer.bottomAnchor, constant: 12).isActive = true
        passwordContainer.heightAnchor.constraint(equalToConstant: 60).isActive = true
        passwordContainer.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        
        
        djGuestLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
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
        
        backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        backButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
    }
    
}


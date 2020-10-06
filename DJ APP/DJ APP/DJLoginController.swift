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
import NVActivityIndicatorView
import SwiftKeychainWrapper

class DJLoginController: UIViewController, UINavigationControllerDelegate, UITextFieldDelegate, NVActivityIndicatorViewable {
    
    
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
        lb.titleLabel?.font = UIFont(name: "BebasNeue-Regular", size: 35)
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
        
        if #available(iOS 11.0, *) {
            tf.textContentType = .username
        } else {
            // don't set
        }
        return tf
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.font = UIFont.boldSystemFont(ofSize: 20)
        tf.isSecureTextEntry = true
        tf.placeholder = "Password"
        tf.clearButtonMode = UITextFieldViewMode.whileEditing
        tf.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11.0, *) {
            tf.textContentType = .password
        } else {
            // don't set
        }
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
    
    let autofillLabel: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Autofill with your credentials for Go.DJ", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        btn.addTarget(self, action: #selector(autofill), for: .touchUpInside)
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
        let btn = UIButton(type: .roundedRect)
        let image = UIImage(named: "icons8-go-back-64")
        btn.tintColor = UIColor.white
        btn.setImage(image, for: .normal)
        btn.addTarget(self, action: #selector(backToBreakOff), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    
    
    var loginButtonTopAnchor: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getSnapshots()
        let backgroundImage: UIImageView = UIImageView(frame: view.bounds)
        backgroundImage.image = UIImage(named: "djBackgroundImage")
        backgroundImage.contentMode = .scaleAspectFill
        
        view.insertSubview(backgroundImage, at: 0)
        
        setupViews()
        setupTextFields()
        setupNavBar()
        self.usernameTextField.delegate = self
        self.passwordTextField.delegate = self
        view.accessibilityIdentifier = "djLoginView"
    }
    
    @objc func autofill() {
        if let retrievedPassword = KeychainWrapper.standard.string(forKey: "userPassword"), let retrievedUsername = KeychainWrapper.standard.string(forKey: "username"){
            usernameTextField.text = retrievedUsername
            passwordTextField.text = retrievedPassword
        } else {
            let alert = UIAlertController(title: "Oops", message: "Nothing stored in your keychain for Go.DJ", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { action in
                self.navigationController?.popViewController(animated: true)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        breakOff.modalPresentationStyle = .fullScreen
        present(breakOff, animated: true, completion: nil)
    }
    
    func checkIfUserIsAlreadyLoggedIn() {
        self.startAnimating()
        if Constants.LOGGED_IN == true {
            //checkIfValidated(uid: <#T##String#>, email: <#T##String#>)
        }
        //If guest is currently signed in, then his stuff is in the database, so find it
        if Auth.auth().currentUser != nil {
            //print("CURRENT USER NOT NULL!")
            if Constants.LOGGED_IN == true {
                
            }
            if let email = Auth.auth().currentUser?.email {
                //print(email)
                    //Else check if the dj is found then present DJ root view
                //else {
                    guard let djSnap = self.djSnapshot else {
                        //print("Dj Snap did not load")
                        return
                    }
                    let djFoundTuple = isFound(snapshot: djSnap, guestEmail: email)
                    if (djFoundTuple.0) {
                        checkIfValidated(uid: djFoundTuple.key, email: email)
                    }
                        //Else not in either database, but still signed in so sign out
                    else {
                        self.stopAnimating()
                        //print("User was logged in but not found in user database. So will now logout")
                        do {
                            try Auth.auth().signOut()
                        }
                        catch let error as NSError {
                            self.stopAnimating()
                            //print("Error with signing out of firebase: \(error.localizedDescription)")
                        }
                    }
                //}
            }
            else {
                let alert = UIAlertController(title: "Oops", message: "Tried to sign you in but an error occurred.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { action in
                    self.navigationController?.popViewController(animated: true)
                }))
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                self.stopAnimating()
                self.present(alert, animated: true, completion: nil)
                //print("Error with already signed in ")
            }
            
        }
        else {
            self.stopAnimating()
            //print("no user logged in")
        }
    }
    
    func getSnapshots() {
        //print("GETTING SNAPSHOT")
        Database.database().reference().child("guests").observeSingleEvent(of: .value, with: {(snapshot) in
            
            //DispatchQueue.main.async {
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    self.guestSnapshot = dictionary
                }
            //}
            //get users
            Database.database().reference().child("users").observeSingleEvent(of: .value, with: {(snapshot) in
                
                //DispatchQueue.main.async {
                    if let dictionary = snapshot.value as? [String: AnyObject] {
                        self.djSnapshot = dictionary
                    //}
                        self.checkIfUserIsAlreadyLoggedIn()
                    } else {
                        self.stopAnimating()
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
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true, completion: nil)
    }
    
    @objc func handleLogin() {
        //print("LOGGING IN!")
        if !(Reachability.isConnectedToNetwork()) {
            let alert = UIAlertController(title: "Oops!", message: "It looks like you aren't connected to internet. Please try again!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { action in
                self.navigationController?.popViewController(animated: true)
                self.stopAnimating()
                return
            }))
            self.present(alert, animated: true, completion: nil)
        }
        startAnimating()
        guard let email = usernameTextField.text, let password = passwordTextField.text else {
            let alert = UIAlertController(title: "Invalid Entries", message: "Username and password must be valid", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: { action in
                self.usernameTextField.text = ""
                self.passwordTextField.text = ""
            }))
            stopAnimating()
            self.present(alert, animated: true, completion: nil)
            //print("Login info was invalid")
            return
        }
            guard let guestSnap = self.guestSnapshot else {
                //print("guest snap did not load")
                return
            }
            //if guest is found then do not present DJ Tableview
            let isFoundTuple = isFound(snapshot: guestSnap, guestEmail: email)
            if (isFoundTuple.0) {
                //print("FOUND IN GUEST SNAPSHOT!")
                let alert = UIAlertController(title: "Oops!", message: "Email \(email) is already associated with a guest account. Please enter another for DJ use.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { action in
                    self.navigationController?.popViewController(animated: true)
                    return
                }))
                stopAnimating()
                self.present(alert, animated: true, completion: nil)
            } else {
                //print("NOT FOUND IN GUEST SNAPSHOT!")
            }
        
        Auth.auth().signIn(withEmail: email, password: password, completion: {(user, error) in
            
            //There was an error signing in, reset text fields.
            
            if let error = error {
                //print(email)
                //print(password)
                print ("Error signing in: ")
                //print(error.localizedDescription)
                self.passwordTextField.text = ""
                let alert = UIAlertController(title: "Invalid Login", message: "Error logging in with the given username and password! Please Re-enter.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: { action in
                    self.passwordTextField.text = ""
                }))
                self.stopAnimating()
                self.present(alert, animated: true, completion: nil)
            }
                //Else there was no error and we gucci
            else {
                
                //Check if the user is validated by us
                guard let uid = Auth.auth().currentUser?.uid else {
                    self.stopAnimating()
                    return
                }
                self.checkIfValidated(uid: uid, email: email)
            }
        })
    }
    
    func setupNavBar() {
        //print("SETTING UP NAV BAR")
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(backToBreakOff))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 214/255, green: 29/255, blue: 1, alpha:1.0)
        //self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        //self.navigationController?.navigationBar.shadowImage = UIImage()
        //self.navigationController?.navigationBar.isTranslucent = true
        //self.navigationController?.view.backgroundColor = UIColor.clear
        
        //Bar text
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "BebasNeue-Regular", size : 30) as Any, NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationItem.title = "DJ Mode"
        
    }
    
    func checkIfValidated(uid: String, email: String) {
        startAnimating()
        guard let djSnap = self.djSnapshot else {
            //print("djsnapshot did not load in check if validated")
            return
        }
        
        for (key, dictionary) in djSnap {
            if key == uid {
                /*guard let validated = dictionary["validated"] as? Bool else {
                    //print("Dj not validated")
                    return
                }*/
                
                //If user is validated, present DJRootViewController
                //if (validated) {
                    //Create DJ object, and store the dictionary snapshot into it.
                    if let name = dictionary["djName"] as? String, let age = dictionary["age"] as? Int, let currentLocation = dictionary["currentLocation"] as? String, let email = dictionary["email"] as? String, let genre = dictionary["genre"] as? String, let hometown = dictionary["hometown"] as? String, let twitter = dictionary["twitterOrInstagram"] as? String, let validated =  dictionary["validated"] as? Bool, let profilePicURL = dictionary["profilePicURL"] as? String{
                        
                        let dj = UserDJ(age: age, currentLocation: currentLocation, djName: name, email: email, genre: genre, hometown: hometown, validated: validated, profilePicURL: profilePicURL, uid: uid, twitter: twitter)
                        
                        //Send DJ to Dj Tab Bar Controller
                        
                        let storyboard = UIStoryboard(name: "ScehdulingStoryboard", bundle: nil)
                        let tabbarController = storyboard.instantiateViewController(withIdentifier: "tabBarView") as! DJcustomTabBarControllerViewController
                        tabbarController.dj = dj
                        //print("PRESENTING TAB BAR")
                        self.stopAnimating()
                        tabBarController?.modalPresentationStyle = .fullScreen
                        self.present(tabbarController, animated: true, completion: nil)
                        
                        
                    } else {
                        self.stopAnimating()
                        //print("Parsing the DJ went wrong")
                    }
                //} else {
                    ////print("NOT VALIDATED")
                //}
            }
        }
    }
    
    func handleLogout() {
        do {
            try Auth.auth().signOut()
        }
        catch let error as NSError {
            //print("Error with signing out of firebase: \(error.localizedDescription)")
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
        view.addSubview(djGuestLoginButton)
        view.addSubview(usernameContainer)
        view.addSubview(passwordContainer)
        view.addSubview(djOrGuestSegmentedControl)
        view.addSubview(notUserLabel)
        view.addSubview(logoInLogin)
        view.addSubview(logoGo)
        view.addSubview(logoDJ)
        view.addSubview(backButton)
        view.addSubview(autofillLabel)
        
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
        
        autofillLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        autofillLabel.topAnchor.constraint(equalTo: djGuestLoginButton.bottomAnchor, constant: 5).isActive = true
        
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


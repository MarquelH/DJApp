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
    var djSnapshot: [String: AnyObject]?

    
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
        tf.returnKeyType = .go
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
        btn.setTitle("Don't have a DJ account? Sign up by clicking here", for: .normal)
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
        cb.setTitle("Facebook Login", for: .normal)
        cb.addTarget(self, action: #selector(handleCustomLogin), for: .touchUpInside)
        cb.translatesAutoresizingMaskIntoConstraints = false
        cb.layer.borderWidth = 2
        cb.layer.borderColor = UIColor.white.cgColor
        cb.backgroundColor = UIColor(red: 59/255, green: 89/255, blue: 152/255, alpha: 1.0)
        cb.layer.masksToBounds = false
        cb.layer.cornerRadius = 20
        cb.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        cb.titleLabel?.textColor = UIColor.white
        return cb
    }()
    
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
            return
        }
        else {
            print("Facebook did login")
        }
        print("I was pressed2")
        signInWithFBEmailAddress()
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        //nothing to do here
    }
    
    func handleCustomLogin () {
        FBSDKLoginManager().logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print("Custom login error: \(error?.localizedDescription)")
            }
            else {
                //Handle issue if they hit log in with fb then hit cancel to permissions.
                print("I was pressed")
                self.signInWithFBEmailAddress()
            }
        }
    }

    func signInWithFBEmailAddress() {

        let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
                print("Problem signing into firebase with FB credientials: \(error.localizedDescription)")
                return
            }
            //User is signed in
            //Show next DJ List view controller
            
            FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start { (connection, result, error) in
                if error != nil {
                    print("Failed to start graph request: \(error ?? "-1" as! Error)")
                    return
                }
                //print (result)
                if let result = result as? [String: AnyObject], let email = result["email"] as? String {
                    //send to check database
                    print("Successfully parsed email")
                    guard let guestSnap = self.guestSnapshot else {
                        print("guestSnapshot did not load")
                        return
                    }
                    
                    let isFoundTuple = self.isFound(snapshot: guestSnap, guestEmail: email)
                    //user is present in database
                    if isFoundTuple.0 {
                        //Send to new view with email
                        self.presentDJTableView(guestID: isFoundTuple.key)
                    }
                    //Add them into the database and send to new view with email
                    else {
                        let ref = Database.database().reference().child("guests")
                        let key = ref.childByAutoId().key
                        let values = ["email":email]
                        ref.child(key).setValue(values)
                        self.presentDJTableView(guestID: key)
                    }
                }
                else {
                    print("Parsing Results was unsuccessful")
                }
            }
        }
        
       
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getSnapshots()
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
                    presentDJTableView(guestID: isFoundTuple.key)
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
    

    
    //Handle what shows when you hit login or enter (UISegmentedController)
    func handleLoginEnterChange() {
        if (djOrGuestSegmentedControl.selectedSegmentIndex == 1) {
            djGuestLoginButton.setTitle("Login", for: .normal)
            passwordContainer.isHidden = false
            passwordImage.isHidden = false
            passwordTextField.isHidden = false
            notUserLabel.isHidden = false
            customFBLogin.isHidden = true
            loginButtonTopAnchor?.constant = 25
        }
        else {
            loginButtonTopAnchor?.constant = -55
            notUserLabel.isHidden = true
            passwordContainer.isHidden = true
            passwordImage.isHidden = true
            passwordTextField.isHidden = true
            customFBLogin.isHidden = false
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
                        let tabbarController = DJcustomTabBarControllerViewController()
                        tabbarController.setDJs(dj: dj)
                        self.present(tabbarController, animated: true, completion: nil)
                        
                        //Send DJ to DJRootViewController
//                        let djRootViewController = DJRootViewController()
//                        djRootViewController.dj = dj
//
//                        let djNavController = UINavigationController(rootViewController: djRootViewController)
//                        self.present(djNavController, animated: true, completion: nil)
                        
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
        }
    }
    
    func handleGuestEnter() {
        
        guard let email = usernameTextField.text?.lowercased(), email != "", let guestSnap = self.guestSnapshot else {
            print("Username is empty, or snap did not load")
            return
        }

        
        //Found in database
        
        let isFoundTuple = isFound(snapshot: guestSnap, guestEmail: email)
        if isFoundTuple.0 {
            Auth.auth().signIn(withEmail: email, password: "123456", completion: { (user, error) in
                if let error = error {
                    print("Error signing in with the user from email: \(error.localizedDescription)")
                    return
                }
                else {
                    print("successful login of user from email")
                    self.presentDJTableView(guestID: isFoundTuple.key)

                }
            })
        }
        //Not found in database, check if its well formed and then add it in
        else {
            //Also signs them in
            Auth.auth().createUser(withEmail: email, password: "123456", completion: { (user, error) in
                if let error = error {
                    print("Error creating user and logging in from the user from email: \(error.localizedDescription)")
                    return
                }
                else {
                    print("successful creation and loggin in of user from email")
                    let ref = Database.database().reference().child("guests")
                    let key = ref.childByAutoId().key
                    let values = ["email":email]
                    ref.child(key).setValue(values)
                    self.presentDJTableView(guestID: key)

                }
            })
            
        }

    }
    
    func presentDJTableView (guestID: String) {
        let djTableViewController = DJTableViewController()
        let djTableNavController = UINavigationController(rootViewController: djTableViewController)
        djTableNavController.delegate = self
        djTableViewController.guestID = guestID
        present(djTableNavController, animated: true, completion: nil)
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
//        view.addSubview(fbLoginButton)
        view.addSubview(customFBLogin)

        usernameContainer.addSubview(usernameTextField)
        usernameContainer.addSubview(usernameImage)
        passwordContainer.addSubview(passwordTextField)
        passwordContainer.addSubview(passwordImage)
        
//        setupFbButton()
        
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
        //logoInLogin.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true
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
        
//        fbLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        fbLoginButton.topAnchor.constraint(equalTo: djGuestLoginButton.bottomAnchor, constant: 24).isActive = true
//        fbLoginButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
//        fbLoginButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
//
        customFBLogin.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        customFBLogin.topAnchor.constraint(equalTo: djGuestLoginButton.bottomAnchor, constant: 24).isActive = true
        customFBLogin.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        customFBLogin.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
//    func setupFbButton() {
//        fbLoginButton.translatesAutoresizingMaskIntoConstraints = false
//        fbLoginButton.delegate = self
//        fbLoginButton.readPermissions = ["email"]
//        fbLoginButton.layer.borderColor = UIColor.white.cgColor
//        fbLoginButton.layer.masksToBounds = true
//        fbLoginButton.layer.cornerRadius = 20
//        fbLoginButton.layer.borderWidth = 2
//    }
    
}


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

class LoginController: UIViewController, UINavigationControllerDelegate, UITextFieldDelegate, NVActivityIndicatorViewable {
    
    
    var guestSnapshot: [String: AnyObject]?
    var djSnapshot: [String: AnyObject]?
    let activityIndicatorView:UIActivityIndicatorView = UIActivityIndicatorView()

    
    let GuestLoginButton: UIButton = {
        let lb = UIButton(type: .system)
        lb.setTitle("Enter", for: .normal)
        lb.setTitleColor(UIColor.white, for: .normal)
        lb.backgroundColor = UIColor.black.withAlphaComponent(0.25)
        lb.layer.cornerRadius = 40
        lb.layer.borderWidth = 1
        lb.layer.borderColor = UIColor.white.cgColor
        lb.titleLabel?.font = UIFont(name: "BebasNeue-Regular", size: 35)
        lb.addTarget(self, action: #selector(handleGuestEnter), for: .touchUpInside)
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    
    
    /*let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(frame: CGRect.zero)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        return aiv
    }()*/
    
    
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
        let sc = UISegmentedControl(items: ["Enter Listener Mode Below"])
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
        btn.setTitle("Please provide your email to enter Listener Mode.", for: .normal)
        btn.setTitleColor(lightblue, for: .normal)
        btn.titleLabel?.font = UIFont.italicSystemFont(ofSize: 15)
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
        let image = UIImage(named: "icons8-go-back-64")
        btn.setImage(image, for: .normal)
        btn.tintColor = UIColor.white
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
        
        self.usernameTextField.delegate = self
        self.passwordTextField.delegate = self
      
    }
    
    
    
    @objc func setupTextFields() {
        loginButtonTopAnchor?.constant = -55
        notUserLabel.isHidden = false
        passwordContainer.isHidden = true
        passwordImage.isHidden = true
        passwordTextField.isHidden = true
    }
    
    func setupNavBar() {
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backToBreakOff))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor(red: 214/255, green: 29/255, blue: 1, alpha:1.0)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        
        //Bar text
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "BebasNeue-Regular", size : 30) as Any, NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationItem.title = "Listener Mode"
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavBar()
    }
    
    @objc func backToBreakOff() {
        let storyboard = UIStoryboard(name: "breakOffStoryboard", bundle: nil)
        let breakOff = storyboard.instantiateViewController(withIdentifier: "breakOff") as! BreakoffController
        breakOff.modalPresentationStyle = .fullScreen
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
                    presentDJTableView(guestID: isFoundTuple.key)
                } else {
                    stopAnimating()
                    print("User was logged in but not found in guest database. So will now logout")
                    do {
                        try Auth.auth().signOut()
                    }
                    catch let error as NSError {
                        print("Error with signing out of firebase: \(error.localizedDescription)")
                    }
                }
            }
            else {
                stopAnimating()
                print("Error with already signed in ")
            }
            
        }
        else {
            stopAnimating()
            print("no user logged in")
        }
    }
    
    func getSnapshots() {
        print("GETTING SNAPSHOT")
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
                }
            }, withCancel: nil)
            
        }, withCancel: nil)
        
    }
    
    @objc func handleGuestEnter() {
        if !Reachability.isConnectedToNetwork() {
            let alert = UIAlertController(title: "Oops!", message: "It seems you aren't connected to the internet. \nReconnect and try again!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { action in
                self.navigationController?.popViewController(animated: true)
                self.stopAnimating()
                return
            }))
            self.present(alert, animated: true, completion: nil)
        }
        self.startAnimating()
        guard let email = usernameTextField.text?.lowercased(), email != "", let guestSnap = self.guestSnapshot else {
            print("Username is empty, or snap did not load")
            return
        }
        
        guard let djSnap = self.djSnapshot else {
            print("Dj Snap did not load")
            return
        }
        
        let djFoundTuple = isFound(snapshot: djSnap, guestEmail: email)
        if (djFoundTuple.0) {
            print("FOUND IN DJ SNAPSHOT!")
            let alert = UIAlertController(title: "Oops!", message: "Email \(email) is already associated with a DJ account. Please enter another for guest use.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { action in
                self.navigationController?.popViewController(animated: true)
                return
            }))
            self.stopAnimating()
            self.present(alert, animated: true, completion: nil)
            //checkIfValidated(uid: djFoundTuple.key)
        }

        
        //Found in database
        let isFoundTuple = isFound(snapshot: guestSnap, guestEmail: email)
        print(isFoundTuple.0)
        if isFoundTuple.0 {
            Auth.auth().signIn(withEmail: email, password: "123456", completion: { (user, error) in
                if let error = error {
                    let alert = UIAlertController(title: "Oh man!", message: "There has been an error with your sign-in. Please try again or come back later.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { action in
                        self.navigationController?.popViewController(animated: true)
                    }))
                    self.stopAnimating()
                    self.present(alert, animated: true, completion: nil)
                    print("Error signing in with the user from email: \(error.localizedDescription)")
                    return
                }
                else {
                    self.presentDJTableView(guestID: isFoundTuple.key)
                }
            })
        }
        //Not found in database, check if its well formed and then add it in
        else {
            //Also signs them in
            Auth.auth().createUser(withEmail: email, password: "123456", completion: { (user, error) in
                if let error = error {
                    self.stopAnimating()
                    print(error)
                    print("Error creating user and logging in from the user from email: \(error.localizedDescription)")
                    return
                }
                else {
                    print("successful creation and loggin in of user from email")
                    let ref = Database.database().reference().child("guests")
                    let key = ref.childByAutoId().key
                    let values = ["email":email]
                    ref.child(key!).setValue(values)
                    self.presentDJTableView(guestID: key!)
                }
            })
            
        }

    }
    
    func presentDJTableView (guestID: String) {
        self.startAnimating()
        let initialTab = CustomInitialTabBarController()
        
        //Send selected DJ and guest id to new views
        
        initialTab.setGuestIDs(id: guestID)
        let browseNavController = UINavigationController()
        let browseDJsVC = initialTab.browseCollectionView
        let djMenuVC = initialTab.collectionsVC
        browseDJsVC.usersSnapshot = self.djSnapshot
        djMenuVC.usersSnapshot = self.djSnapshot
        self.stopAnimating()
        initialTab.modalPresentationStyle = .fullScreen
        present(initialTab, animated: true, completion: nil)
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
        view.addSubview(GuestLoginButton)
        view.addSubview(usernameContainer)
        view.addSubview(passwordContainer)
        view.addSubview(djOrGuestSegmentedControl)
        view.addSubview(notUserLabel)
        view.addSubview(logoInLogin)
        view.addSubview(logoGo)
        view.addSubview(logoDJ)
        view.addSubview(backButton)
        //view.addSubview(activityIndicatorView)
        //activityIndicatorView.isHidden = true

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
        
        
        GuestLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginButtonTopAnchor = GuestLoginButton.topAnchor.constraint(equalTo: passwordContainer.bottomAnchor, constant: 50)
        loginButtonTopAnchor?.isActive = true
        GuestLoginButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
        GuestLoginButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        
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


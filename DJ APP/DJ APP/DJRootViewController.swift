//
//  DJRootViewController.swift
//  DJ APP
//
//  Created by arturo ho on 8/28/17.
//  Copyright © 2017 Marquel and Micajuine App Team. All rights reserved.
//

import UIKit
import Firebase

class DJRootViewController: UIViewController {

    var dj: UserDJ?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupViews()
        
        self.view.backgroundColor = UIColor.black
    }
    
    lazy var profilePic: ProfileImageView = {
        let pp = ProfileImageView()
        pp.alpha = 0.85
        //pp.image = UIImage(named: "usernameIcon")
        pp.contentMode = .scaleAspectFill
        pp.layer.cornerRadius = 33
        pp.clipsToBounds = true
        pp.layer.borderWidth = 2.5
        pp.layer.borderColor = UIColor(red: 214/255, green: 29/255, blue: 1, alpha:0.9).cgColor
        pp.translatesAutoresizingMaskIntoConstraints = false
        //pp.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleImageSelection)))
        return pp
    }()
    
    
    let backgroundImage: UIImageView = {
        let bi = UIImageView()
        bi.image = UIImage(named: "headphonesImage")
        bi.translatesAutoresizingMaskIntoConstraints = false
        bi.contentMode = .scaleAspectFill
        bi.layer.masksToBounds = true
        return bi
    }()
    
    let welcomeLabel: UILabel = {
       let lbl = UILabel()
        lbl.backgroundColor = UIColor.clear
        lbl.textColor = UIColor.white
        lbl.font = UIFont(name: "SudegnakNo2", size: 50)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .center
        return lbl
    }()
    
    let questionLabel: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = UIColor.clear
        lbl.textColor = UIColor.white
        //lbl.font = UIFont(name: "SudegnakNo2", size: 40)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .center
        lbl.text = "What would you like to do?"
        return lbl
    }()
    
    let GoLiveBtn: UIButton = {
        let lb = UIButton(type: .system)
        lb.setTitle("Go Live", for: .normal)
        lb.setTitleColor(UIColor.green, for: .normal)
        lb.backgroundColor = UIColor.clear
        lb.layer.cornerRadius = 30
        lb.layer.borderWidth = 3
        lb.layer.borderColor = UIColor(red: 214/255, green: 29/255, blue: 1, alpha:0.9).cgColor
        //lb.titleLabel?.font = UIFont(name: "SudegnakNo2", size: 45)
        //lb.addTarget(self, action: #selector(handleLoginEnter), for: .touchUpInside)
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    let SchedulingBtn: UIButton = {
        let lb = UIButton(type: .system)
        lb.setTitle("Schedule Events", for: .normal)
        lb.setTitleColor(UIColor.blue, for: .normal)
        lb.backgroundColor = UIColor.clear
        lb.layer.cornerRadius = 30
        lb.layer.borderWidth = 3
        lb.layer.borderColor = UIColor(red: 214/255, green: 29/255, blue: 1, alpha:0.9).cgColor
        //lb.titleLabel?.font = UIFont(name: "SudegnakNo2", size: 33)
        lb.addTarget(self, action: #selector(handleSchedulingEnter), for: .touchUpInside)
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    let ProfileBtn: UIButton = {
        let lb = UIButton(type: .system)
        lb.setTitle("Edit Your DJ Profile", for: .normal)
        lb.setTitleColor(UIColor.blue, for: .normal)
        lb.backgroundColor = UIColor.clear
        lb.layer.cornerRadius = 30
        lb.layer.borderWidth = 3
        lb.layer.borderColor = UIColor(red: 214/255, green: 29/255, blue: 1, alpha:0.9).cgColor
        //lb.titleLabel?.font = UIFont(name: "SudegnakNo2", size: 33)
        lb.addTarget(self, action: #selector(handleDJProfileEnter), for: .touchUpInside)
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    let MessagesBtn: UIButton = {
        let lb = UIButton(type: .system)
        lb.setTitle("View Messages", for: .normal)
        lb.setTitleColor(UIColor.blue, for: .normal)
        lb.backgroundColor = UIColor.clear
        lb.layer.cornerRadius = 30
        lb.layer.borderWidth = 3
        lb.layer.borderColor = UIColor(red: 214/255, green: 29/255, blue: 1, alpha:0.9).cgColor
        //lb.titleLabel?.font = UIFont(name: "SudegnakNo2", size: 33)
        //lb.addTarget(self, action: #selector(handleDJProfileEnter), for: .touchUpInside)
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    
    func setupNavigationBar() {
        print("Setting up Nav Bar")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor(red: 214/255, green: 29/255, blue: 1, alpha:0.9)
    }
    
    
    
    
    func setupViews() {
        print("Entering setupViews")
        
        if let name = dj?.djName {
            welcomeLabel.text = "Welcome \(name)!"
        }
        else{
            print("DJ did not have an ID for name this time")
        }
        if let profileUrl = dj?.profilePicURL {
            profilePic.loadImageWithChachfromUrl(urlString: profileUrl)
        }
        else{
            print("DJ did not have an ID for pic this time")
        }
        
        view.addSubview(welcomeLabel)
        view.addSubview(GoLiveBtn)
        view.addSubview(questionLabel)
        view.addSubview(profilePic)
        view.addSubview(SchedulingBtn)
        view.addSubview(ProfileBtn)
        view.addSubview(MessagesBtn)
        //print(dj?.djName! as Any)
        
        //backgroundImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        //backgroundImage.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        //backgroundImage.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        //backgroundImage.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
        GoLiveBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -90).isActive = true
        GoLiveBtn.heightAnchor.constraint(equalToConstant: 80).isActive = true
        GoLiveBtn.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 5).isActive = true
        GoLiveBtn.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        SchedulingBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 90).isActive = true
        SchedulingBtn.heightAnchor.constraint(equalToConstant: 80).isActive = true
        SchedulingBtn.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 5).isActive = true
        SchedulingBtn.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        ProfileBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 90).isActive = true
        ProfileBtn.heightAnchor.constraint(equalToConstant: 80).isActive = true
        ProfileBtn.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 120).isActive = true
        ProfileBtn.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        MessagesBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -90).isActive = true
        MessagesBtn.heightAnchor.constraint(equalToConstant: 80).isActive = true
        MessagesBtn.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 120).isActive = true
        MessagesBtn.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        profilePic.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profilePic.topAnchor.constraint(equalTo: view.topAnchor, constant: 90).isActive = true
        profilePic.widthAnchor.constraint(equalToConstant: 140).isActive = true
        profilePic.heightAnchor.constraint(equalToConstant: 150).isActive = true

        
        questionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        questionLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -13).isActive = true
        questionLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        questionLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        
        welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        welcomeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -65).isActive = true
        welcomeLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        welcomeLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    func handleSchedulingEnter(){
        
        let storyboard = UIStoryboard(name: "ScehdulingStoryboard", bundle:nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "scheduleView") as! scheduleViewController
        controller.dj = dj
        self.present(controller, animated: true, completion: nil)
    }
    
    func handleLogout() {
        let fireAuth = Auth.auth()
        
        do {
            try fireAuth.signOut()
        } catch let signoutError as NSError {
            print("Error signing out: %@", signoutError)
        }
        
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
    }
    
    func handleDJProfileEnter(){
        let storyboard = UIStoryboard(name: "ScehdulingStoryboard", bundle:nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "DJSideProfileController") as! DJSideProfileViewController
        controller.dj = dj
        self.present(controller, animated: true, completion: nil)
    }


}

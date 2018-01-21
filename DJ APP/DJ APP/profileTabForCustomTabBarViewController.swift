//
//  profileTabForCustomTabBarViewController.swift
//  DJ APP
//
//  Created by Marquel Hendricks on 1/5/18.
//  Copyright © 2018 Marquel and Micajuine App Team. All rights reserved.
//

import UIKit
import Firebase

class profileTabForCustomTabBarViewController: UIViewController {

    var dj: UserDJ?
    var guestID: String?
    
    /*let messagesBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.layer.cornerRadius = 30
        btn.setTitle("Hit Up The DJ!", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.titleLabel?.font = UIFont(name: "SudegnakNo2", size: 15)
        btn.backgroundColor = UIColor(red: 214/255, green: 29/255, blue: 1, alpha:0.9)
        btn.layer.borderWidth = 3
        btn.layer.borderColor = UIColor(red: 214/255, green: 29/255, blue: 1, alpha:0.9).cgColor
        btn.addTarget(self, action: #selector(handleDM), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()*/
    
    let backgroundImage: UIImageView = {
        let bi = UIImageView()
        bi.image = UIImage(named: "headphonesImage")
        bi.translatesAutoresizingMaskIntoConstraints = false
        bi.contentMode = .scaleAspectFill
        bi.layer.masksToBounds = true
        return bi
    }()
    
    let profileBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.layer.cornerRadius = 30
        btn.setTitle("Enter DJ Profile", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.titleLabel?.font = UIFont(name: "SudegnakNo2", size: 30)
        btn.backgroundColor = UIColor(red: 214/255, green: 29/255, blue: 1, alpha:0.9)
        btn.layer.borderWidth = 3
        btn.layer.borderColor = UIColor(red: 214/255, green: 29/255, blue: 1, alpha:0.9).cgColor
        //lb.titleLabel?.font = UIFont(name: "SudegnakNo2", size: 33)
        btn.addTarget(self, action: #selector(handleProfileEnter), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    /*func handleDM(){
        print("DM was pressed")
        let chatController = GuestChatViewController(collectionViewLayout: UICollectionViewFlowLayout())
        chatController.dj = self.dj
        chatController.guestID = self.guestID
        if let height = tabBarController?.tabBar.frame.height {
            chatController.tabbarHeight = height
        }
        else {
            print("DJ Profile view does not have a tabbarcontroller height to send in")
        }
        
        let chatNavigationController = UINavigationController(rootViewController: chatController)
        
        if self.presentedViewController != nil {
            //do i have to keep this?
            self.dismiss(animated: true, completion: nil)
        }
        self.tabBarController?.present(chatNavigationController, animated: true, completion: nil)
    }*/
    
    func handleProfileEnter() {
        let myStoryboard = UIStoryboard(name: "djProfileStoryboard", bundle: nil)
        let myDJProfileController = myStoryboard.instantiateViewController(withIdentifier: "DJProfileView") as! DJPRofileViewController
        
        myDJProfileController.dj = dj
        myDJProfileController.guestID = guestID
        
        present(myDJProfileController, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black
        setupViews()
        setupNavBar()
        // Do any additional setup after loading the view.
    }
    
    func setupNavBar() {
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "SudegnakNo2", size : 33) as Any]
        self.navigationItem.title = "DJ Profile"
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .rewind, target: self, action: #selector(handleBack))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor(red: 214/255, green: 29/255, blue: 1, alpha:1.0)
    }
    
    func handleBack() {
        self.parent?.dismiss(animated: true, completion: nil)
    }
    
    func setupViews(){
        //view.addSubview(messagesBtn)
        view.addSubview(backgroundImage)
        view.addSubview(profileBtn)
        //messagesBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 90).isActive = true
        //messagesBtn.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        //messagesBtn.heightAnchor.constraint(equalToConstant: 80).isActive = true
        //messagesBtn.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        backgroundImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        backgroundImage.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        backgroundImage.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        backgroundImage.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
        profileBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileBtn.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        profileBtn.heightAnchor.constraint(equalToConstant: 80).isActive = true
        profileBtn.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

//
//  BreakoffController.swift
//  DJ APP
//
//  Created by Marquel Hendricks on 1/7/19.
//  Copyright © 2019 Marquel and Micajuine App Team. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import LGButton

class BreakoffController: UIViewController, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBAction func djRequestButtonTapped(_ sender: Any) {
        let loginController = DJLoginController()
        print("PRESENTING DJ LOGIN CONTROLLER")
        self.present(loginController, animated: true, completion: nil)
    }
    
    @IBAction func guestButtonTapped(_ sender: Any) {
        let loginController = LoginController()
        print("PRESENTING LOGIN CONTROLLER")
        self.present(loginController, animated: true, completion: nil)
    }
    
    
    
    
    /*let requestEngineButton: UIButton = {
        let lb = UIButton(type: .system)
        lb.setTitle("Go.DJ Request Engine", for: .normal)
        lb.setTitleColor(UIColor.white, for: .normal)
        lb.backgroundColor = UIColor.black.withAlphaComponent(0.25)
        lb.layer.cornerRadius = 40
        lb.layer.borderWidth = 1
        lb.layer.borderColor = UIColor.white.cgColor
        lb.titleLabel?.font = UIFont(name: "Mikodacs", size: 25)
        lb.addTarget(self, action: #selector(handleRequestEnter), for: .touchUpInside)
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()*/
    
    let logoInLogin: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "headphones")
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    /*let findADJButton: UIButton = {
        let lb = UIButton(type: .system)
        lb.setTitle("Find A DJ", for: .normal)
        lb.setTitleColor(UIColor.white, for: .normal)
        lb.backgroundColor = UIColor.black.withAlphaComponent(0.25)
        lb.layer.cornerRadius = 40
        lb.layer.borderWidth = 1
        lb.layer.borderColor = UIColor.white.cgColor
        lb.titleLabel?.font = UIFont(name: "Mikodacs", size: 25)
        lb.addTarget(self, action: #selector(handleFindDJEnter), for: .touchUpInside)
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()*/
    
    @objc func handleFindDJEnter() {
        //let findADJController = findADJController()
        
    }
    
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.black
        addLogo()
    }
    
    @objc func handleRequestEnter() {
        let loginController = LoginController()
        self.present(loginController, animated: true, completion: nil)
    }
    
    func addLogo() {
        self.view.addSubview(logoInLogin)
        logoInLogin.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 5).isActive = true
        logoInLogin.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 65).isActive = true
        logoInLogin.heightAnchor.constraint(equalToConstant: 60).isActive = true
        logoInLogin.widthAnchor.constraint(equalToConstant: 125).isActive = true
    }





}

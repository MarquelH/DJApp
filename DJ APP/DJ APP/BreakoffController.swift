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
import NVActivityIndicatorView

class BreakoffController: UIViewController, UINavigationControllerDelegate, UITextFieldDelegate, NVActivityIndicatorViewable {
    
    @IBAction func djRequestButtonTapped(_ sender: Any) {
        let loginController = DJLoginController()
        //print("PRESENTING DJ LOGIN CONTROLLER")
        loginController.modalPresentationStyle = .fullScreen
        self.present(loginController, animated: true, completion: nil)
    }
    
    @IBAction func guestButtonTapped(_ sender: Any) {
        let loginController = LoginController()
        //print("PRESENTING GUEST LOGIN CONTROLLER")
        loginController.modalPresentationStyle = .fullScreen
        self.present(loginController, animated: true, completion: nil)
    }
    
    let logoInLogin: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "GoDJLogo")
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    @objc func handleFindDJEnter() {
        //let findADJController = findADJController()
        
    }
    
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.black
        addLogo()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if Reachability.isConnectedToNetwork() && (UserDefaults.standard.integer(forKey: "launchCount") > 2){
         startAnimating(CGSize(width: 30, height: 30), message: "Checking if already logged in", messageFont: UIFont(name: "BebasNeue-Regular", size: 30), type: .audioEqualizer, color: UIColor(red: 214/255, green: 29/255, blue: 1, alpha:0.5), padding: 0, displayTimeThreshold: 7, minimumDisplayTime: 0, backgroundColor: .black, textColor: .white, fadeInAnimation: nil)
        }
    }
    
    func addLogo() {
        self.view.addSubview(logoInLogin)
        logoInLogin.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 5).isActive = true
        logoInLogin.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 65).isActive = true
        logoInLogin.heightAnchor.constraint(equalToConstant: 60).isActive = true
        logoInLogin.widthAnchor.constraint(equalToConstant: 125).isActive = true
    }





}

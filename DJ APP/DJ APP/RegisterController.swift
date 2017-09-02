//
//  RegisterController.swift
//  DJ APP
//
//  Created by arturo ho on 8/28/17.
//  Copyright © 2017 Marquel and Micajuine App Team. All rights reserved.
//

import UIKit

class RegisterController: UIViewController {

    let profilePic: UIImageView = {
        let pp = UIImageView()
        pp.alpha = 0.85
        pp.image = UIImage(named: "usernameIcon")
        pp.contentMode = .scaleAspectFit
        pp.layer.cornerRadius = 60
        pp.clipsToBounds = true
        pp.layer.borderWidth = 1.0
        pp.layer.borderColor = UIColor.black.cgColor
        pp.translatesAutoresizingMaskIntoConstraints = false
        return pp
    }()
    
    let addPhoto: UIButton = {
        let ap = UIButton()
        let lightblue = UIColor(colorLiteralRed: 94/255, green: 211/255, blue: 237/255, alpha: 1)
        ap.setTitleColor(lightblue, for: .normal)
        ap.setTitleColor(UIColor.white, for: .highlighted)
        ap.titleLabel?.lineBreakMode = .byWordWrapping
        ap.titleLabel?.textAlignment = .center
        ap.titleLabel?.font = ap.titleLabel?.font.withSize(30)
        ap.setTitle("Add\nphoto", for: .normal)
        ap.translatesAutoresizingMaskIntoConstraints = false
        ap.addTarget(self, action: #selector(handlePicTapped), for: .touchUpInside)
        return ap
    }()
    
    let hometownLabel: UILabel = {
        let ht = UILabel()
        ht.textColor = UIColor.gray
        ht.text = "Hometown:"
        ht.backgroundColor = UIColor.red
        ht.translatesAutoresizingMaskIntoConstraints = false
        return ht
    }()
    
    let hometownTextField: UITextField = {
        let htf = UITextField()
        htf.backgroundColor = UIColor.yellow
        htf.clearButtonMode = .whileEditing
        htf.translatesAutoresizingMaskIntoConstraints = false
        return htf
    }()
    
    let hometownSep: UIView = {
        let hs = UIView()
        hs.backgroundColor = UIColor.lightGray
        hs.translatesAutoresizingMaskIntoConstraints = false
        return hs
    }()
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        setupNavigationBar()
        setupViews()
    }

    func setupNavigationBar() {
        self.navigationItem.title = "Enter Info"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(handleCancel))
    }
    
    func setupViews(){
        view.addSubview(profilePic)
        view.addSubview(addPhoto)
        view.addSubview(hometownLabel)
        view.addSubview(hometownTextField)
        view.addSubview(hometownSep)

        
        profilePic.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profilePic.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 24).isActive = true
        profilePic.widthAnchor.constraint(equalToConstant: 120).isActive = true
        profilePic.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        
        addPhoto.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        addPhoto.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 25).isActive = true
        addPhoto.widthAnchor.constraint(equalTo: profilePic.widthAnchor, multiplier: 1).isActive = true
        addPhoto.heightAnchor.constraint(equalTo: profilePic.heightAnchor, multiplier: 1).isActive = true
        
        hometownLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        hometownLabel.topAnchor.constraint(equalTo: profilePic.bottomAnchor, constant: 24).isActive = true
        hometownLabel.widthAnchor.constraint(equalToConstant: hometownLabel.intrinsicContentSize.width).isActive = true
        hometownLabel.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        hometownTextField.leftAnchor.constraint(equalTo: hometownLabel.rightAnchor, constant: 12).isActive = true
        hometownTextField.topAnchor.constraint(equalTo: hometownLabel.topAnchor).isActive = true
        hometownTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive = true
        hometownTextField.heightAnchor.constraint(equalTo: hometownLabel.heightAnchor).isActive = true
        
        hometownSep.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        hometownSep.topAnchor.constraint(equalTo: hometownLabel.bottomAnchor, constant: 6).isActive = true
        hometownSep.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        hometownSep.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        
    }
    
    func handlePicTapped() {
        print("Add image here...")
    }
    
    func handleCancel() {
        print("Dissmissing register controller")
        self.dismiss(animated: true, completion: nil)
    }
}

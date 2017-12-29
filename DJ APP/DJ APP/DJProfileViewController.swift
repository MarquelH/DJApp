//
//  DJProfileViewController.swift
//  DJ APP
//
//  Created by Marquel Hendricks on 10/12/17.
//  Copyright © 2017 Marquel and Micajuine App Team. All rights reserved.
//

import UIKit
import FirebaseDatabase

class DJPRofileViewController: UIViewController {
    
    var dj: UserDJ?
    var guestID: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let name = dj?.djName {
            print("Dj name is: \(name)")
        }
        else {
            print("Dj was not passed through")
        }
        setupViews()
    }

    func handleDM() {
        print("DM was pressed")
    }
    
    func setupViews() {
        if let name = dj?.djName, let hometown = dj?.hometown, let profileUrl = dj?.profilePicURL, let age = dj?.age {
            djNameLabel.text = "Name: \(name)"
            profilePic.loadImageWithChachfromUrl(urlString: profileUrl)
            djHometownText.text = "Hometown: \(hometown)"
            ageLabel.text = "Age: \(age)"
        }
        else {
           print("No DJ at setupViews")
        }
       
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        view.addSubview(scrollView)
        scrollView.addSubview(profilePic)
        scrollView.addSubview(djNameLabel)
        
        //scrollView.contentInset = UIEdgeInsets(top:0, left:0, bottom: (tabBarController?.tabBar.frame.height)!, right: 0)
     
        
        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scrollView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
        profilePic.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        profilePic.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 24).isActive = true
        profilePic.widthAnchor.constraint(equalToConstant: 120).isActive = true
        profilePic.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        djNameLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 24).isActive = true
        djNameLabel.topAnchor.constraint(equalTo: profilePic.bottomAnchor, constant: 18).isActive = true
        djNameLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: 16).isActive = true
        djNameLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        
//        view.addSubview(profilePic)
//        view.addSubview(hometownLabel)
//        view.addSubview(djNameLabel)
//        view.addSubview(hometownSep)
//        view.addSubview(genreLabel)
//        view.addSubview(ageLabel)
//        view.addSubview(twitterLabel)
//        view.addSubview(twitterSep)
//        view.addSubview(dmDJButton)
//        view.addSubview(headphonesLogo)
//        view.addSubview(djHometownText)
        
        
//        //djHometownText.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        //djHometownText.bottomAnchor.constraint(equalTo: hometownLabel.bottomAnchor).isActive = true
//        djHometownText.leftAnchor.constraint(equalTo: hometownLabel.rightAnchor).isActive = true
//        djHometownText.widthAnchor.constraint(equalToConstant: 235).isActive = true
//        djHometownText.heightAnchor.constraint(equalToConstant: 50).isActive = true
//        djHometownText.topAnchor.constraint(equalTo: hometownLabel.topAnchor).isActive = true
//
//        headphonesLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        headphonesLogo.topAnchor.constraint(equalTo: twitterSep.bottomAnchor, constant:40).isActive = true
//        headphonesLogo.heightAnchor.constraint(equalToConstant: 20).isActive = true
//        headphonesLogo.widthAnchor.constraint(equalToConstant: 95).isActive = true
//
//        dmDJButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        dmDJButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
//        dmDJButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
//        dmDJButton.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//
//        twitterSep.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        twitterSep.topAnchor.constraint(equalTo: twitterLabel.bottomAnchor, constant: 15).isActive = true
//        //hometownSep.bottomAnchor.constraint(equalTo: hometownLabel.topAnchor).isActive = true
//        twitterSep.heightAnchor.constraint(equalToConstant: 2.5).isActive = true
//        twitterSep.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
//
//        twitterLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        twitterLabel.topAnchor.constraint(equalTo: ageLabel.bottomAnchor, constant: 27).isActive = true
//        twitterLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
//
//        ageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        ageLabel.topAnchor.constraint(equalTo: genreLabel.bottomAnchor, constant: 27).isActive = true
//        ageLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
//
//        genreLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        genreLabel.topAnchor.constraint(equalTo: hometownLabel.bottomAnchor, constant: 27).isActive = true
//        genreLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
//
//        hometownSep.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        hometownSep.topAnchor.constraint(equalTo: djNameLabel.bottomAnchor).isActive = true
//        //hometownSep.bottomAnchor.constraint(equalTo: hometownLabel.topAnchor).isActive = true
//        hometownSep.heightAnchor.constraint(equalToConstant: 2.5).isActive = true
//        hometownSep.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
//
//        profilePic.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        profilePic.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
//        profilePic.widthAnchor.constraint(equalToConstant: 140).isActive = true
//        profilePic.heightAnchor.constraint(equalToConstant: 150).isActive = true
//
//        hometownLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        hometownLabel.topAnchor.constraint(equalTo: djNameLabel.bottomAnchor, constant: 20).isActive = true
//        hometownLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
//
//        djNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        djNameLabel.topAnchor.constraint(equalTo: profilePic.bottomAnchor, constant: 8).isActive = true
//        djNameLabel.widthAnchor.constraint(equalToConstant: 235).isActive = true
//        djNameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.backgroundColor = UIColor.lightGray
        return sv
    }()
    
    lazy var profilePic: ProfileImageView = {
        let pp = ProfileImageView()
        pp.contentMode = .scaleAspectFill
        pp.layer.cornerRadius = 60
        pp.layer.masksToBounds = true
        pp.clipsToBounds = true
        pp.layer.borderWidth = 1.0
        pp.layer.borderColor = UIColor.black.cgColor
        pp.translatesAutoresizingMaskIntoConstraints = false
        return pp
    }()
    
    
    let djHometownText: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.white
        lbl.font = UIFont(name: "SudegnakNo2", size: 40)
        lbl.backgroundColor = UIColor.clear
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let twitterIcon: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.image = UIImage(named: "twitter-square-logo")
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    let hometownLabel: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = UIColor.clear
        lbl.textColor = UIColor(red: 214/255, green: 29/255, blue: 1, alpha:1.0)
        lbl.font = UIFont(name: "SudegnakNo2", size : 26)
        lbl.text = "Hometown:"
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let djNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = UIColor.clear
        lbl.textColor = UIColor.white
        lbl.font = UIFont(name: "SudegnakNo2", size: 24)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let headphonesLogo: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "headphones")
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    let twitterLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor(red: 214/255, green: 29/255, blue: 1, alpha:1.0)
        lbl.text = "Twitter/Instagram:"
        lbl.font = UIFont(name: "SudegnakNo2", size : 26)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let twitterSep: UIView = {
        let sep = UIView()
        sep.backgroundColor = UIColor(red: 214/255, green: 29/255, blue: 1, alpha:1.0)
        sep.translatesAutoresizingMaskIntoConstraints = false
        return sep
    }()
    
    let hometownSep: UIView = {
        let hs = UIView()
        hs.backgroundColor = UIColor(red: 214/255, green: 29/255, blue: 1, alpha:1.0)
        hs.translatesAutoresizingMaskIntoConstraints = false
        return hs
    }()
    
    let ageLabel: UILabel = {
        let al = UILabel()
        al.textColor = UIColor(red: 214/255, green: 29/255, blue: 1, alpha:1.0)
        al.font = UIFont(name: "SudegnakNo2", size: 26)
        al.text = "Age:"
        al.translatesAutoresizingMaskIntoConstraints = false
        return al
    }()
    
    
    let ageSep: UIView = {
        let aS = UIView()
        aS.backgroundColor = UIColor.lightGray
        aS.translatesAutoresizingMaskIntoConstraints = false
        return aS
    }()
    
    let genreLabel: UILabel = {
        let gl = UILabel()
        gl.textColor = UIColor(red: 214/255, green: 29/255, blue: 1, alpha:1.0)
        gl.text = "Main Genre:"
        gl.font = UIFont(name: "SudegnakNo2", size: 26)
        gl.translatesAutoresizingMaskIntoConstraints = false
        return gl
    }()
    
    let dmDJButton: UIButton = {
        let lb = UIButton(type: .system)
        lb.setTitle("Hit up The DJ!", for: .normal)
        lb.setTitleColor(UIColor.white, for: .normal)
        lb.backgroundColor = UIColor(red: 214/255, green: 29/255, blue: 1, alpha:1.0)
        lb.layer.cornerRadius = 40
        lb.layer.masksToBounds = true
        lb.layer.borderWidth = 1
        lb.layer.borderColor = UIColor.white.cgColor
        lb.titleLabel?.font = UIFont(name: "SudegnakNo2", size: 35)
        lb.addTarget(self, action: #selector(handleDM), for: .touchUpInside)
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    
    
    let genreSep: UIView = {
        let gs = UIView()
        gs.backgroundColor = UIColor.lightGray
        gs.translatesAutoresizingMaskIntoConstraints = false
        return gs
    }()
    
    
}





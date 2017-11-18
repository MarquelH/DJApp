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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        self.view.backgroundColor = UIColor.black

    }
    lazy var profilePic: UIImageView = {
        let pp = UIImageView()
        pp.alpha = 0.85
        //pp.image = UIImage(named: "usernameIcon")
        pp.contentMode = .scaleAspectFill
        pp.layer.cornerRadius = 30
        pp.clipsToBounds = true
        pp.layer.borderWidth = 1.0
        pp.layer.borderColor = UIColor.black.cgColor
        pp.translatesAutoresizingMaskIntoConstraints = false
        //pp.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleImageSelection)))
        return pp
    }()
    

    let djHometownText: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.white
        lbl.font = UIFont(name: "SudegnakNo2", size: 40)
        lbl.backgroundColor = UIColor.clear
        lbl.text = "Hello:"
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
        lbl.font = UIFont(name: "Exo-Thin", size : 20)
        lbl.text = "Hometown:"
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let DjNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = UIColor.clear
        lbl.textColor = UIColor.white
        lbl.font = UIFont(name: "SudegnakNo2", size: 50)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .center
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
        lbl.font = UIFont(name: "Exo-Thin", size : 17)
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
        al.font = UIFont(name: "Exo-Thin", size: 20)
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
        gl.font = UIFont(name: "Exo-Thin", size: 20)
        gl.translatesAutoresizingMaskIntoConstraints = false
        return gl
    }()
    
    let dmDJButton: UIButton = {
        let lb = UIButton(type: .system)
        lb.setTitle("Hit up The DJ!", for: .normal)
        lb.setTitleColor(UIColor.white, for: .normal)
        lb.backgroundColor = UIColor(red: 214/255, green: 29/255, blue: 1, alpha:1.0)
        lb.layer.cornerRadius = 40
        //lb.layer.borderWidth = 1
        //lb.layer.borderColor = UIColor.white.cgColor
        lb.titleLabel?.font = UIFont(name: "SudegnakNo2", size: 35)
        //lb.addTarget(self, action: #selector(handleLoginEnter), for: .touchUpInside)
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()

    
    
    let genreSep: UIView = {
        let gs = UIView()
        gs.backgroundColor = UIColor.lightGray
        gs.translatesAutoresizingMaskIntoConstraints = false
        return gs
    }()
    

    //hometown, dj name, genre, twitter/IG, age

    
    func setupViews() {
        if let name = dj?.djName {
        DjNameLabel.text = "\(name)"
        }
        if let hometown = dj?.hometown {
            djHometownText.text = "\(hometown)"
        }
        else{
            djHometownText.text = "Hometown:"
        }
        if let profileUrl = dj?.profilePicURL {
            profilePic.loadImageWithChachfromUrl(urlString: profileUrl)
        }
        
        
        view.addSubview(profilePic)
        view.addSubview(hometownLabel)
        view.addSubview(DjNameLabel)
        view.addSubview(hometownSep)
        view.addSubview(genreLabel)
        view.addSubview(ageLabel)
        view.addSubview(twitterLabel)
        view.addSubview(twitterSep)
        view.addSubview(dmDJButton)
        view.addSubview(headphonesLogo)
        view.addSubview(djHometownText)
        
        
        //djHometownText.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        //djHometownText.bottomAnchor.constraint(equalTo: hometownLabel.bottomAnchor).isActive = true
        djHometownText.leftAnchor.constraint(equalTo: hometownLabel.rightAnchor).isActive = true
        djHometownText.widthAnchor.constraint(equalToConstant: 235).isActive = true
        djHometownText.heightAnchor.constraint(equalToConstant: 50).isActive = true
        djHometownText.topAnchor.constraint(equalTo: hometownLabel.topAnchor).isActive = true
        
        headphonesLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        headphonesLogo.topAnchor.constraint(equalTo: twitterSep.bottomAnchor, constant:40).isActive = true
        headphonesLogo.heightAnchor.constraint(equalToConstant: 20).isActive = true
        headphonesLogo.widthAnchor.constraint(equalToConstant: 95).isActive = true
        
        dmDJButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        dmDJButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant:-55).isActive = true
        dmDJButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
        dmDJButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        
        twitterSep.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        twitterSep.topAnchor.constraint(equalTo: twitterLabel.bottomAnchor, constant: 15).isActive = true
        //hometownSep.bottomAnchor.constraint(equalTo: hometownLabel.topAnchor).isActive = true
        twitterSep.heightAnchor.constraint(equalToConstant: 2.5).isActive = true
        twitterSep.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        twitterLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        twitterLabel.topAnchor.constraint(equalTo: ageLabel.bottomAnchor, constant: 27).isActive = true
        twitterLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        ageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        ageLabel.topAnchor.constraint(equalTo: genreLabel.bottomAnchor, constant: 27).isActive = true
        ageLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        genreLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        genreLabel.topAnchor.constraint(equalTo: hometownLabel.bottomAnchor, constant: 27).isActive = true
        genreLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        hometownSep.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        hometownSep.topAnchor.constraint(equalTo: DjNameLabel.bottomAnchor).isActive = true
        //hometownSep.bottomAnchor.constraint(equalTo: hometownLabel.topAnchor).isActive = true
        hometownSep.heightAnchor.constraint(equalToConstant: 2.5).isActive = true
        hometownSep.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        profilePic.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profilePic.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        profilePic.widthAnchor.constraint(equalToConstant: 140).isActive = true
        profilePic.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        hometownLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        hometownLabel.topAnchor.constraint(equalTo: DjNameLabel.bottomAnchor, constant: 20).isActive = true
        hometownLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        DjNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        DjNameLabel.topAnchor.constraint(equalTo: profilePic.bottomAnchor, constant: 8).isActive = true
        DjNameLabel.widthAnchor.constraint(equalToConstant: 235).isActive = true
        DjNameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
    }
    
    
}





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
        if let name = dj?.djName, let hometown = dj?.hometown, let profileUrl = dj?.profilePicURL, let age = dj?.age, let genre = dj?.genre {
            djNameLabel.text = "Name: \(name)"
            profilePic.loadImageWithChachfromUrl(urlString: profileUrl)
            hometownLabel.text = "Hometown: \(hometown)"
            ageLabel.text = "Age: \(age)"
            genreLabel.text = "Genre: \(genre)"
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
        scrollView.addSubview(ageLabel)
        scrollView.addSubview(hometownLabel)
        scrollView.addSubview(genreLabel)
        scrollView.addSubview(dmDJButton)
        
        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scrollView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
        profilePic.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        profilePic.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 24).isActive = true
        profilePic.widthAnchor.constraint(equalToConstant: 140).isActive = true
        profilePic.heightAnchor.constraint(equalToConstant: 140).isActive = true
        
        djNameLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 24).isActive = true
        djNameLabel.topAnchor.constraint(equalTo: profilePic.bottomAnchor, constant: 18).isActive = true
        djNameLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -48).isActive = true
        djNameLabel.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        ageLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 24).isActive = true
        ageLabel.topAnchor.constraint(equalTo: djNameLabel.bottomAnchor, constant: 18).isActive = true
        ageLabel.widthAnchor.constraint(equalTo: djNameLabel.widthAnchor).isActive = true
        ageLabel.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        hometownLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 24).isActive = true
        hometownLabel.topAnchor.constraint(equalTo: ageLabel.bottomAnchor, constant: 18).isActive = true
        hometownLabel.widthAnchor.constraint(equalTo: djNameLabel.widthAnchor).isActive = true
        hometownLabel.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        genreLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 24).isActive = true
        genreLabel.topAnchor.constraint(equalTo: hometownLabel.bottomAnchor, constant: 18).isActive = true
        genreLabel.widthAnchor.constraint(equalTo: djNameLabel.widthAnchor).isActive = true
        genreLabel.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        dmDJButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 24).isActive = true
        dmDJButton.topAnchor.constraint(equalTo: genreLabel.bottomAnchor, constant: 36).isActive = true
        dmDJButton.widthAnchor.constraint(equalTo: djNameLabel.widthAnchor).isActive = true
        dmDJButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
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
        pp.layer.cornerRadius = 70
        pp.layer.masksToBounds = true
        pp.clipsToBounds = true
        pp.layer.borderWidth = 1.0
        pp.layer.borderColor = UIColor.black.cgColor
        pp.translatesAutoresizingMaskIntoConstraints = false
        return pp
    }()
    
    let hometownLabel: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = UIColor.clear
        lbl.textColor = UIColor(red: 214/255, green: 29/255, blue: 1, alpha:1.0)
        lbl.font = UIFont(name: "SudegnakNo2", size : 36)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    let ageLabel: UILabel = {
        let al = UILabel()
        al.backgroundColor = UIColor.clear
        al.textColor = UIColor(red: 214/255, green: 29/255, blue: 1, alpha:1.0)
        al.font = UIFont(name: "SudegnakNo2", size: 36)
        al.translatesAutoresizingMaskIntoConstraints = false
        return al
    }()
    
    let djNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = UIColor.clear
        lbl.textColor = UIColor.white
        lbl.font = UIFont(name: "SudegnakNo2", size: 36)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let genreLabel: UILabel = {
        let gl = UILabel()
        gl.textColor = UIColor(red: 214/255, green: 29/255, blue: 1, alpha:1.0)
        gl.font = UIFont(name: "SudegnakNo2", size: 36)
        gl.translatesAutoresizingMaskIntoConstraints = false
        return gl
    }()
    
    let dmDJButton: UIButton = {
        let lb = UIButton(type: .system)
        lb.setTitle("Hit up The DJ!", for: .normal)
        lb.setTitleColor(UIColor.white, for: .normal)
        lb.backgroundColor = UIColor(red: 214/255, green: 29/255, blue: 1, alpha:1.0)
        lb.layer.cornerRadius = 25
        lb.layer.masksToBounds = true
        lb.layer.borderWidth = 1
        lb.layer.borderColor = UIColor.white.cgColor
        lb.titleLabel?.font = UIFont(name: "SudegnakNo2", size: 36)
        lb.addTarget(self, action: #selector(handleDM), for: .touchUpInside)
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    let twitterIcon: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.image = UIImage(named: "twitter-square-logo")
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
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
}





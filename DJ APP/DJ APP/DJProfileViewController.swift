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
    
    override func viewDidLoad(){
        super.viewDidLoad()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        profilePic.isUserInteractionEnabled = true
        profilePic.addGestureRecognizer(tapGestureRecognizer)
        
        self.view.backgroundColor = UIColor.black
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "View Full Photo", style: UIAlertActionStyle.default, handler: { action in
            self.loadUpFullView(tapGestureRec: tapGestureRecognizer)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: { action in
            self.navigationController?.popViewController(animated: true)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func loadUpFullView(tapGestureRec: UITapGestureRecognizer){
        let imageView = tapGestureRec.view as! UIImageView
        let newImageView = UIImageView(image: imageView.image)
        newImageView.frame = UIScreen.main.bounds
        newImageView.backgroundColor = .black
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        newImageView.addGestureRecognizer(tap)
        self.scrollView.isHidden = true
        view.addSubview(newImageView)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func dismissFullscreenImage(sender: UITapGestureRecognizer) {
        self.scrollView.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
        sender.view?.removeFromSuperview()
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
        let storyboard = UIStoryboard(name: "djProfileStoryboard", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "GuestContactView") as! GuestContactFormViewController
        controller.dj = dj
        controller.guestID = guestID
        self.present(controller, animated: true, completion: nil)
    }
    
    func setupViews() {
        if let name = dj?.djName, let hometown = dj?.hometown, let profileUrl = dj?.profilePicURL, let age = dj?.age, let genre = dj?.genre, let twitterHandle = dj?.twitter {
            djNameLabel.text = "\(name)"
            profilePic.loadImageWithChachfromUrl(urlString: profileUrl)
            hometownText.text = "\(hometown)"
            ageText.text = "\(age)"
            genreText.text = "\(genre)"
            twitterText.text = "\(twitterHandle)"
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
        scrollView.addSubview(twitterLabel)
        
        scrollView.addSubview(ageText)
        scrollView.addSubview(hometownText)
        scrollView.addSubview(genreText)
        scrollView.addSubview(twitterText)
        
        scrollView.addSubview(dmDJButton)
        scrollView.addSubview(headphonesLogo)
        
        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scrollView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
        let backgroundImage: UIImageView = UIImageView(frame: view.bounds)
        backgroundImage.image = UIImage(named: "jacob-morch-272617")
        backgroundImage.contentMode = .scaleAspectFit
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.insertSubview(backgroundImage, at: 0)
        
        backgroundImage.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        backgroundImage.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
        backgroundImage.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        backgroundImage.bottomAnchor.constraint(equalTo: scrollView.centerYAnchor).isActive = true
        
        profilePic.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        profilePic.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 24).isActive = true
        profilePic.widthAnchor.constraint(equalToConstant: 140).isActive = true
        profilePic.heightAnchor.constraint(equalToConstant: 140).isActive = true
        
        
        
        
        djNameLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        djNameLabel.topAnchor.constraint(equalTo: profilePic.bottomAnchor, constant: 12).isActive = true
        djNameLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -36).isActive = true
        djNameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        ageLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16).isActive = true
        ageLabel.topAnchor.constraint(equalTo: djNameLabel.bottomAnchor, constant: 18).isActive = true
        ageLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        ageLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        hometownLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16).isActive = true
        hometownLabel.topAnchor.constraint(equalTo: ageLabel.bottomAnchor, constant: 18).isActive = true
        hometownLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        hometownLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        genreLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16).isActive = true
        genreLabel.topAnchor.constraint(equalTo: hometownLabel.bottomAnchor, constant: 18).isActive = true
        genreLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        genreLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        twitterLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16).isActive = true
        twitterLabel.topAnchor.constraint(equalTo: genreLabel.bottomAnchor, constant: 18).isActive = true
        twitterLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        twitterLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        
        ageText.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16).isActive = true
        ageText.topAnchor.constraint(equalTo: djNameLabel.bottomAnchor, constant: 18).isActive = true
        ageText.widthAnchor.constraint(equalTo: djNameLabel.widthAnchor).isActive = true
        ageText.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        hometownText.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16).isActive = true
        hometownText.topAnchor.constraint(equalTo: ageLabel.bottomAnchor, constant: 18).isActive = true
        hometownText.widthAnchor.constraint(equalTo: djNameLabel.widthAnchor).isActive = true
        hometownText.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        genreText.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16).isActive = true
        genreText.topAnchor.constraint(equalTo: hometownLabel.bottomAnchor, constant: 18).isActive = true
        genreText.widthAnchor.constraint(equalTo: djNameLabel.widthAnchor).isActive = true
        genreText.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        twitterText.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16).isActive = true
        twitterText.topAnchor.constraint(equalTo: genreLabel.bottomAnchor, constant: 18).isActive = true
        twitterText.widthAnchor.constraint(equalTo: djNameLabel.widthAnchor).isActive = true
        twitterText.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        headphonesLogo.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        headphonesLogo.topAnchor.constraint(equalTo: twitterLabel.bottomAnchor, constant: 50).isActive = true
        headphonesLogo.widthAnchor.constraint(equalToConstant: 75).isActive = true
        headphonesLogo.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
        //dmDJButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 24).isActive = true
        dmDJButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        dmDJButton.topAnchor.constraint(equalTo: twitterLabel.bottomAnchor, constant: 150).isActive = true
        dmDJButton.widthAnchor.constraint(equalTo: djNameLabel.widthAnchor).isActive = true
        dmDJButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
    }
    
    let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.backgroundColor = UIColor.black
        return sv
    }()

    
    lazy var profilePic: ProfileImageView = {
        let pp = ProfileImageView()
        pp.contentMode = .scaleAspectFill
        pp.layer.cornerRadius = 70
        pp.layer.masksToBounds = true
        pp.clipsToBounds = true
        pp.layer.borderWidth = 1.0
        pp.layer.borderColor = UIColor(red: 214/255, green: 29/255, blue: 1, alpha:1.0).cgColor
        pp.translatesAutoresizingMaskIntoConstraints = false
        return pp
    }()
    
    let hometownLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor(red: 214/255, green: 29/255, blue: 1, alpha:1.0)
        lbl.font = UIFont(name: "Mikodacs", size : 26)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Hometown:"
        return lbl
    }()
    
    let ageLabel: UILabel = {
        let al = UILabel()
        al.textColor = UIColor(red: 214/255, green: 29/255, blue: 1, alpha:1.0)
        al.font = UIFont(name: "Mikodacs", size: 26)
        al.translatesAutoresizingMaskIntoConstraints = false
        al.text = "Age:"
        return al
    }()

    let genreLabel: UILabel = {
        let gl = UILabel()
        gl.textColor = UIColor(red: 214/255, green: 29/255, blue: 1, alpha:1.0)
        gl.font = UIFont(name: "Mikodacs", size: 26)
        gl.translatesAutoresizingMaskIntoConstraints = false
        gl.text = "Favorite Genre:"
        return gl
    }()
    
    let twitterLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor(red: 214/255, green: 29/255, blue: 1, alpha:1.0)
        lbl.font = UIFont(name: "Mikodacs", size : 26)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Twitter/IG:"
        return lbl
    }()
    
    
    let hometownText: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.white
        lbl.font = UIFont(name: "Mikodacs", size : 26)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .right
        return lbl
    }()
    
    let ageText: UILabel = {
        let al = UILabel()
        al.textColor = UIColor.white
        al.font = UIFont(name: "Mikodacs", size: 26)
        al.translatesAutoresizingMaskIntoConstraints = false
        al.textAlignment = .right
        return al
    }()
    
    let djNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "SudegnakNo2", size: 45)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = UIColor.white
        lbl.textAlignment = .center
        return lbl
    }()
    
    let genreText: UILabel = {
        let gl = UILabel()
        gl.textColor = UIColor.white
        gl.font = UIFont(name: "Mikodacs", size: 26)
        gl.translatesAutoresizingMaskIntoConstraints = false
        gl.textAlignment = .right
        return gl
    }()
    
    let twitterText: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.white
        lbl.font = UIFont(name: "Mikodacs", size : 26)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .right
        return lbl
    }()
    
    let dmDJButton: UIButton = {
        let lb = UIButton(type: .system)
        lb.setTitle("Hit up The DJ!", for: .normal)
        lb.setTitleColor(UIColor.white, for: .normal)
        lb.backgroundColor = UIColor(red: 214/255, green: 29/255, blue: 1, alpha:1.0)
        lb.layer.cornerRadius = 25
        lb.layer.masksToBounds = true
        lb.layer.borderWidth = 1
        lb.layer.borderColor = UIColor(red: 214/255, green: 29/255, blue: 1, alpha:1.0).cgColor
        lb.titleLabel?.font = UIFont(name: "SudegnakNo2", size: 40)
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
    
    let twitterSep: UIView = {
        let sep = UIView()
        sep.backgroundColor = UIColor(red: 214/255, green: 29/255, blue: 1, alpha:1.0)
        sep.translatesAutoresizingMaskIntoConstraints = false
        return sep
    }()
}

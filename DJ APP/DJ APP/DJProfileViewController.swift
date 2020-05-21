//
//  DJProfileViewController.swift
//  DJ APP
//
//  Created by Marquel Hendricks on 10/12/17.
//  Copyright © 2017 Marquel and Micajuine App Team. All rights reserved.
//


import UIKit
import FirebaseDatabase
import CoreData
import LGButton

class DJProfileViewController: UIViewController {
    
    var dj: DJs?
    var guestID: String?
    
    override func viewDidLoad(){
        super.viewDidLoad()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        profilePic.isUserInteractionEnabled = true
        profilePic.addGestureRecognizer(tapGestureRecognizer)
        self.view.backgroundColor = UIColor.black
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "View Full Photo", style: UIAlertActionStyle.default, handler: { action in
            self.loadUpFullView(tapGestureRec: tapGestureRecognizer)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            self.navigationController?.popViewController(animated: true)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func setupNavigationBar() {
        //Back button
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(goBackToTabbedView))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor(red: 214/255, green: 29/255, blue: 1, alpha:1.0)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        
        //Bar text
        //self.navigationItem.title = "DJ Profile"
        //self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "BebasNeue-Regular", size : 40) as Any, NSAttributedStringKey.foregroundColor: UIColor.white]
    }
    
    @objc func goBackToTabbedView() {
        self.parent?.dismiss(animated: true, completion: nil)
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
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @objc func dismissFullscreenImage(sender: UITapGestureRecognizer) {
        self.scrollView.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.isNavigationBarHidden = false
        sender.view?.removeFromSuperview()
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let name = dj?.djName {
            //print("Dj name is: \(name)")
        }
        else {
            //print("Dj was not passed through")
        }
        setupViews()
        setupNavigationBar()
    }
    
    @objc func handleDM() {
        let storyboard = UIStoryboard(name: "djProfileStoryboard", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "GuestContactView") as! GuestContactFormViewController
        controller.dj = dj
        controller.guestID = guestID
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true, completion: nil)
    }
    
    func setupViews() {
        if let name = dj?.djName, let hometown = dj?.hometown, let profileUrl = dj?.profilePicURL, let age = dj?.age, let genre = dj?.genre, let twitterHandle = dj?.twitter {
            if !(twitterHandle == "") {
                twitterText.text = "\(twitterHandle)"
            }
            else {
                twitterText.text = "--"
            }
            djNameLabel.text = "\(name)"
            profilePic.loadImageWithChachfromUrl(urlString: profileUrl)
            hometownText.text = "\(hometown)"
            ageText.text = "\(age)"
            genreText.text = "\(genre)"
        }
        else {
            //print("No DJ at setupViews")
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
        //scrollView.addSubview(cosmosView)
        
        scrollView.addSubview(dmDJButton)
        //scrollView.addSubview(reviewsButton)
        //scrollView.addSubview(headphonesLogo)
        
        //cosmosView.centerInSuperview()
        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scrollView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
        let backgroundImage: UIImageView = UIImageView(frame: view.bounds)
        backgroundImage.image = UIImage(named: "jacob-morch-272617")
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.insertSubview(backgroundImage, at: 0)
        
        backgroundImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        backgroundImage.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        //backgroundImage.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        backgroundImage.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        profilePic.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        profilePic.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 35).isActive = true
        profilePic.widthAnchor.constraint(equalToConstant: 140).isActive = true
        profilePic.heightAnchor.constraint(equalToConstant: 140).isActive = true
        
        djNameLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        djNameLabel.topAnchor.constraint(equalTo: profilePic.bottomAnchor, constant: 12).isActive = true
        djNameLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -36).isActive = true
        djNameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        //cosmosView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        //cosmosView.topAnchor.constraint(equalTo: djNameLabel.bottomAnchor, constant: 12).isActive = true
        //reviewsButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        //reviewsButton.topAnchor.constraint(equalTo: profilePic.bottomAnchor, constant: 15).isActive = true
        //reviewsButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        //reviewsButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        ageLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16).isActive = true
        ageLabel.topAnchor.constraint(equalTo: djNameLabel.bottomAnchor, constant: 12).isActive = true
        ageLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        ageLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        hometownLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16).isActive = true
        hometownLabel.topAnchor.constraint(equalTo: ageLabel.bottomAnchor, constant: 12).isActive = true
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
        
        
        
        dmDJButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        dmDJButton.topAnchor.constraint(equalTo: twitterText.bottomAnchor, constant: 30).isActive = true
        dmDJButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
    }
    
    
   /* let cosmosView: CosmosView = {
       let cv = CosmosView()
        cv.settings.filledImage = UIImage(named: "filled_star")
        cv.settings.starSize = 60.0
        cv.settings.starMargin = 10
        cv.settings.emptyBorderWidth = 0.75
        return cv
    //}()*/
    
    let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.backgroundColor = UIColor.black
        return sv
    }()
    
    let reviewsButton: UIButton = {
       let lb = UIButton()
        lb.setTitle("See DJ Reviews »", for: .normal)
        lb.setTitleColor(UIColor.white, for: .normal)
        lb.backgroundColor = UIColor.clear
        //lb.layer.cornerRadius = 25
        lb.layer.masksToBounds = true
        //lb.layer.borderWidth = 1
        //lb.layer.borderColor = UIColor(red: 214/255, green: 29/255, blue: 1, alpha:1.0).cgColor
        lb.titleLabel?.font = UIFont(name: "BebasNeue-Regular", size: 20)
        lb.addTarget(self, action: #selector(handleDM), for: .touchUpInside)
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    let star: UIImageView = {
        let img = UIImageView()
        img.layer.masksToBounds = true
        img.clipsToBounds = true
        img.layer.borderColor = UIColor.clear.cgColor
        img.image = UIImage(named: "open_star")
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
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
        lbl.font = UIFont(name: "BebasNeue-Regular", size : 26)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Hometown:"
        return lbl
    }()
    
    let ageLabel: UILabel = {
        let al = UILabel()
        al.textColor = UIColor(red: 214/255, green: 29/255, blue: 1, alpha:1.0)
        al.font = UIFont(name: "BebasNeue-Regular", size: 26)
        al.translatesAutoresizingMaskIntoConstraints = false
        al.text = "Age:"
        return al
    }()

    let genreLabel: UILabel = {
        let gl = UILabel()
        gl.textColor = UIColor(red: 214/255, green: 29/255, blue: 1, alpha:1.0)
        gl.font = UIFont(name: "BebasNeue-Regular", size: 26)
        gl.translatesAutoresizingMaskIntoConstraints = false
        gl.text = "Favorite Genre:"
        return gl
    }()
    
    let twitterLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor(red: 214/255, green: 29/255, blue: 1, alpha:1.0)
        lbl.font = UIFont(name: "BebasNeue-Regular", size : 26)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Social Media:"
        lbl.adjustsFontSizeToFitWidth = true
        return lbl
    }()
    
    
    let hometownText: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.white
        lbl.font = UIFont(name: "BebasNeue-Regular", size : 26)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .right
        return lbl
    }()
    
    let ageText: UILabel = {
        let al = UILabel()
        al.textColor = UIColor.white
        al.font = UIFont(name: "BebasNeue-Regular", size: 26)
        al.translatesAutoresizingMaskIntoConstraints = false
        al.textAlignment = .right
        return al
    }()
    
    let djNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "BebasNeue-Regular", size: 45)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = UIColor.white
        lbl.textAlignment = .center
        return lbl
    }()
    
    let genreText: UILabel = {
        let gl = UILabel()
        gl.textColor = UIColor.white
        gl.font = UIFont(name: "BebasNeue-Regular", size: 26)
        gl.translatesAutoresizingMaskIntoConstraints = false
        gl.textAlignment = .right
        return gl
    }()
    
    let twitterText: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.gray
        lbl.font = UIFont(name: "BebasNeue-Regular", size : 26)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .right
        return lbl
    }()
    
    let dmDJButton: LGButton = {
        let btn = LGButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.titleString = "Hit up this DJ!"
        btn.titleFontName = "BebasNeue-Regular"
        btn.titleFontSize = 20
        btn.titleColor = UIColor.black
        btn.addTarget(self, action: #selector(handleDM), for: .touchUpInside)
        btn.fullyRoundedCorners = true
        btn.gradientStartColor = UIColor(red: 214/255, green: 29/255, blue: 1, alpha:1.0)
        btn.gradientEndColor = UIColor(red: 214/255, green: 29/255, blue: 1, alpha:1.0)
        return btn
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

extension UIView {
    
    func fadeIn(_ duration: TimeInterval = 0.5, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: completion)  }
    
    func fadeOut(_ duration: TimeInterval = 0.5, delay: TimeInterval = 1.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.alpha = 0.3
        }, completion: completion)
    }
}

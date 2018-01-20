//
//  DJProfileViewController.swift
//  DJ APP
//
//  Created by Marquel Hendricks on 10/12/17.
//  Copyright © 2017 Marquel and Micajuine App Team. All rights reserved.
//

import UIKit
import Firebase

class DJPRofileViewController: UIViewController {
    
    var users = [UserDJ]()
    var dj: UserDJ?
    var guestID: String?
    
    @IBOutlet weak var hometownLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var twitterLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var djNameLabel: UILabel!
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var imageForFullViewing: UIImageView!
    
    @IBAction func recognizerTapped(_ sender: UITapGestureRecognizer) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "View Full Image", style: .default) { action in
            print("Fired off function")
            self.tappedActions(sender)
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { action in
            self.popAlertOff()
        })
        
        present(alert, animated: true)
    }
    
    func popAlertOff(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func tappedActions(_ sender: UITapGestureRecognizer){
        let tappedImage = sender.view as! UIImageView
        let newImageView = UIImageView(image: tappedImage.image)
        newImageView.frame = UIScreen.main.bounds
        newImageView.backgroundColor = .black
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        newImageView.addGestureRecognizer(tap)
        self.view.addSubview(newImageView)
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        sender.view?.removeFromSuperview()
    }

    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func messageButtonPressed(_ sender: Any) {
        //handleDM()
        let storyboard = UIStoryboard(name: "djProfileStoryboard", bundle: nil)
        let contactForm = storyboard.instantiateViewController(withIdentifier: "GuestContactView") as! GuestContactFormViewController
        contactForm.dj = dj
        contactForm.guestID = guestID
        self.present(contactForm, animated: true, completion: nil)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        messageButton.layer.cornerRadius = 27
        backButton.layer.cornerRadius = 27
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
    
    
    
    //Present new collectionview controller as rootview of navigation controller from tabbar controller
    func handleDM() {
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

    }
    
    func setupViews() {
        placeDJNameInLabel()
        setupDJInfo()
        placeDJImageInView()
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
        pp.layer.cornerRadius = 30
        pp.layer.masksToBounds = true
        pp.clipsToBounds = true
        pp.layer.borderWidth = 1.0
        pp.layer.borderColor = UIColor.black.cgColor
        pp.translatesAutoresizingMaskIntoConstraints = false
        return pp
    }()
    
    func placeDJNameInLabel(){
        if let djName = dj?.djName {
            djNameLabel.font = UIFont(name: "SudegnakNo2", size: 60)
            djNameLabel.text = djName
        }
        else{
            print("No DJ Name")
        }
    }
    
    func setupDJInfo(){
        if let hometown = dj?.hometown, let profileUrl = dj?.profilePicURL, let age = dj?.age, let genre = dj?.genre, let twitter = dj?.twitter{
            hometownLabel.text = hometown
            ageLabel.text = "\(age)"
            genreLabel.text = genre
            twitterLabel.adjustsFontSizeToFitWidth = true
            twitterLabel.text = twitter
        }
        else{
            print("No DJ Info")
        }
    }
    
    func placeDJImageInView(){
        if let profileURL = dj?.profilePicURL{
            profilePic.loadImageWithChachfromUrl(urlString: profileURL)
            profileImage.contentMode = .scaleAspectFill
            profileImage.layer.cornerRadius = 30
            profileImage.layer.masksToBounds = true
            profileImage.layer.borderWidth = 1.5
            profileImage.layer.borderColor = UIColor(red: 214/255, green: 29/255, blue: 1, alpha:0.9).cgColor
            profileImage.clipsToBounds = true
            profileImage.translatesAutoresizingMaskIntoConstraints = false
            profileImage.image = profilePic.image
        }
        else{
            print("No Image to place")
        }
    }
}





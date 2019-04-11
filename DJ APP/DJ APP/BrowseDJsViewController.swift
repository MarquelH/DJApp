//
//  BrowseDJsViewController.swift
//  DJ APP
//
//  Created by Marquel Hendricks on 2/22/19.
//  Copyright © 2019 Marquel and Micajuine App Team. All rights reserved.
//

import UIKit
import CardsLayout
import Firebase
import CoreLocation

class BrowseDJsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var myCollectionView: UICollectionView!
    @IBOutlet weak var djSearchBar: UISearchBar!
    
    var users = [UserDJ]()
    var events = [Event]()
    var djNames = [String]()
    var searchedDJ = [String]()
    let cellId = "cellId"
    var guestID: String?
    var usersSnapshot: [String: AnyObject]?
    var eventsToBeDeleted: [String] = []
    var songlistsToBeDeleted: [String] = []
    var currentUserLocation: CLLocation?
    var searching = false
    
    
    lazy var refreshController: UIRefreshControl = {
        let rc = UIRefreshControl()
        //rc.addTarget(self, action: #selector(self.fetchDjs), for: UIControlEvents.valueChanged)
        rc.tintColor = UIColor.blue.withAlphaComponent(0.75)
        return rc
    }()
    
    let logoInLogin: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "headphones")
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    let headphonesImage: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "headphonesSmall")
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    let djProfileViewController = DJPRofileViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        addLogo()
        djSearchBar.delegate = self
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
        myCollectionView.register(DJCollectionViewCell.self, forCellWithReuseIdentifier: "DJCollectionViewCell")
        //myCollectionView.addSubview(headphonesImage)
        myCollectionView.dataSource = self
        myCollectionView.delegate = self
        myCollectionView.isPagingEnabled = true
        myCollectionView.showsHorizontalScrollIndicator = false
        myCollectionView.refreshControl = refreshController
        fetchDjs()
    }
    
    func addLogo() {
        self.view.addSubview(logoInLogin)
        logoInLogin.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 5).isActive = true
        logoInLogin.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -100).isActive = true
        logoInLogin.heightAnchor.constraint(equalToConstant: 60).isActive = true
        logoInLogin.widthAnchor.constraint(equalToConstant: 125).isActive = true
    }
    
    func setupNavBar() {
        navigationItem.title = "All DJs"
        //self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        //self.navigationItem.leftBarButtonItem?.tintColor = UIColor(red: 214/255, green: 29/255, blue: 1, alpha:1.0)
        //navigationItem.leftBarButtonItem?.tintColor = UIColor(red: 214/255, green: 29/255, blue: 1, alpha:1.0)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "SudegnakNo2", size : 35) as Any, NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.barTintColor = UIColor.black
    }
    
    @objc func fetchDjs() {
        //So that table view doesn't load duplicates
        self.users.removeAll()
        self.refreshController.beginRefreshing()
        
        Database.database().reference().child("users").observeSingleEvent(of: .value, with: {(snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                self.usersSnapshot = dictionary
                //self.fetchEvents()
                
                for (key, value) in dictionary{
                    print("HERE IS VALUE")
                    //print(value)
                    if let djID = value["djName"] as? String {
                        //print("ADDING TO LIST")
                        print(djID)
                        self.addDJToList(djID: djID)
                    }
                    else {
                        print("Got no value")
                    }
                }
                
            }
            else {
                print("No parse data")
            }
            
        }, withCancel: nil)
        self.refreshController.endRefreshing()
    }
    
    func addDJToList(djID: String) {
        guard let dictionary = usersSnapshot else {
            print("userSnapshot is empty")
            return
        }
        
        for (key,value) in dictionary {
            let comparableName = value["djName"] as! String
            if comparableName == djID {
                print("DJ Found in snapshot, going to add them to the list. ")
                if let name = value["djName"] as? String, let age = value["age"] as? Int, let currentLocation = value["currentLocation"] as? String, let email = value["email"] as? String, let twitter = value["twitterOrInstagram"] as? String, let genre = value["genre"] as? String, let hometown = value["hometown"] as? String, let validated =  value["validated"] as? Bool, let profilePicURL = value["profilePicURL"] as? String{
                    
                    let dj = UserDJ(age: age, currentLocation: currentLocation, djName: name, email: email, genre: genre, hometown: hometown, validated: validated, profilePicURL: profilePicURL, uid: key, twitter: twitter)
                    
                    print("ADDING A DJ")
                    self.users.append(dj)
                    
                }
                else{
                    print("couldn't find DJ's")
                }
            }
            
        }
        myCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 414, height: 700)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DJCollectionViewCell", for: indexPath) as! DJCollectionViewCell
        cell.DJNameLabel.text = nil
        //djNames = []
        cell.layer.cornerRadius = 10.0
        cell.layer.borderColor = UIColor.white.cgColor
        
        let dj = users[indexPath.row]
        
        if searching {
            cell.DJNameLabel.text = searchedDJ[indexPath.row]
        } else {
            cell.DJNameLabel.text = dj.djName!
            cell.DJNameLabel.text = dj.djName!
            djNames.append(dj.djName!)
            
            if let profileUrl = dj.profilePicURL {
                cell.profileImageView.loadImageWithChachfromUrl(urlString: profileUrl)
            }
            
            cell.genresLabel.text = dj.genre
        }
        
        if (indexPath.row % 2 == 0){
        cell.backgroundColor = UIColor.gray
        }
        else{
            cell.backgroundColor = UIColor.white
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searching {
            return searchedDJ.count
        } else {
            return users.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dj = users[indexPath.row]
        djProfileViewController.dj = dj
        djProfileViewController.guestID = guestID
        let djProfileNavController = UINavigationController()
        djProfileNavController.viewControllers = [djProfileViewController]
        present(djProfileNavController, animated: true, completion: nil)
    }
}

extension BrowseDJsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchedDJ = djNames.filter({$0.lowercased().prefix(searchText.count) == searchText.lowercased()})
        //   searchedCountry = countryNameArr.filter({$0.lowercased().prefix(searchText.count) == searchText.lowercased()})
        searching = true
        myCollectionView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        djSearchBar.text = ""
        myCollectionView.reloadData()
    }
}
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

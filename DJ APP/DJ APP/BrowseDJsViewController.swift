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
import CoreData
import StoreKit
import NVActivityIndicatorView

class BrowseDJsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIPopoverPresentationControllerDelegate, NVActivityIndicatorViewable {
    
    @IBOutlet weak var myCollectionView: UICollectionView!
    @IBOutlet weak var djSearchBar: UISearchBar!
    @IBOutlet weak var totalDJsLabel: UILabel!
    
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var users = [DJs]()
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
    
    let djProfileViewController = DJProfileViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        totalDJsLabel.font = UIFont(name: "BebasNeue-Regular", size: 30)
        addLogo()
        if (UserDefaults.standard.integer(forKey: "launchCount") == 30){
            //Asking for review on 10th launch.
            SKStoreReviewController.requestReview()
        }
        fetchDjs()
        //djSearchBar.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func deleteDuplicateObjects() {
        var arr = [String]()
        for dj in users {
            if let djName = dj.djName {
                if arr.contains(djName) {
                    //print("DELETING DUPLICATE OBJECT")
                    context.delete(dj)
                } else {
                    arr.append(djName)
                }
            }
        }
    }
    
    func updateVisitingCounter() {
        
        var counter = UserDefaults.standard.integer(forKey: "browseDJVisitCount")
        counter += 1
        UserDefaults.standard.set(counter, forKey: "browseDJVisitCount")
        
    }
    
    
    @IBAction func searchCllicked(_ sender: Any) {
        
    }
    
    @objc func barButtonItemTapped() {
        let storyboard = UIStoryboard(name: "breakOffStoryboard", bundle: nil)
        let VC = storyboard.instantiateViewController(withIdentifier: "searchPopover") as! SearchPopoverViewController
        VC.users = self.users
        VC.guestID = guestID
        VC.preferredContentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/2)
        let navController = UINavigationController(rootViewController: VC)
        navController.modalPresentationStyle = UIModalPresentationStyle.popover
        let popover = navController.popoverPresentationController
        popover?.delegate = self
        popover?.barButtonItem = self.navigationItem.rightBarButtonItem
        self.present(navController, animated: true, completion: nil)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if users.count == 0 {
            fetchDjs()
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        myCollectionView.register(DJCollectionViewCell.self, forCellWithReuseIdentifier: "DJCollectionViewCell")
        myCollectionView.dataSource = self
        myCollectionView.delegate = self
        myCollectionView.isPagingEnabled = true
        myCollectionView.showsHorizontalScrollIndicator = false
        myCollectionView.refreshControl = refreshController
        /*do {
            users = try context.fetch(DJs.fetchRequest())
        } catch let error as NSError {
            //print("Could not fetch. \(error)")
        }*/
        /*var counter = UserDefaults.standard.integer(forKey: "browseDJVisitCount")
        if (counter == 1) || ((counter % 5) == 0) {
            fetchDjs()
            counter += 1
            UserDefaults.standard.set(counter, forKey: "browseDJVisitCount")
        } else {
            do {
                users = try context.fetch(DJs.fetchRequest())
            } catch let error as NSError {
                //print("Could not fetch. \(error)")
            }
        }*/
        //deleteDuplicateObjects()
        
        /*if oldUserCount < users.count || users.count == 0 {
            fetchDjs()
            self.appDelegate.saveContext()
            myCollectionView.reloadData()
        }*/
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //users = []
    }
    
    func addLogo() {
        self.view.addSubview(logoInLogin)
        logoInLogin.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 5).isActive = true
        //logoInLogin.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -75).isActive = true
        logoInLogin.topAnchor.constraint(equalTo: myCollectionView.bottomAnchor, constant:15).isActive = true
        logoInLogin.heightAnchor.constraint(equalToConstant: 60).isActive = true
        logoInLogin.widthAnchor.constraint(equalToConstant: 125).isActive = true
    }
    
    func setupNavBar() {
        navigationItem.title = "Browse DJs"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor(red: 214/255, green: 29/255, blue: 1, alpha:1.0)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "BebasNeue-Regular", size : 40) as Any, NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(barButtonItemTapped))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 214/255, green: 29/255, blue: 1, alpha:1.0)
    }
    
    @objc func handleLogout() {
        do {
            try Auth.auth().signOut()
        }
        catch let error as NSError {
            //print("Error with signing out of firebase: \(error.localizedDescription)")
        }
        dismiss(animated: true, completion: nil)
        
    }
    
    @objc func fetchDjs() {
        startAnimating()
        
        if let dictionary = self.usersSnapshot as? [String: AnyObject] {
            for (_, value) in dictionary {
                //print("HERE IS VALUE")
                ////print(value)
                if let djID = value["djName"] as? String {
                    ////print("ADDING TO LIST")
                    //print(djID)
                    self.addDJToList(djID: djID)
                    self.users.sort {
                        $0.djName! < $1.djName!
                    }
                    stopAnimating()
                    self.myCollectionView.reloadData()
                }
                else {
                    stopAnimating()
                    //print("Got no value")
                }
            }
        }
        
        //var arr = [String]()
        
            /*Database.database().reference().child("users").observeSingleEvent(of: .value, with: {(snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    self.usersSnapshot = dictionary
                    //self.fetchEvents()
                    
                    for (key, value) in dictionary {
                        //print("HERE IS VALUE")
                        ////print(value)
                        if let djID = value["djName"] as? String {
                            ////print("ADDING TO LIST")
                            //print(djID)
                            if arr.contains(djID) {
                                //print("FOUND DUPLICATE")
                            } else {
                                arr.append(djID)
                            }
                            self.addDJToList(djID: djID)
                        }
                        else {
                            //print("Got no value")
                        }
                    }
                    
                }
                else {
                    //print("No parse data")
                }
                self.users.sort {
                    $0.djName! < $1.djName!
                }
                self.myCollectionView.reloadData()
            }, withCancel: nil)
        self.refreshController.endRefreshing()*/
    }
    
    func addDJToList(djID: String) {
        guard let dictionary = usersSnapshot else {
            //print("userSnapshot is empty")
            return
        }
        
        
        for (key,value) in dictionary {
            let comparableName = value["djName"] as! String
            if comparableName == djID {
                //print("DJ Found in snapshot, going to add them to the list. ")
                if let name = value["djName"] as? String, let age = value["age"] as? Int, let currentLocation = value["currentLocation"] as? String, let email = value["email"] as? String, let twitter = value["twitterOrInstagram"] as? String, let genre = value["genre"] as? String, let hometown = value["hometown"] as? String, let validated =  value["validated"] as? Bool, let profilePicURL = value["profilePicURL"] as? String {
                    
                    let newDJ = DJs(entity: DJs.entity(), insertInto: self.context)
                    newDJ.djName = name
                    newDJ.age = age
                    newDJ.email = email
                    newDJ.genre = genre
                    newDJ.hometown = hometown
                    newDJ.profilePicURL = profilePicURL
                    newDJ.uid = key
                    newDJ.twitter = twitter
                    //appDelegate.saveContext()
                    /*let dj = UserDJ(age: age, currentLocation: currentLocation, djName: name, email: email, genre: genre, hometown: hometown, validated: validated, profilePicURL: profilePicURL, uid: key, twitter: twitter)*/
                    self.users.append(newDJ)
                    
                }
                else{
                    //print("couldn't find DJ's")
                }
            }
            
        }
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
            //print("SETTING DJ NAME TO : \(dj.djName!)")
            cell.DJNameLabel.text = dj.djName!
            
            if !djNames.contains(dj.djName!) {
                djNames.append(dj.djName!)
            }
            
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
            if users.count != 0 {
                totalDJsLabel.text = "Total DJs: \(users.count)"
            }
            //print("WE HAVE \(users.count) DJs")
            return users.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dj = users[indexPath.row]
        djProfileViewController.dj = dj
        djProfileViewController.guestID = guestID
        let djProfileNavController = UINavigationController()
        djProfileNavController.viewControllers = [djProfileViewController]
        djProfileNavController.modalPresentationStyle = .fullScreen
        present(djProfileNavController, animated: true, completion: nil)
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

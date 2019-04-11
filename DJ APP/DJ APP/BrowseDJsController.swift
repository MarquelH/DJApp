//
//  DJTableViewController.swift
//  DJ APP
//
//  Created by arturo ho on 8/24/17.
//  Copyright © 2017 Marquel and Micajuine App Team. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation
import CardsLayout

class BrowseDJsController: UICollectionViewController {
    
    
    var users = [UserDJ]()
    var events = [Event]()
    let cellId = "cellId"
    var guestID: String?
    var usersSnapshot: [String: AnyObject]?
    var eventsToBeDeleted: [String] = []
    var songlistsToBeDeleted: [String] = []
    var currentUserLocation: CLLocation?
    
    lazy var refreshController: UIRefreshControl = {
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(self.fetchDjs), for: UIControlEvents.valueChanged)
        rc.tintColor = UIColor.blue.withAlphaComponent(0.75)
        return rc
    }()
    
    let noDJLabel: UILabel = {
        let nrl = UILabel()
        nrl.translatesAutoresizingMaskIntoConstraints = false
        nrl.textColor = UIColor(red: 214/255, green: 29/255, blue: 1, alpha:0.9)
        nrl.text = "No DJs are currently live within 1 mile of you.\nPlease try again later!"
        nrl.textAlignment = .center
        nrl.font = UIFont(name: "Mikodacs", size : 20)
        nrl.lineBreakMode = .byWordWrapping
        nrl.numberOfLines = 0
        return nrl
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    let layout: UICollectionViewLayout = CardsCollectionViewLayout.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        //Register cells
        self.collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        //self.view.addSubview(collectionView)
        self.collectionView?.register(CardsCollectionViewCell.self, forCellWithReuseIdentifier: "cardsCollectionView")
        self.collectionView?.dataSource = self
        self.collectionView?.delegate = self
        //Set refresh controller
        self.collectionView?.refreshControl = refreshController
        fetchDjs()
        self.collectionView?.reloadData()
    }
    
    func setupCollectionView() {
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
                    if let djID = value["DjID"] as? String {
                        self.addDJToList(djID: djID)
                        DispatchQueue.main.sync {
                            self.collectionView!.reloadData()
                        }
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
    
    
    func fetchEvents() {
        self.events.removeAll()
        Database.database().reference().child("Events").observeSingleEvent(of: .value, with: {(snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                for (key,value) in dictionary {
                    
                    if let djID  = value["DjID"] as? String, let endTime = value["EndDateAndTime"] as? String, let startTime = value["StartDateAndTime"] as? String, let eventID = value["id"] as? String, let location = value["location"] as? String, let djName = value["DJ Name"] as? String, let eventLat = value["Latitude Coordinates"] as? String, let eventLong = value["Longitude Coordinates"] as? String {
                        
                        let currDateTime = Date()
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "M/dd/yy, h:mm a"
                        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                        
                        guard let sd = dateFormatter.date(from: startTime), let ed = dateFormatter.date(from: endTime) else {
                            print("Failed converting the the dates")
                            return
                        }
                        
                        self.songlistsToBeDeleted.append(djID)
                        
                        
                        //Check if the current time is within the start and end times
                        //Add to the events list if it is.
                        if ((sd.timeIntervalSince1970) <= currDateTime.timeIntervalSince1970 &&
                            (ed.timeIntervalSince1970) >= currDateTime.timeIntervalSince1970) {
                            
                            let newEvent = Event(djID: djID, location: location, startTime: sd, endTime: ed, eventID: eventID, djName: djName)
                            print("Added to the list: \(eventID) at location: \(location)")
                            self.events.append(newEvent)
                            
                            //Add the DJ to the DJ List
                            self.addDJToList(djID: djID)
                            
                            //remove from the songlists to be deleted array because it is a valid songlist
                            self.songlistsToBeDeleted.removeLast()
                            
                            DispatchQueue.main.async {
                                self.collectionView!.reloadData()
                            }
                        }
                        else if ((ed.timeIntervalSince1970) <= currDateTime.timeIntervalSince1970) {
                            //Add key to eventsToBeDeleted
                            self.eventsToBeDeleted.append(key)
                        }
                    }
                    else{
                        print("Couldn't find information about the event")
                    }
                    
                }
                
            }
            else {
                print("Problem parsing events into [String: AnyObjet]")
            }
            self.refreshController.endRefreshing()
        }, withCancel: nil)
    }
    
    func addDJToList(djID: String) {
        guard let dictionary = usersSnapshot else {
            print("userSnapshot is empty")
            return
        }
        
        for (key,value) in dictionary {
            
            if key == djID {
                print("DJ Found in snapshot, going to add them to the list. ")
                if let name = value["djName"] as? String, let age = value["age"] as? Int, let currentLocation = value["currentLocation"] as? String, let email = value["email"] as? String, let twitter = value["twitterOrInstagram"] as? String, let genre = value["genre"] as? String, let hometown = value["hometown"] as? String, let validated =  value["validated"] as? Bool, let profilePicURL = value["profilePicURL"] as? String{
                    
                    let dj = UserDJ(age: age, currentLocation: currentLocation, djName: name, email: email, genre: genre, hometown: hometown, validated: validated, profilePicURL: profilePicURL, uid: key, twitter: twitter)
                    
                    
                    self.users.append(dj)
                    
                }
                else{
                    print("couldn't find DJ's")
                }
            }
            
        }
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return users.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! DJCell
        
        
        let dj = users[indexPath.row]
        cell.textLabel?.text = dj.djName
        
        if let location = events[indexPath.row].location {
            cell.detailTextLabel?.adjustsFontSizeToFitWidth = true
            cell.detailTextLabel?.text = "Playing at: " +  "\(String(describing: location))"
        }
        else {
            cell.detailTextLabel?.text = ""
        }
        
        
        
        //Set the image view
        if let profileUrl = dj.profilePicURL {
            cell.profileImageView.loadImageWithChachfromUrl(urlString: profileUrl)
        }
        
        
        //set color
        if (indexPath.row % 3 == 0){
            //cell.backgroundColor = UIColor(red: 214/255, green: 29/255, blue: 1, alpha:1.0)
            cell.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        }
        else if (indexPath.row % 3 == 1){
            //cell.backgroundColor = UIColor(red: 214/255, green: 29/255, blue: 1, alpha:0.5)
            cell.backgroundColor = UIColor.lightGray.withAlphaComponent(0.9)
        }
        else{
            //cell.backgroundColor = UIColor(red: 214/255, green: 29/255, blue: 1, alpha:0.25)
            cell.backgroundColor = UIColor(red: 214/255, green: 29/255, blue: 1, alpha:0.9)
        }
        //return cell
        //return UICollectionViewCell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let customTabBarController = CustomTabBarController()
        
        //Send selected DJ and guest id to new views
        if let workingID = self.guestID {
            customTabBarController.setDJsAndGuestID(dj: users[indexPath.row], id: workingID)
        }
        
        //Insert views into navigation controller
        
        customTabBarController.selectedIndex = 1
        present(customTabBarController, animated: true, completion: nil)
    }
    
    func setupNavBar() {
        navigationItem.title = "Live DJs Near You"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor(red: 214/255, green: 29/255, blue: 1, alpha:1.0)
        navigationItem.leftBarButtonItem?.tintColor = UIColor(red: 214/255, green: 29/255, blue: 1, alpha:1.0)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "SudegnakNo2", size : 35) as Any, NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.barTintColor = UIColor.black
    }
    
    @objc func handleLogout() {
        do {
            try Auth.auth().signOut()
        }
        catch let error as NSError {
            print("Error with signing out of firebase: \(error.localizedDescription)")
        }
        dismiss(animated: true, completion: nil)
        
    }
    
    
}





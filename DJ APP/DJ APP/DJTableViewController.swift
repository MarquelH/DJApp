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

class DJTableViewController: UITableViewController {

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
        nrl.text = "No DJs are currently live near you.\nPlease try again later!"
        nrl.textAlignment = .center
        nrl.font = UIFont(name: "Mikodacs", size : 20)
        nrl.lineBreakMode = .byWordWrapping
        nrl.numberOfLines = 0
        return nrl
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
        fetchDjs()
    }
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupTableView()
        self.tableView.reloadData()
    }

    func setupTableView() {
        //Register cells and remove seperators
        self.tableView.register(DJCell.self, forCellReuseIdentifier: cellId)
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = UIColor.black
        //Set refresh controller
        self.tableView.refreshControl = refreshController
        
        self.tableView.addSubview(noDJLabel)
        noDJLabel.centerXAnchor.constraint(equalTo: self.tableView.centerXAnchor).isActive = true
        noDJLabel.centerYAnchor.constraint(equalTo: self.tableView.centerYAnchor).isActive = true
        noDJLabel.widthAnchor.constraint(equalTo: self.tableView.widthAnchor).isActive = true
        noDJLabel.heightAnchor.constraint(equalTo: self.tableView.heightAnchor).isActive = true
    }
    
    @objc func fetchDjs() {
        //So that table view doesn't load duplicates
        self.users.removeAll()
        //self.events.removeAll()
        
        Database.database().reference().child("users").observeSingleEvent(of: .value, with: {(snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                self.usersSnapshot = dictionary
                self.fetchEvents()
            }
            
        }, withCancel: nil)
    }
    
    
    func fetchEvents() {
        self.events.removeAll()
        Database.database().reference().child("Events").observeSingleEvent(of: .value, with: {(snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                for (key,value) in dictionary {
                    
                    if let djID  = value["DjID"] as? String, let endTime = value["EndDateAndTime"] as? String, let startTime = value["StartDateAndTime"] as? String, let eventID = value["id"] as? String, let location = value["location"] as? String, let djName = value["DJ Name"] as? String, let eventLat = value["Latitude Coordinates"] as? String, let eventLong = value["Longitude Coordinates"] as? String {
                        let realLat = Double(eventLat)
                        let realLong = Double(eventLong)
                        let locationIwant = CLLocation(latitude: realLat!, longitude: realLong!)
                        
                        let theDistance = locationIwant.distance(from: self.currentUserLocation!)
                        if theDistance <= 1609.34 { //1609.34 is about 1 mile in meters.

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
                                self.tableView.reloadData()
                            }
                        }
                        else if ((ed.timeIntervalSince1970) <= currDateTime.timeIntervalSince1970) {
                            //Add key to eventsToBeDeleted
                            self.eventsToBeDeleted.append(key)
                        }
                    }
                        else{
                            print("User is too far from location!")
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
            self.removePastEventsAndSonglists()
        }, withCancel: nil)
    }
    
    func removePastEventsAndSonglists() {
        //Remove past events
        let ref = Database.database().reference().child("Events")
        for eventID in eventsToBeDeleted {
            ref.child(eventID).setValue(nil)
        }
        
        //Remove past song lists
        let ref2 = Database.database().reference().child("SongList")
        for djID in songlistsToBeDeleted {
            ref2.child(djID).setValue(nil)
        }
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
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if users.count == 0{
            noDJLabel.isHidden = false
        }
        else{
            noDJLabel.isHidden = true
        }
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! DJCell
        
        
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
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let customTabBarController = CustomTabBarController()
    
        //Send selected DJ and guest id to new views
        if let workingID = self.guestID {
            customTabBarController.setDJsAndGuestID(dj: users[indexPath.row], id: workingID)
        }
        
        //Insert views into navigation controller
        
        customTabBarController.selectedIndex = 1
        present(customTabBarController, animated: true, completion: nil)
        
        

        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {() in
            tableView.deselectRow(at: indexPath, animated: false)
        })
    
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





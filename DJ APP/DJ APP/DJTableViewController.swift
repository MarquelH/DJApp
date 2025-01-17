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

    var users = [DJs]()
    var events = [Event]()
    let cellId = "cellId"
    var guestID: String?
    var usersSnapshot: [String: AnyObject]?
    var eventsToBeDeleted: [String] = []
    var songlistsToBeDeleted: [String] = []
    var currentUserLocation: CLLocation?
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
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
        nrl.text = "Here, DJs which are currently live on Go.DJ will automatically appear\n\nYou just select a DJ in order to request songs during their live sessions."
        nrl.textAlignment = .center
        nrl.font = UIFont(name: "BebasNeue-Regular", size : 28)
        nrl.lineBreakMode = .byWordWrapping
        nrl.numberOfLines = 0
        return nrl
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        //TODO: Turn location restriction logic back on
        self.events.removeAll()
        Database.database().reference().child("Events").observeSingleEvent(of: .value, with: {(snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                for (key,value) in dictionary {
                    
                    if let djID  = value["DjID"] as? String, let endTime = value["EndDateAndTime"] as? String, let startTime = value["StartDateAndTime"] as? String, let eventID = value["id"] as? String, let location = value["location"] as? String, let djName = value["DJ Name"] as? String, let eventLat = value["Latitude Coordinates"] as? String, let eventLong = value["Longitude Coordinates"] as? String {
                        
                        //let realLat = Double(eventLat)
                        //let realLong = Double(eventLong)
                        //let locationIwant = CLLocation(latitude: realLat!, longitude: realLong!)
                        
                        //let status = CLLocationManager.authorizationStatus()
                        //while status != CLAuthorizationStatus.authorizedAlways || sta
                        //let settingsURL = NSURL(string: UIApplicationOpenSettingsURLString)
                        //Check if location has been allowed here.
                    
                        /*guard let curentUserLoc = self.currentUserLocation else {
                            let alert = UIAlertController(title: "User location not enabled!", message: "Location must be enabled so we can determine whether you are eligible to request!", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Screw you", style: UIAlertActionStyle.destructive, handler: { action in
                                let mapview = MapViewController()
                                self.tabBarController?.selectedIndex = 0
                            }))
                            alert.addAction(UIAlertAction(title: "Go to Settings", style: UIAlertActionStyle.default, handler: { action in
                                if UIApplication.shared.canOpenURL(settingsURL as! URL) {
                                    UIApplication.shared.open(settingsURL as! URL, completionHandler: { (success) in
                                        //print("Settings opened: \(success)") // Prints true
                                    })
                                }
                            }))
                            self.present(alert, animated: true, completion: nil)
                            return
                        }*/
                        
                        ///let theDistance = locationIwant.distance(from: self.currentUserLocation!)
                        //if theDistance <= 1609.34 { //1609.34 is about 1 mile in meters.

                        let currDateTime = Date()
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "M/dd/yy, h:mm a"
                        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                            
                        guard let sd = dateFormatter.date(from: startTime), let ed = dateFormatter.date(from: endTime) else {
                            //print("Failed converting the the dates")
                            return
                        }
                        
                        self.songlistsToBeDeleted.append(djID)
                        
                        
                        //Check if the current time is within the start and end times
                        //Add to the events list if it is.
                        if ((sd.timeIntervalSince1970) <= currDateTime.timeIntervalSince1970 &&
                            (ed.timeIntervalSince1970) >= currDateTime.timeIntervalSince1970) {
                            
                            let newEvent = Event(djID: djID, location: location, startTime: sd, endTime: ed, eventID: eventID, djName: djName)
                            //print("Added to the list: \(eventID) at location: \(location)")
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
                    //}
                        /*else{
                            //print("User is too far from location!")
                        }*/
                    }
                    else{
                        //print("Couldn't find information about the event")
                    }
                    
                }
                
            }
            else {
                //print("Problem parsing events into [String: AnyObjet]")
            }
            self.refreshController.endRefreshing()
        }, withCancel: nil)
    }
    
    func addDJToList(djID: String) {
        guard let dictionary = usersSnapshot else {
            //print("userSnapshot is empty")
            return
        }
        
        for (key,value) in dictionary {
            
            if key == djID {
                //print("DJ Found in snapshot, going to add them to the list. ")
                if let name = value["djName"] as? String, let age = value["age"] as? Int, let currentLocation = value["currentLocation"] as? String, let email = value["email"] as? String, let twitter = value["twitterOrInstagram"] as? String, let genre = value["genre"] as? String, let hometown = value["hometown"] as? String, let validated =  value["validated"] as? Bool, let profilePicURL = value["profilePicURL"] as? String{
                    
                    //let dj = UserDJ(age: age, currentLocation: currentLocation, djName: name, email: email, genre: genre, hometown: hometown, validated: validated, profilePicURL: profilePicURL, uid: key, twitter: twitter)
                    let newDJ = DJs(entity: DJs.entity(), insertInto: self.context)
                    newDJ.djName = name
                    newDJ.age = age
                    newDJ.email = email
                    newDJ.genre = genre
                    newDJ.hometown = hometown
                    newDJ.profilePicURL = profilePicURL
                    newDJ.uid = key
                    newDJ.twitter = twitter
                    
                    self.users.append(newDJ)
                    
                }
                else{
                    //print("couldn't find DJ's")
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
        //print(dj.djName)
        
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
        customTabBarController.modalPresentationStyle = .fullScreen
        present(customTabBarController, animated: true, completion: nil)
        
        

        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {() in
            tableView.deselectRow(at: indexPath, animated: false)
        })
    
    }

    func setupNavBar() {
        navigationItem.title = "Live DJs"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor(red: 214/255, green: 29/255, blue: 1, alpha:1.0)
        navigationItem.leftBarButtonItem?.tintColor = UIColor(red: 214/255, green: 29/255, blue: 1, alpha:1.0)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "BebasNeue-Regular", size : 35) as Any, NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.barTintColor = UIColor.black
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

   
}





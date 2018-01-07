//
//  DJTableViewController.swift
//  DJ APP
//
//  Created by arturo ho on 8/24/17.
//  Copyright © 2017 Marquel and Micajuine App Team. All rights reserved.
//

import UIKit
import Firebase

class DJTableViewController: UITableViewController {

    var users = [UserDJ]()
    var events = [Event]()
    let cellId = "cellId"
    var guestID: String?
    var usersSnapshot: [String: AnyObject]?
    
    lazy var refreshController: UIRefreshControl = {
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(self.fetchDjs), for: UIControlEvents.valueChanged)
        rc.tintColor = UIColor.blue.withAlphaComponent(0.75)
        return rc
    }()
    
    let noDJLabel: UILabel = {
        let nrl = UILabel()
        nrl.translatesAutoresizingMaskIntoConstraints = false
        nrl.textColor = UIColor.blue
        nrl.text = "No DJs are playing right now\nCheck again later"
        nrl.textAlignment = .center
        nrl.font = UIFont.boldSystemFont(ofSize: 20)
        nrl.lineBreakMode = .byWordWrapping
        nrl.numberOfLines = 0
        return nrl
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .default
        noDJLabel.isHidden = true
        fetchDjs()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        displayLabel()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
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
        
        //let backgroundImage: UIImageView = UIImageView(frame: view.bounds)
       // backgroundImage.image = UIImage(named: "headphonesImage")
        //backgroundImage.contentMode = .scaleAspectFill
        
        //view.insertSubview(backgroundImage, at: 0)
        //self.tableView.backgroundView = backgroundImage
        self.tableView.backgroundColor = UIColor.black
        //Set refresh controller
        self.tableView.refreshControl = refreshController
        
        self.tableView.addSubview(noDJLabel)
        noDJLabel.centerXAnchor.constraint(equalTo: self.tableView.centerXAnchor).isActive = true
        noDJLabel.centerYAnchor.constraint(equalTo: self.tableView.centerYAnchor).isActive = true
        noDJLabel.widthAnchor.constraint(equalTo: self.tableView.widthAnchor).isActive = true
        noDJLabel.heightAnchor.constraint(equalTo: self.tableView.heightAnchor).isActive = true
    }
    
    func displayLabel() {
        if users.isEmpty {
            noDJLabel.isHidden = false
        }
        else {
            noDJLabel.isHidden = true
        }
    }
    
    func fetchDjs() {
        //So that table view doesn't load duplicates
        self.users.removeAll()
        self.events.removeAll()
        Database.database().reference().child("users").observeSingleEvent(of: .value, with: {(snapshot) in

            if let dictionary = snapshot.value as? [String: AnyObject] {
                self.usersSnapshot = dictionary
                self.fetchEvents()
            }

        }, withCancel: nil)
    }
    
    
    func fetchEvents() {
        Database.database().reference().child("Events").observeSingleEvent(of: .value, with: {(snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                for (_,value) in dictionary {
                    
                    if let djID  = value["DjID"] as? String, let endTime = value["EndDateAndTime"] as? String, let startTime = value["StartDateAndTime"] as? String, let eventID = value["id"] as? String, let location = value["location"] as? String {
                    
                        
                        let currDateTime = Date()
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "M/dd/yy, h:mm a"
                      
                        guard let sd = dateFormatter.date(from: startTime), let ed = dateFormatter.date(from: endTime) else {
                            print("Failed converting the the dates")
                            return
                        }
                        
                        
                        
                        //Check if the current time is within the start and end times
                        //Add to the events list if it is.
                        if ((sd.timeIntervalSince1970) <= currDateTime.timeIntervalSince1970 &&
                            (ed.timeIntervalSince1970) >= currDateTime.timeIntervalSince1970) {
                            
                            let newEvent = Event(djID: djID, location: location, startTime: sd, endTime: ed, eventID: eventID)
                            self.events.append(newEvent)
                            //Add the DJ to the DJ List
                            self.addDJToList(djID: djID)
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                            
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
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! DJCell
        
        
        let dj = users[indexPath.row]
        cell.textLabel?.text = dj.djName
        
        if let loc = dj.currentLocation  {
            cell.detailTextLabel?.text = "Playing at: " +  "\(loc)"
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
        else if (indexPath.row % 2 == 0){
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
        present(customTabBarController, animated: true, completion: nil)
        
        

        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {() in
            tableView.deselectRow(at: indexPath, animated: false)
        })
    
    }

    func setupNavBar() {
        navigationItem.title = "DJ List"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(handleLogout))
        navigationItem.leftBarButtonItem?.tintColor = UIColor(red: 214/255, green: 29/255, blue: 1, alpha:1.0)
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "SudegnakNo2", size : 33) as Any]
    }

    func handleLogout() {
        do {
            try Auth.auth().signOut()
        }
        catch let error as NSError {
            print("Error with signing out of firebase: \(error.localizedDescription)")
        }
        dismiss(animated: true, completion: nil)

    }

   
}





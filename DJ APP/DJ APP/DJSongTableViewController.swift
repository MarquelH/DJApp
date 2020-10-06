//
//  DJSongTableViewController.swift
//  DJ APP
//
//  Created by Marquel Hendricks on 1/4/18.
//  Copyright © 2018 Marquel and Micajuine App Team. All rights reserved.
//

import UIKit
import Firebase
import LGButton
import CoreLocation
import GooglePlaces
import StoreKit
import NVActivityIndicatorView

class DJSongTableViewController: UITableViewController, UIPopoverPresentationControllerDelegate, CLLocationManagerDelegate, UITextFieldDelegate, NVActivityIndicatorViewable {

    var dj: UserDJ?
    var cellBackgroundColor = UIColor.black
    var placesClient: GMSPlacesClient!
    var strLat: String?
    var strLong: String?
    
    @IBOutlet weak var theNavItem: UINavigationItem!
    let djTrackCellId: String = "djTrackCellId"
    //Used for up and down arrows to send to database
    var currentSnapshot: [String: AnyObject]?
    var eventSnapshot: [String: AnyObject]?
    var refSongList: DatabaseReference!
    var refEventList: DatabaseReference!
    var songlistsToBeDeleted: [String] = []
    var tableSongList = [TrackItem]()
    {
        //do i have to dispatch main
        didSet{
            tableView.reloadData()
        }
    }
    var hasEvent = false
    
    let toolbar: UIToolbar = {
        let tb = UIToolbar()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(handleToolBarDone))
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(handleToolBarDone))
        tb.barTintColor = UIColor.black
        tb.barStyle = .default
        tb.isTranslucent = true
        tb.tintColor = UIColor(red: 75/255, green: 215/255, blue: 100/255, alpha: 1)
        tb.sizeToFit()
        tb.setItems([cancelButton, spacer, doneButton], animated: true)
        return tb
    }()
    
    
    
    var datePickerView1:UIDatePicker = UIDatePicker()
    var datePickerView2:UIDatePicker = UIDatePicker()
    //Current Location stuff
    var locationManager = CLLocationManager()
    
    lazy var refreshController: UIRefreshControl = {
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(self.fetchSongList), for: UIControlEvents.valueChanged)
        rc.tintColor = UIColor.blue.withAlphaComponent(0.75)
        return rc
    }()
    
    let noRequestLabel: UILabel = {
        let nrl = UILabel()
        nrl.translatesAutoresizingMaskIntoConstraints = false
        nrl.textColor = UIColor.white
        nrl.text = "You're currently playing a live show\n No songs requested yet!"
        nrl.font = UIFont(name: "BebasNeue-Regular", size: 20)
        nrl.textAlignment = .center
        nrl.lineBreakMode = .byWordWrapping
        nrl.numberOfLines = 2
        return nrl
    }()
    
    let goLiveButton: LGButton = {
        let btn = LGButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = UIColor.green
        btn.titleString = "Go Live Now"
        btn.titleFontName = "BebasNeue-Regular"
        btn.titleFontSize = 20
        btn.titleColor = UIColor.black
        btn.addTarget(self, action: #selector(goLivePressed), for: .touchUpInside)
        btn.fullyRoundedCorners = true
        btn.gradientStartColor = UIColor.green
        btn.gradientEndColor = UIColor.green
        return btn
    }()
    
    let scheduleGigButton: LGButton = {
        let btn = LGButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = UIColor.green
        btn.titleString = "Schedule An event"
        btn.titleFontName = "BebasNeue-Regular"
        btn.titleFontSize = 20
        btn.titleColor = UIColor.black
        btn.addTarget(self, action: #selector(scheduleAGigPressed), for: .touchUpInside)
        btn.fullyRoundedCorners = true
        btn.gradientStartColor = UIColor.blue
        btn.gradientEndColor = UIColor.blue
        return btn
    }()
    
    func getEventSnapshot(){
        Database.database().reference().child("Events").observeSingleEvent(of: .value, with: {(snapshot) in
            if snapshot.exists() {
                //print("snap exists")
            }
            else {
                
                //print("snap does not exist")
            }
            DispatchQueue.main.async {
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    self.eventSnapshot = dictionary
                    //let calendarView = self.tabBarController?.viewControllers[1] as! 
                }
            }
        }, withCancel: nil)
    }
    
    @objc func handleToolBarDone() {
        self.view.endEditing(true)
    }
    
    @objc func scheduleAGigPressed() {
        self.tabBarController?.selectedIndex = 2
    }
    
    @objc func goLivePressed() {
        
        let date = Date()
        let threeHoursLater = Date.init(timeInterval: 10800, since: date)
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.short
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let strDate = dateFormatter.string(from: date)
        let strEndDate = dateFormatter.string(from: threeHoursLater)
        
        
        
        let alert = UIAlertController(title: "Set Details", message: "Confirm the details about your set\n", preferredStyle: UIAlertControllerStyle.alert)
        let attributedString = NSAttributedString(string: "Start: \(strDate)\n End: \(strEndDate)", attributes: [NSAttributedStringKey.font : UIFont(name: "BebasNeue-Regular", size: 20)!])
        let attributedTitleString = NSAttributedString(string: "Set Details\n ", attributes: [NSAttributedStringKey.font : UIFont(name: "BebasNeue-Regular", size: 25)!])
        alert.setValue(attributedString, forKey: "attributedMessage")
        alert.setValue(attributedTitleString, forKey: "attributedTitle")
        alert.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter Location or Social Media info Here"
            textField.textAlignment = .center
        }
        /// Accessing alert view backgroundColor :
        alert.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = UIColor.darkGray
        
        // Accessing buttons tintcolor :
        alert.view.tintColor = UIColor.white
        
        //Time: \(hour):\(minutes)\n Date: \(month)/\(day)/\(year)\n Location: \(Constants.DJ_LOCATION)
        alert.addAction(UIAlertAction(title: "Confirm & Go Live", style: UIAlertActionStyle.default, handler: { action in
            action.accessibilityLabel = "goLiveButton"
            if (alert.textFields![0].text == "") {
                let alert = UIAlertController(title: "Skrt!", message: "You must enter a lcation for your event. this can be a virtual or physical place", preferredStyle: UIAlertControllerStyle.alert)
                self.doAlertColoring(alertController: alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { action in
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
            } else {
            let arr = strDate.split(separator: ",")
            let dateAlone = arr[0]
            let dateForPassing = String(dateAlone)
            
            if let name = self.dj?.djName{
                let isFoundTuple = FirebaseHelper.isFound(eventDateAndTime: dateForPassing, djName: name, eventSnapshot: self.eventSnapshot)
                
                if isFoundTuple.0 { //Check if there is an event at this time and not editing event
                    let alert = UIAlertController(title: "Oops!", message: "You already have an event today", preferredStyle: UIAlertControllerStyle.alert)
                    self.doAlertColoring(alertController: alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: { action in
                        self.navigationController?.popViewController(animated: true)
                    }))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    //Generate new key inside EventList node and return it
                    let key = self.refEventList.childByAutoId().key
                    FirebaseHelper.addEventWithKey(key: key!, dj: self.dj, location: alert.textFields![0].text!, startDate: strDate, endDate: strEndDate, lat: "0.0", long: "0.0", refEventList:self.refEventList)
                    //delete past song list here!!!!
                    self.songlistsToBeDeleted.append(self.dj!.uid!)
                    self.removePastSonglist()
                    let alert = UIAlertController(title: "Congrats!", message: "Your event is now live & in your calendar", preferredStyle: UIAlertControllerStyle.alert)
                    self.doAlertColoring(alertController: alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { action in
                        self.navigationController?.popViewController(animated: true)
                    }))
                    self.present(alert, animated: true, completion: nil)
                    self.theNavItem.title = "\(name)" + "'s Requests"
                    self.hasEvent = true
                    self.displayLabel()
                }
            }
            else{
                //print("No DJ Name")
            }
            }
        }))
        alert.addAction(UIAlertAction(title: "Create an Event With New Start/End", style: UIAlertActionStyle.default, handler: { action in
            //if let v3 = theView as? addEventViewController
            self.tabBarController?.selectedIndex = 2
            if let selectedVC = self.tabBarController?.selectedViewController as? addEventViewController {
                selectedVC.eventLocation.text = "\(Constants.DJ_LOCATION)"
            }
            //self.tabBarController.sele
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.destructive , handler: { action in
            self.navigationController?.popViewController(animated: true)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func doAlertColoring(alertController: UIAlertController) {
        /// Accessing alert view backgroundColor :
        alertController.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = UIColor.darkGray
        // Accessing buttons tintcolor :
        alertController.view.tintColor = UIColor.white
    }
    
    func pickerConfig(_ sender: UITextView, alert: UIAlertController) {
        datePickerView1.datePickerMode = UIDatePickerMode.dateAndTime
        datePickerView1.minimumDate = Date.init()
        sender.inputView = datePickerView1
        sender.inputAccessoryView = toolbar
        datePickerView1.minuteInterval = 15
        datePickerView1.addTarget(self, action: #selector(datePickerChanged), for: UIControlEvents.valueChanged)
    }
    
    @objc func datePickerChanged(_ sender: UIDatePicker){
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.short
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .popover
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.startAnimating()
        super.viewWillAppear(animated)
        //Set the reference to the dj selected & to the guest
        if let uidKey = dj?.uid {
            refSongList = Database.database().reference().child("SongList").child(uidKey)
            refEventList = Database.database().reference().child("Events")
        }
        else {
            //print("DJ does not have uid")
        }
        setupNavigationBar()
        setupViews()
        fetchEventList()
        displayLabel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (UserDefaults.standard.integer(forKey: "launchCount") == 50){
            //Asking for review on 10th launch.
            SKStoreReviewController.requestReview()
            //UserDefaults.standard.set(0, forKey:"launchCount")
        }
        /*placesClient = GMSPlacesClient.shared()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        // Specify the place data types to return.
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
            UInt(GMSPlaceField.placeID.rawValue))!
        
        
        DispatchQueue.main.async {
            self.placesClient?.findPlaceLikelihoodsFromCurrentLocation(withPlaceFields: fields, callback: {
                (placeLikelihoodList: Array<GMSPlaceLikelihood>?, error: Error?) in
                if let error = error {
                    //print("An error occurred: \(error.localizedDescription)")
                    return
                }
                
                if let placeLikelihoodList = placeLikelihoodList {
                    let place = placeLikelihoodList[0].place
                    Constants.DJ_LOCATION = String(describing: place.name!)
                    self.strLong = place.coordinate.longitude.description
                    self.strLat = place.coordinate.latitude.description
                }
            })
        }
        //print("FINISHED! with location: \(Constants.DJ_LOCATION)")*/
    }
    
    //HELPERS -------------------------
    
    func getSongSnapshot(){
        refSongList.observeSingleEvent(of: .value, with: {(snapshot) in
            if snapshot.exists() {
                //print("snap exists")
            }
            else {
                //print("snap does not exist")
            }
            DispatchQueue.main.async {
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    self.currentSnapshot = dictionary
                }
            }
        }, withCancel: nil)
    }
    
    func fetchEventList() {
        self.hasEvent = false
        //print(refEventList)
        refEventList.observeSingleEvent(of: .value, with: {(snapshot) in
            
            self.tableSongList.removeAll()
            
            guard let workingSnap = snapshot.value as? [String: AnyObject] else {
                self.eventSnapshot = nil
                //print("No snapshot for event")
                return
            }
            self.eventSnapshot = workingSnap
            
            for (_,value) in workingSnap {
                //Find the events with the correct dj id
                if let uid = value["DjID"] as? String, uid == self.dj?.uid {
                    //check if the event time lines up
                    if let endTime = value["EndDateAndTime"] as? String, let startTime = value["StartDateAndTime"] as? String {
                        
                        
                        let currDateTime = Date()
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "M/dd/yy, h:mm a"
                        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                        
                        guard let sd = dateFormatter.date(from: startTime), let ed = dateFormatter.date(from: endTime) else {
                            //print("Failed converting the dates")
                            return
                        }
                        
                        //Check if the current time is within the start and end times
                        //Add to the events list if it is.
                        if ((sd.timeIntervalSince1970) <= currDateTime.timeIntervalSince1970 &&
                            (ed.timeIntervalSince1970) >= currDateTime.timeIntervalSince1970) {
                            self.hasEvent = true
                            self.displayLabel()
                            if let name = self.dj?.djName{
                                self.theNavItem.title = "\(name)" + "'s Requests"
                            }
                            else {
                                //print("No DJ Name")
                            }
                        } else {
                            //print("NO EVENT")
                        }
                    }
                }
            }
            self.fetchSongList(found: self.hasEvent)
            
        }, withCancel: {(error) in
            //print(error.localizedDescription)
            return
        })
    }
    
    @objc func fetchSongList(found: Bool) {
        if !Reachability.isConnectedToNetwork() {
            let alert = UIAlertController(title: "Oops!", message: "It seems you aren't connected to the internet. \nReconnect and try again!", preferredStyle: UIAlertControllerStyle.alert)
            self.doAlertColoring(alertController: alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { action in
                self.navigationController?.popViewController(animated: true)
                return
            }))
            self.present(alert, animated: true, completion: nil)
        }
        if found {
     
            refSongList.queryOrdered(byChild: "totalvotes").observeSingleEvent(of: .value, with: {(snapshot) in
                
                //No Snap for Song list -> Remove all songs from song list, unless it was empty to begin with
                guard let workingSnap = snapshot.value as? [String: AnyObject] else {
                    if var currSnap = self.currentSnapshot {
                        //currSnap.removeAll()
                    }
                    return
                }
              
                self.currentSnapshot = workingSnap
                
                for snap in snapshot.children.allObjects as! [DataSnapshot] {
                    
                    if let value = snap.value as? [String: AnyObject], let name = value["name"] as? String, let artist = value["artist"] as? String, let artwork = value["artwork"] as? String, let id = value["id"] as? String, let upvotes = value["upvotes"] as? Int, let downvotes = value["downvotes"] as? Int, let totalvotes = value["totalvotes"] as? Int, let album = value["album"] as? String, let accepted = value["accepted"] as? Bool {
                        
                        
                        let newTrack = TrackItem(trackName: name, trackArtist: artist, trackImage: artwork, id: id, upvotes: upvotes, downvotes: downvotes, totalvotes: totalvotes, trackAlbum: album, accepted: accepted)
                        self.tableSongList.insert(newTrack, at: 0)
                        
                    }
                }
                
                
            }, withCancel: {(error) in
                //print(error.localizedDescription)
                return
            })
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
        refreshController.endRefreshing()
        
    }
    
    func updateSongList(track: TrackItem) {
        
        if let name = track.trackName, let artist = track.trackArtist, let artwork = track.trackImage, let id = track.id, let upvotes = track.upvotes, let downvotes = track.downvotes, let totalvotes = track.totalvotes, let album = track.trackAlbum, let accepted = track.accepted {
            
            let stringForAccepted = String(describing: artwork)
            
            let values = ["name": name, "artist": artist, "artwork": stringForAccepted, "id": id, "upvotes": upvotes, "downvotes": downvotes, "totalvotes": totalvotes, "album": album,"accepted": accepted] as [String : Any]
            refSongList.child(id).setValue(values)
        }
        else {
            //print("Problem updating firebase with accepted change. ")
        }
        
        
    }

    
    
    func setupNavigationBar() {
        
        //Back button
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor(red: 214/255, green: 29/255, blue: 1, alpha:1.0)
        
        //Refresh button
        if self.hasEvent {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "End Show", style: .plain, target: self, action: #selector(endShow))
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 214/255, green: 29/255, blue: 1, alpha:1.0)
        } else {
            self.navigationItem.rightBarButtonItem = nil;
        }
        
        //Bar text
        self.navigationController?.navigationBar.barTintColor =  UIColor.black
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        
        //Bar text
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "BebasNeue-Regular", size : 30) as Any, NSAttributedStringKey.foregroundColor: UIColor.white]
        
        theNavItem.title = "Pre-Show Page"
    }
    
    func removePastSonglist() {
        //Remove past song lists
        let ref2 = Database.database().reference().child("SongList")
        if !self.songlistsToBeDeleted.isEmpty {
            for djID in songlistsToBeDeleted {
                //print("DELETING LIST!")
                ref2.child(djID).setValue(nil)
            }
        }
    }
    
    @objc func endShow() {
        let alert = UIAlertController(title: "End Show", message: "Are you sure you want to end the show?", preferredStyle: UIAlertControllerStyle.alert)
        self.doAlertColoring(alertController: alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.destructive, handler: { action in
            self.deleteEventAndReloadUI()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: { action in
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func deleteEventAndReloadUI() {
        if let workingSnap = self.eventSnapshot {
            for (k,v) in workingSnap {
                if let dateAndTime = v["StartDateAndTime"] as? String, let theName = v["DJ Name"] as? String,
                    let endTime = v["EndDateAndTime"] as? String {
                    //print("WE'RE IN")
                    //print("\(dateAndTime)")
                    let dateAloneArray = dateAndTime.split(separator: ",")
                    let dateForComparison = dateAloneArray[0]
                    let realDate = String(dateForComparison)
                    
                    
                    let dateFormatter2 = DateFormatter()
                    
                    dateFormatter2.dateStyle = DateFormatter.Style.short
                    dateFormatter2.timeStyle = DateFormatter.Style.short
                    dateFormatter2.locale = Locale(identifier: "en_US_POSIX")
                    
                    
                    //for date in calendarView.selectedDates {
                    let todaysDate = Date.init()
                        let strDate = dateFormatter2.string(from: todaysDate)
                        let todaysDateAloneArr = strDate.split(separator: ",")
                        let todaysDateAloneForConversion = todaysDateAloneArr[0]
                        let todaysDateAloneForComparison = String(todaysDateAloneForConversion)
                    
                    guard let sd = dateFormatter2.date(from: dateAndTime), let ed = dateFormatter2.date(from: endTime) else {
                        //print("Failed converting the the dates")
                        return
                    }
                        
                    
                    //Check if the current time is within the start and end times
                    //Add to the events list if it is.
                        if ((realDate == todaysDateAloneForComparison && theName == dj?.djName) ||
                            (sd.timeIntervalSince1970 <= todaysDate.timeIntervalSince1970 &&
                            ed.timeIntervalSince1970 >= todaysDate.timeIntervalSince1970 && theName == dj?.djName)){
                            refEventList.child(k).removeValue()
                            self.tableSongList.removeAll()
                            self.hasEvent = false
                            self.songlistsToBeDeleted.append(self.dj!.uid!)
                            self.removePastSonglist()
                            self.displayLabel()
                            self.setupNavigationBar()
                            self.tableView.reloadData()
                            let alert = UIAlertController(title: "Show Ended", message: "We have successfully ended your event and removed it from your calendar.", preferredStyle: UIAlertControllerStyle.alert)
                            self.doAlertColoring(alertController: alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { action in
                                self.navigationController?.popViewController(animated: true)
                            }))
                            self.present(alert, animated: true, completion: nil)
                        } else {
                            //print("SOMETING GOING ON")
                        }
                        
                    //}
                }
            }
        }
    }
    
    func setupViews() {
        self.tableView.register(djTrackCell.self, forCellReuseIdentifier: djTrackCellId)
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = UIColor.black
        self.tableView.refreshControl = refreshController
        
        self.edgesForExtendedLayout = []
        self.extendedLayoutIncludesOpaqueBars = true
        self.automaticallyAdjustsScrollViewInsets = true
        
        self.tableView.addSubview(noRequestLabel)
        self.tableView.addSubview(goLiveButton)
        self.tableView.addSubview(scheduleGigButton)
        
        goLiveButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        goLiveButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -75).isActive = true
        goLiveButton.heightAnchor.constraint(equalToConstant: 102).isActive = true
        goLiveButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/2).isActive = true
        
        scheduleGigButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        scheduleGigButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 75).isActive = true
        scheduleGigButton.heightAnchor.constraint(equalToConstant: 102).isActive = true
        scheduleGigButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/2).isActive = true
        
        noRequestLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        noRequestLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        noRequestLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
    }
    
    func displayLabel() {
        if !self.hasEvent {
            //if there's no ongoing event...
            //print("NO EVENT")
            goLiveButton.isHidden = false
            scheduleGigButton.isHidden = false
            noRequestLabel.isHidden = true
            self.navigationItem.rightBarButtonItem = nil
        } else {
            //print("EVENT")
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "End Show", style: .plain, target: self, action: #selector(endShow))
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 214/255, green: 29/255, blue: 1, alpha:1.0)
            goLiveButton.isHidden = true
            scheduleGigButton.isHidden = true
            noRequestLabel.isHidden = false
        }
        self.stopAnimating()
    }
    
    /*func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // Specify the place data types to return.
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
            UInt(GMSPlaceField.placeID.rawValue))!
        
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            DispatchQueue.main.async {
                self.placesClient?.findPlaceLikelihoodsFromCurrentLocation(withPlaceFields: fields, callback: {
                    (placeLikelihoodList: Array<GMSPlaceLikelihood>?, error: Error?) in
                    if let error = error {
                        //print("An error occurred: \(error.localizedDescription)")
                        return
                    }
                    
                    if let placeLikelihoodList = placeLikelihoodList {
                        let place = placeLikelihoodList[0].place
                        Constants.DJ_LOCATION = String(describing: place.name!)
                        self.strLong = place.coordinate.longitude.description
                        self.strLat = place.coordinate.latitude.description
                    }
                })
            }
        }
    }*/
    
    @objc func handleLogout() {
        let fireAuth = Auth.auth()
        
        do {
            try fireAuth.signOut()
        } catch let signoutError as NSError {
            //print("Error signing out: %@", signoutError)
        }
        
        let loginController = DJLoginController()
        loginController.modalPresentationStyle = .fullScreen
        present(loginController, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /*let selectedSongTrack = SongSelectedByDJViewController()
        if self.presentedViewController != nil {
            //do i have to keep this? w
            self.dismiss(animated: true, completion: nil)
        }
        selectedSongTrack.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        selectedSongTrack.track = tableSongList[indexPath.row]
        selectedSongTrack.songTableController = self
        selectedSongTrack.index = indexPath.row
        self.tabBarController?.present(selectedSongTrack, animated: true, completion: {() in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: {() in
                self.tableView.deselectRow(at: indexPath, animated: false)
            })
        })*/
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if (tableSongList.count == 0 && self.hasEvent) {
            noRequestLabel.isHidden = false
        }
        else {
            noRequestLabel.isHidden = true
        }
        return tableSongList.count
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        //let cell = tableView.dequeueReusableCell(withIdentifier: djTrackCellId) as! djTrackCell
        
        //Trying to change cell color when accept/deny occurs
        
        let accept = UITableViewRowAction(style: .normal, title: "Accept") { action, index in
            //print("Accept tapped")
            //self.cellBackgroundColor = UIColor.green
            self.tableSongList[indexPath.row].accepted = true
            
            
            //Have to update Firebase with new accepted status
            self.updateSongList(track: self.tableSongList[indexPath.row])
            
            
            tableView.reloadData()
        }
        accept.backgroundColor = .green
        
        return [accept]
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: djTrackCellId, for: indexPath) as! djTrackCell
        
        guard let name = tableSongList[indexPath.row].trackName, let artist = tableSongList[indexPath.row].trackArtist, let artwork = tableSongList[indexPath.row].trackImage, let totalvotes = tableSongList[indexPath.row].totalvotes, let _ = tableSongList[indexPath.row].id, let accepted = tableSongList[indexPath.row].accepted else {
            //print("Issue parsing from tableSongList")
            return cell
        }
        
        if accepted {
            cell.backgroundColor = UIColor(red: 65/255, green: 244/255, blue: 104/255, alpha: 1.0)
        }
        else {
            cell.backgroundColor = self.cellBackgroundColor
        }
        
        cell.textLabel?.text = "\(name)"
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.detailTextLabel?.text = "Artist: \(artist)"
        cell.detailTextLabel?.adjustsFontSizeToFitWidth = true
        cell.totalvotesLabel.text = "\(totalvotes)"
        
        
        if let imageURL = artwork.addHTTPS()?.absoluteString.replaceWith60() {
            cell.profileImageView.loadImageWithChachfromUrl(urlString: imageURL)
        }
        else {
            //print("problem with URL parsing")
        }
        
        cell.noSelection()
        return cell
    }

}

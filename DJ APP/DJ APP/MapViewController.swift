//
//  MapViewController.swift
//  DJ APP
//
//  Created by Marquel Hendricks on 1/12/18.
//  Copyright © 2018 Marquel and Micajuine App Team. All rights reserved.
//

import UIKit
import GoogleMaps
import Firebase
import GooglePlaces

class MapViewController: UIViewController {
    var guestID: String?
    var eventSnapshot: [String: AnyObject]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        layoutViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .default
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //UIApplication.shared.statusBarStyle = .default
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    func setupNavBar(){
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .rewind, target: self, action: #selector(handleLogout))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor(red: 214/255, green: 29/255, blue: 1, alpha:1.0)
        
        //Bar text
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "SudegnakNo2", size : 35) as Any]
        self.navigationItem.title = "DJs Near You"
    }
    
    func handleLogout(){
    let fireAuth = Auth.auth()
    
        do {
            try fireAuth.signOut()
        } catch let signoutError as NSError {
    print("Error signing out: %@", signoutError)
    }
    
    let loginController = LoginController()
    present(loginController, animated: true, completion: nil)
        
    }
    
    func getEventSnapshot(){
        print("GETTING EVENT SNAPSHOT")
        Database.database().reference().child("Events").observeSingleEvent(of: .value, with: {(snapshot) in
            if snapshot.exists() {
                print("snap exists")
            }
            else {
                print("snap does not exist")
            }
            DispatchQueue.main.async {
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    self.eventSnapshot = dictionary
                }
            }
        }, withCancel: nil)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func layoutViews() {
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        let camera = GMSCameraPosition.camera(withLatitude: 38.986918, longitude: -76.942554, zoom: 15.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
        mapView.clear() //Resetting the markers
        // Creates a marker in the center of the map.
        Database.database().reference().child("Events").observeSingleEvent(of: .value, with: {(snapshot) in
            if snapshot.exists() {
                print("snap exists")
            }
            else {
                print("snap does not exist")
            }
            DispatchQueue.main.async {
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    for(_,v) in dictionary{
                        let latCoords = v["Latitude Coordinates"] as? String, longCoords = v["Longitude Coordinates"] as? String,name = v["DJ Name"] as? String,location = v["location"] as? String,date = v["StartDateAndTime"] as? String
                        let todaysDate = Date.init()
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateStyle = DateFormatter.Style.short
                        dateFormatter.timeStyle = DateFormatter.Style.short
                        let strToday = dateFormatter.string(from: todaysDate)
                        let dateAloneArray = strToday.split(separator: ",")
                        let todaysDateForComparison = dateAloneArray[0]
                        
                        let theArrayForThisDate = date?.split(separator: ",")
                        let thisDateForComparison = theArrayForThisDate![0]
                        
                        
                        if todaysDateForComparison == thisDateForComparison {
                            
                        print("We have something on this date!")
                        let marker = GMSMarker()
                        let actualLats = Double(latCoords!) as! CLLocationDegrees
                        let actualLongs = Double(longCoords!) as! CLLocationDegrees
                        marker.position = CLLocationCoordinate2D(latitude: actualLats, longitude: actualLongs)
                        marker.title = "\(name!) is Playing!"
                        marker.snippet = "\(location!)"
                        marker.tracksViewChanges = true
                        marker.tracksInfoWindowChanges = true
                        //marker.icon = UIImage(named: "bioIcon")
                        marker.map = mapView
                        }
                        else{
                            print("No markers today.")
                        }
                    }
                }
                else{
                    print("IDK!")
                }
            }
        }, withCancel: nil)
    }

}

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
        //getEventSnapshot()
        setupNavBar()
        layoutViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .default
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    func setupNavBar(){
        navigationItem.title = "DJs Near You"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(handleLogout))
        navigationItem.leftBarButtonItem?.tintColor = UIColor(red: 214/255, green: 29/255, blue: 1, alpha:1.0)
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "SudegnakNo2", size : 33) as Any]
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
                        let latCoords = v["Latitude Coordinates"] as? String, longCoords = v["Longitude Coordinates"] as? String,name = v["DJ Name"] as? String,location = v["location"] as? String
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
                }
                else{
                    print("IDK")
                }
            }
        }, withCancel: nil)
        
        
        
        
        /*if let workingSnap = self.eventSnapshot{
            print("MAKING MARKER")
            for (k,v) in workingSnap{
                let latCoords = v["Latitude Coordinates"], longCoords = v["Longitude Coordinates"],name = v["DJ Name"],location = v["location"]
                let marker = GMSMarker()
                let actualLats = latCoords as! CLLocationDegrees
                let actualLongs = longCoords as! CLLocationDegrees
                marker.position = CLLocationCoordinate2D(latitude: actualLats, longitude: actualLongs)
                marker.title = "\(name) is Playing!"
                marker.snippet = "\(location)"
                marker.map = mapView
            }
        }
        else{
            print("NOT MAKING MARKER")
        }*/
    }

}

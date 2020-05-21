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
import MapKit
import CoreLocation
import StoreKit

class MapViewController: UIViewController, CLLocationManagerDelegate {
    var guestID: String?
    var eventSnapshot: [String: AnyObject]?
    //var strLong = -76.942554
    //var strLat = 38.986918
    var strLat = 0.0
    var strLong = 0.0
    var passedLat = 0.0
    var passedLong = 0.0
    var camera: GMSCameraPosition?
    var hasEvent = false
    
    //Current Location stuff
    var locationManager = CLLocationManager()
    
    var mapView: GMSMapView!
    var zoomLevel: Float = 15.0
    
    var currentLocationMarker: GMSMarker?
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        
        //let tableNav = self.tabBarController?.viewControllers![2] as! UINavigationController
        //let tableView = tableNav.viewControllers[0] as! DJMenuViewController
        //tableView.currentUserLocation = location
        
        strLat = location.coordinate.latitude
        strLong = location.coordinate.longitude
        
        
        let camera = GMSCameraPosition.camera(withLatitude: strLat, longitude: strLong, zoom: 15.0)
       /* currentLocationMarker = GMSMarker()
        
        currentLocationMarker!.position = CLLocationCoordinate2D(latitude: strLat, longitude: strLong)
        currentLocationMarker!.title = "You are here!"
        currentLocationMarker!.tracksViewChanges = true
        currentLocationMarker!.map = self.mapView*/
        
        mapView.animate(to: camera)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let status = CLLocationManager.authorizationStatus()
        let settingsURL = NSURL(string: UIApplicationOpenSettingsURLString)
        if ((UserDefaults.standard.integer(forKey: "launchCount") == 10) && status != CLAuthorizationStatus.authorizedWhenInUse && status != CLAuthorizationStatus.authorizedAlways) {
            let alert = UIAlertController(title: "Oops!", message: "Your Location must be enabled if you want to see DJs near you", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Go to location settings", style: UIAlertActionStyle.default, handler: { action in
                if UIApplication.shared.canOpenURL(settingsURL! as URL) {
                    UIApplication.shared.open(settingsURL! as URL, completionHandler: { (success) in
                        //print("Settings opened: \(success)") // Prints true
                    })
                }
            }))
            alert.addAction(UIAlertAction(title: "Eh, I don't care", style: UIAlertActionStyle.cancel, handler: { action in
                self.navigationController?.popViewController(animated: true)
            }))
            UserDefaults.standard.set(0, forKey:"launchCount")
            self.present(alert, animated: true, completion: nil)
        }
        setupNavBar()
        
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        layoutViews()
        
    }
    
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationManager.startUpdatingLocation()
    }
    
    @objc func popVC() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupNavBar(){
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(popVC))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        
        //self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(handleSearch))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Search Map", style: .plain, target: self, action: #selector(handleSearch))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        
        //Bar text
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "BebasNeue-Regular", size : 40) as Any, NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationItem.title = "Venue Map"
        self.navigationController?.navigationBar.barTintColor = UIColor.black
    }
    
    @objc func handleLogout(){
    let fireAuth = Auth.auth()
    
        do {
            try fireAuth.signOut()
        } catch let signoutError as NSError {
    //print("Error signing out: %@", signoutError)
    }
    
    let loginController = LoginController()
    loginController.modalPresentationStyle = .fullScreen
    present(loginController, animated: true, completion: nil)
        
    }
    
    @objc func handleSearch() {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        autocompleteController.modalPresentationStyle = .fullScreen
        autocompleteController.tableCellBackgroundColor = UIColor.darkGray
        autocompleteController.navigationController?.navigationBar.barTintColor = UIColor.darkGray
        autocompleteController.primaryTextHighlightColor = UIColor.white
        autocompleteController.primaryTextColor = UIColor.black
        autocompleteController.secondaryTextColor = UIColor.black
        present(autocompleteController, animated: true, completion: nil)
    }
    
    func getEventSnapshot(){
        //print("GETTING EVENT SNAPSHOT")
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
                }
            }
        }, withCancel: nil)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func layoutViews() {
        if (passedLat == 0.0 || passedLong == 0.0){
        strLong = -73.935242
        strLat = 40.730610
        camera = GMSCameraPosition.camera(withLatitude: strLat, longitude: strLong, zoom: 15.0)
        } else{
            camera = GMSCameraPosition.camera(withLatitude: passedLat, longitude: passedLong, zoom: 15.0)
        }
        
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera!)
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        
        do {
            // Set the map style by passing the URL of the local file.
            if let styleURL = Bundle.main.url(forResource: "style", withExtension: "json") {
                mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
                
            } else {
                NSLog("Unable to find style.json")
            }
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        } 
        
        view = mapView
        mapView.clear() //Resetting the markers
        // Creates a marker in the center of the map.
        Database.database().reference().child("Events").observeSingleEvent(of: .value, with: {(snapshot) in
            if snapshot.exists() {
                //print("snap exists")
            }
            else {
                //print("snap does not exist")
            }
            DispatchQueue.main.async {
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    for(_,v) in dictionary{
                        let latCoords = v["Latitude Coordinates"] as? String, longCoords = v["Longitude Coordinates"] as? String,name = v["DJ Name"] as? String,location = v["location"] as? String,date = v["StartDateAndTime"] as? String, endTime = v["EndDateAndTime"] as? String
                        
                        let todaysDate = Date.init()

                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "M/dd/yy, h:mm a"
                        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                        
                        //print("\(date!)")
                        //print("\(endTime!)")
                        
                        var sde = dateFormatter.date(from: date!)
                        var ede = dateFormatter.date(from: endTime!)
                        
                        //print("\(sde)")
                        //print("\(ede)")
                        
                        guard let sd = dateFormatter.date(from: date!), let ed = dateFormatter.date(from: endTime!) else {
                            //print("Failed converting the the dates")
                            return
                        }
                        //Check if the current time is within the start and end times
                        //Add to the events list if it is.

                        let dateFormatter2 = DateFormatter()
                        dateFormatter2.dateStyle = DateFormatter.Style.short
                        dateFormatter2.timeStyle = DateFormatter.Style.short
                        dateFormatter2.locale = Locale(identifier: "en_US_POSIX")
                        let strToday = dateFormatter2.string(from: todaysDate)
                        let dateAloneArray = strToday.split(separator: ",")
                        let todaysDateForComparison = dateAloneArray[0]
                        
                        
                        let dateAloneArray2 = date?.split(separator: ",")
                        let eventDateForComparison = String(describing: dateAloneArray2![0])
                        
                        
                        let theArrayForThisDate = date?.split(separator: ",")
                        let thisDateForComparison = theArrayForThisDate![0]
                        let thisTimeForComparison = theArrayForThisDate![1]
                        let strTime = String(thisTimeForComparison)
                        let realStrTime = strTime.replacingOccurrences(of: " ", with: "")
                        
                        let theArrayForThisDate2 = endTime?.split(separator: ",")
                        let thisDateForComparison2 = theArrayForThisDate2![0]
                        let endStringDate = String(describing: thisDateForComparison2)
                        let thisTimeForComparison2 = theArrayForThisDate2![1]
                        let strTime2 = String(thisTimeForComparison2)
                        let realStrTime2 = strTime2.replacingOccurrences(of: " ", with: "")
                        
                        if todaysDateForComparison == eventDateForComparison {
                            //print("DATES ARE EQUAL")
                            if ((ed.timeIntervalSince1970) >= todaysDate.timeIntervalSince1970){
                                self.hasEvent = true
                                //print("HAS EVENT")
                            }
                            if self.hasEvent && latCoords != "0.0" && longCoords != "0.0" {
                                //print("SETTING MARKER")
                            
                                let marker = GMSMarker()
                                marker.tracksInfoWindowChanges = true
                                let actualLats = Double(latCoords!) as! CLLocationDegrees
                                let actualLongs = Double(longCoords!) as! CLLocationDegrees
                                //print("LAT: \(actualLats), LONG: \(actualLongs)")
                                marker.position = CLLocationCoordinate2D(latitude: actualLats, longitude: actualLongs)
                                if ((sd.timeIntervalSince1970) <= todaysDate.timeIntervalSince1970){
                                    marker.title = "\(name!) is playing until \(realStrTime2)!"
                                }
                                else {
                                    marker.title = "\(name!) is playing at \(realStrTime)!"
                                }
                                
                                marker.icon = UIImage(named: "headphonesSmall")
                                //marker.snippet = "\(location!)"
                                marker.snippet = "Click Live DJs tab to Request!"
                                marker.tracksViewChanges = true
                                marker.tracksInfoWindowChanges = true
                                marker.map = self.mapView
                                self.hasEvent = false
                            }
                            else{
                                //print("DOES NOT HAVE AN EVENT")
                            }
                       
                    }
                        else if endStringDate == todaysDateForComparison{
                            //print("DATES ARE EQUAL")
                            if ((ed.timeIntervalSince1970) >= todaysDate.timeIntervalSince1970){
                                self.hasEvent = true
                                //print("ITS TRUE")
                            }
                            
                            if self.hasEvent && latCoords != "0.0" && longCoords != "0.0" {
                                
                                //print("We have something on this date!")
                                let marker = GMSMarker()
                                let actualLats = Double(latCoords!) as! CLLocationDegrees
                                let actualLongs = Double(longCoords!) as! CLLocationDegrees
                                marker.position = CLLocationCoordinate2D(latitude: actualLats, longitude: actualLongs)
                                marker.title = "\(name!) is playing until \(realStrTime2)!"
                                marker.icon = UIImage(named: "headphonesSmall")
                                marker.snippet = "\(location!)"
                                marker.tracksViewChanges = true
                                marker.tracksInfoWindowChanges = true
                                marker.map = self.mapView
                                self.hasEvent = false
                            }
                            else{
                                //print("DOES NOT HAVE AN EVENT")
                            }
                            
                        }
                        else if (ed.timeIntervalSince1970 >= todaysDate.timeIntervalSince1970) && (sd.timeIntervalSince1970 <= todaysDate.timeIntervalSince1970) {
                            //print("EVENTS IN BETWEEN")
                        }
                        else {
                            //print("NO EVENTS TODAY")
                        }
                        
            }
                }
            }}, withCancel: nil)
    }

}

extension MapViewController: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        ////print("Place coordinate: \(place.coordinate)")
        passedLong = place.coordinate.longitude
        passedLat = place.coordinate.latitude
        layoutViews()
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        //print("Error: ", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}

/*extension MapViewController: CLLocationManagerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        //print("Location: \(location)")
        
        passedLong = location.coordinate.longitude
        passedLat = location.coordinate.latitude
        //let camera2 = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                              //longitude: location.coordinate.longitude,
                                              //zoom: zoomLevel)
        
           // mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera2)
        //view = mapView
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            //print("Location access was restricted.")
        case .denied:
            //print("User denied access to location.")
            // Display the map using the default location.
            mapView.isHidden = false
        case .notDetermined:
            //print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            //print("Location status is OK.")
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        //print("Error: \(error)")
    }
}*/




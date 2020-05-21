//
//  addEventViewController.swift
//  DJ APP
//
//  Created by Marquel Hendricks on 12/24/17.
//  Copyright © 2017 Marquel and Micajuine App Team. All rights reserved.
//

import UIKit
import Firebase
import GooglePlaces
import LGButton
import NVActivityIndicatorView

class addEventViewController: UIViewController, NVActivityIndicatorViewable {

    var eventSnapshot: [String: AnyObject]?
    
    var dj: UserDJ?
    var refEventList: DatabaseReference!
    var startingTime = "DummyValue"
    var doWeHaveDJ = false
    var originalView: CGFloat?
    var strLong: String?
    var strLat: String?
    //var isEditingEvent: Bool = false
    var currentEvent: Event?
    var songlistsToBeDeleted: [String] = []
    //var editingEventInfo: [String]?
    
    @IBOutlet weak var endingTime: UITextField!
    @IBOutlet weak var eventLocation: UITextField!
    @IBOutlet weak var eventToAddDateAndTime: UITextField!
    @IBOutlet weak var saveEventButton: UIButton!
    @IBOutlet weak var startDateAndTimeLabel: UILabel!
    @IBOutlet weak var movePickerSubLabel1: UILabel!
    @IBOutlet weak var endDateAndTimeLabel: UILabel!
    @IBOutlet weak var movePickerSubLabel2: UILabel!
    @IBOutlet weak var venueLabel: UILabel!
    @IBOutlet weak var lastSubLabel: UILabel!
    @IBOutlet weak var startTextField: UITextField!
    @IBOutlet weak var endTextField: UITextField!
    @IBOutlet weak var VenueTextField: UITextField!
    
    
    func setFonts() {
        startDateAndTimeLabel.font = UIFont(name: "BebasNeue-Regular", size: 26)
        movePickerSubLabel1.font = UIFont(name: "BebasNeue-Regular", size: 22)
        endDateAndTimeLabel.font = UIFont(name: "BebasNeue-Regular", size: 26)
        movePickerSubLabel2.font = UIFont(name: "BebasNeue-Regular", size: 22)
        venueLabel.font = UIFont(name: "BebasNeue-Regular", size: 26)
        movePickerSubLabel2.font = UIFont(name: "BebasNeue-Regular", size: 22)
        lastSubLabel.font = UIFont(name: "BebasNeue-Regular", size: 22)
        saveEventButton.titleLabel?.font = UIFont(name: "BebasNeue-Regular", size: 22)
        startTextField.font = UIFont(name: "BebasNeue-Regular", size: 17)
        endTextField.font = UIFont(name: "BebasNeue-Regular", size: 17)
        VenueTextField.font = UIFont(name: "BebasNeue-Regular", size: 17)
    }
    
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
    
    
    @objc func handleToolBarDone() {
        self.view.endEditing(true)
    }
    
    var datePickerView1:UIDatePicker = UIDatePicker()
    var datePickerView2:UIDatePicker = UIDatePicker()
    
    @IBAction func pickerConfig(_ sender: UITextView) {
        datePickerView1.datePickerMode = UIDatePickerMode.dateAndTime
        datePickerView1.minimumDate = Date.init()
        sender.inputView = datePickerView1
        sender.inputAccessoryView = toolbar
        datePickerView1.minuteInterval = 15
        datePickerView1.addTarget(self, action: #selector(datePickerChanged), for: UIControlEvents.valueChanged)
    }
    
    @IBAction func beganToEnterLocation(_ sender: Any) {
        presentSocialMediaLiveChoiceAlert()
    }
    
    func doAlertColoring(alertController: UIAlertController) {
        /// Accessing alert view backgroundColor :
        alertController.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = UIColor.darkGray
        // Accessing buttons tintcolor :
        alertController.view.tintColor = UIColor.white
    }
    
    func presentSocialMediaLiveChoiceAlert() {
        let alert = UIAlertController(title: "Quick Question", message: "Are you performing at a venu or virtually?", preferredStyle: UIAlertControllerStyle.alert)
        doAlertColoring(alertController: alert)
        alert.addAction(UIAlertAction(title: "Virtually", style: UIAlertActionStyle.default, handler: { _ in
            let confirmationAlert = UIAlertController(title: "Virtual Show Details", message: "Specify your channel, radio station, or social media page below", preferredStyle: UIAlertControllerStyle.alert)
            self.doAlertColoring(alertController: confirmationAlert)
            confirmationAlert.addTextField { (textField : UITextField!) -> Void in
                textField.placeholder = "@Go.DJ on IG Live"
            }
            confirmationAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { action in
                if confirmationAlert.textFields![0].text! != "" {
                    self.eventLocation.text = confirmationAlert.textFields![0].text!
                    self.dismissAlert()
                }
                else {
                    self.presentAlert(title: "Skrt!", error: "Please fill in your radio station.")
                }
            }))
            confirmationAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.destructive, handler: { (_) in
                self.dismissAlert()
            }))
            self.present(confirmationAlert, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Venue", style: UIAlertActionStyle.default, handler: { _ in
            let autocompleteController = GMSAutocompleteViewController()
            autocompleteController.delegate = self
            autocompleteController.tableCellBackgroundColor = UIColor.darkGray
            autocompleteController.navigationController?.navigationBar.barTintColor = UIColor.darkGray
            autocompleteController.primaryTextHighlightColor = UIColor.white
            autocompleteController.primaryTextColor = UIColor.black
            autocompleteController.secondaryTextColor = UIColor.black
            self.present(autocompleteController, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.destructive, handler: { (_) in
            self.dismissAlert()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func storeEvent(startDateAndTime: String, endDateAndTime: String, location: String) {
        
    }
    
    
    @IBAction func picker2Config(_ sender: UITextView) {
        datePickerView2.datePickerMode = UIDatePickerMode.dateAndTime
        datePickerView2.minimumDate = datePickerView1.date
        sender.inputView = datePickerView2
        sender.inputAccessoryView = toolbar
        datePickerView2.minuteInterval = 15
        datePickerView2.addTarget(self, action: #selector(datePickerChanged), for: UIControlEvents.valueChanged)
    }
    
    
    
    
    @objc func datePickerChanged(_ sender: UIDatePicker){
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.short
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        if (eventToAddDateAndTime.isEditing) {
            let strDate = dateFormatter.string(from: sender.date)
            eventToAddDateAndTime.text = strDate
            endingTime.text = ""
        }
        else if (endingTime.isEditing)  {
            let strDate = dateFormatter.string(from: sender.date)
            endingTime.text = strDate
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        originalView = self.view.frame.origin.y
        saveEventButton.layer.cornerRadius = 24
        startTextField.layer.cornerRadius = 24
        endTextField.layer.cornerRadius = 24
        VenueTextField.layer.cornerRadius = 24
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let _ = dj?.uid {
            //print("DJ has uid")
            doWeHaveDJ = true
            refEventList = Database.database().reference().child("Events")
        }
        else {
            doWeHaveDJ = false
            //print("DJ does not have uid")
        }
        getEventSnapshot()
        setFonts()
    }
    
    //Reset isEditingEvent when view changes, because they should not be editing anymore.
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func fillInLabels(startTime: String, endTime: String, location: String) {
        endingTime.text = endTime
        eventLocation.text = location
        eventToAddDateAndTime.text = startTime
    }
    
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
                }
            }
        }, withCancel: nil)
    }
    
    func presentCalendar(){
        let storyboard = UIStoryboard(name: "ScehdulingStoryboard", bundle:nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "scheduleView") as! scheduleViewController
        controller.dj = dj
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func addEvent(_ sender: Any) {
        startAnimating()
        guard let dateAndTime = eventToAddDateAndTime.text, dateAndTime != "", let endingDateAndTime = endingTime.text, endingDateAndTime != "", let location = eventLocation.text, location != "" else {
            self.stopAnimating()
            presentAlert(title: "Skrt!", error: "Please fill in all the fields.")
            return
        }
        
        //What are you using these for?
        let arr = dateAndTime.split(separator: ",")
        let dateAlone = arr[0]
        let dateForPassing = String(dateAlone)
        
        let isFoundTuple = FirebaseHelper.isFound(eventDateAndTime: dateForPassing, djName: dj?.djName, eventSnapshot: self.eventSnapshot)
        
        if isFoundTuple.0 { //Check if there is an event at this time and not editing event
            self.stopAnimating()
            presentAlert(title: "Skrt!", error: "It appears as though something is already scheduled on this day.")
        }
        else {
            //Generate new key inside EventList node and return it
            let key = self.refEventList.childByAutoId().key
            if let djName = self.dj?.djName, let djUID = self.dj?.uid, let location = eventLocation.text, let startDate = eventToAddDateAndTime.text, let endDate = endingTime.text, let lat = strLat, let long = strLong {
                //remove past songlist here
                self.songlistsToBeDeleted.append(djUID)
                let ref2 = Database.database().reference().child("SongList")
                if !self.songlistsToBeDeleted.isEmpty {
                    for djID in songlistsToBeDeleted {
                        //print("DELETING LIST!")
                        ref2.child(djID).setValue(nil)
                    }
                }
                FirebaseHelper.addEventWithKey(key: key!, dj: dj, location: location, startDate: startDate, endDate: endDate, lat: lat, long: long, refEventList: self.refEventList)
                self.stopAnimating()
                presentAlertForAdd(title: "Success!", error: "We have added your event to the calendar!")
            }
            //addEventWithKey(key: key!)
        }
    }
    
    func presentAlert(title: String, error: String) {
        let alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.alert)
        doAlertColoring(alertController: alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: { action in
            self.dismissAlert()
        }))
        self.present(alert, animated: true, completion: nil)
        return
    }
    
    func presentAlertForAdd(title: String, error: String) {
        let alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.alert)
        doAlertColoring(alertController: alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: { action in
            self.dismissAlertForAdd()
        }))
        self.present(alert, animated: true, completion: nil)
        return
    }
    
    func dismissAlertForAdd() {
        self.navigationController?.popViewController(animated: true)
        eventToAddDateAndTime.text = ""
        endingTime.text = ""
        eventLocation.text = ""
        self.view.endEditing(true)
    }
    
    func dismissAlert() {
        self.navigationController?.popViewController(animated: true)
        //eventToAddDateAndTime.text = ""
        //endingTime.text = ""
        self.view.endEditing(true)
    }
    
    func dismissAlertForLocation(){
        self.navigationController?.popViewController(animated: true)
        self.view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension addEventViewController: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        //print("Place coordinate: \(place.coordinate)")
        strLong = place.coordinate.longitude.description
        strLat = place.coordinate.latitude.description
        let parentView = parent as! DJcustomTabBarControllerViewController
        
        for theViewIwant in parentView.viewControllers!{
            if let v3 = theViewIwant as? addEventViewController{
                v3.dj = dj
                v3.eventLocation.text = place.name
            }
        }
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

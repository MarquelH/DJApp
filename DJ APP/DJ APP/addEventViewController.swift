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

class addEventViewController: UIViewController {

    var eventSnapshot: [String: AnyObject]?
    
    var dj: UserDJ?
    var refEventList: DatabaseReference!
    var startingTime = "DummyValue"
    var doWeHaveDJ = false
    var originalView: CGFloat?
    var strLong: String?
    var strLat: String?
    var isEditingEvent: Bool = false
    var currentEvent: Event? 
    
    @IBOutlet weak var endingTime: UITextField!
    @IBOutlet weak var eventLocation: UITextField!
    @IBOutlet weak var eventToAddDateAndTime: UITextField!
    
    let toolbar: UIToolbar = {
        let tb = UIToolbar()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(handleToolBarDone))
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(handleToolBarCancel))
        tb.barTintColor = UIColor.black
        tb.barStyle = .default
        tb.isTranslucent = true
        tb.tintColor = UIColor(red: 75/255, green: 215/255, blue: 100/255, alpha: 1)
        tb.sizeToFit()
        tb.setItems([cancelButton, spacer, doneButton], animated: true)
        return tb
    }()
    
    func handleToolBarDone() {
        self.view.endEditing(true)
    }
    
    func handleToolBarCancel() {
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
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
    
    @IBAction func picker2Config(_ sender: UITextView) {
        datePickerView2.datePickerMode = UIDatePickerMode.dateAndTime
        datePickerView2.minimumDate = datePickerView1.date
        sender.inputView = datePickerView2
        sender.inputAccessoryView = toolbar
        datePickerView2.minuteInterval = 15
        datePickerView2.addTarget(self, action: #selector(datePickerChanged), for: UIControlEvents.valueChanged)
    }
    
    
    
    
    func datePickerChanged(_ sender: UIDatePicker){
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.short
        
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let _ = dj?.uid {
            print("DJ has uid")
            doWeHaveDJ = true
            refEventList = Database.database().reference().child("Events")
        }
        else {
            doWeHaveDJ = false
            print("DJ does not have uid")
        }
        getEventSnapshot()
    }
    
    func fillInLabels(startTime: String, endTime: String, location: String) {
        endingTime.text = endTime
        eventLocation.text = location
        eventToAddDateAndTime.text = startTime
    }
    
    func getEventSnapshot(){
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
    
    func isFound(eventDateAndTime: String) ->(found: Bool, key: String, realDate: String) {
        if let workingSnap = self.eventSnapshot {
            for (k,v) in workingSnap {
                
                if let dateAndTime = v["StartDateAndTime"] as? String{
                    let dateAloneArray = dateAndTime.split(separator: ",")
                    let dateForComparison = dateAloneArray[0]
                    let realDate = String(dateForComparison)
                    let theName = v["DJ Name"] as! String
                    if theName == dj?.djName{
                    if realDate == eventDateAndTime {
                        return (true, k, realDate)
                    }
                    }
                }
            }
        }
        else {
            print("Snap did not load")
        }
        return (false, "","")
    }
    
    func presentCalendar(){
        let storyboard = UIStoryboard(name: "ScehdulingStoryboard", bundle:nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "scheduleView") as! scheduleViewController
        controller.dj = dj
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func addEvent(_ sender: Any) {
        handleEntry()
    }
    
    func presentAlert(title: String, error: String) {
        let alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: { action in
            self.dismissAlert()
        }))
        self.present(alert, animated: true, completion: nil)
        return
    }
    
    func handleEntry(){
        guard let dateAndTime = eventToAddDateAndTime.text, dateAndTime != "", let endingDateAndTime = endingTime.text, endingDateAndTime != "", let location = eventLocation.text, location != "" else {
            presentAlert(title: "Skrt!", error: "Please enter a valid date and time range.")
            return
        }
        
        //What are you using these for?
        let arr = dateAndTime.split(separator: ",")
        let dateAlone = arr[0]
        let dateForPassing = String(dateAlone)
        
        let isFoundTuple = isFound(eventDateAndTime: dateForPassing)
        
        if isFoundTuple.0 && !isEditingEvent{ //Check if there is an event at this time and not editing event
            presentAlert(title: "Skrt", error: "It appears as though something is already scheduled on this day.")
        }
        else{
            //Updating existing event
            if isEditing {
                addEventWithKey(key: isFoundTuple.1)
            }
            //New Event
            else {
                //Generate new key inside EventList node and return it
                let key = self.refEventList.childByAutoId().key
                addEventWithKey(key: key)
            }
        }
    }
    
    //Updates event or adds new event based up on the key passed in.
    func addEventWithKey(key: String) {
        if let djName = self.dj?.djName, let djUID = self.dj?.uid, let location = self.eventLocation.text, let startDate = self.eventToAddDateAndTime.text, let endDate = self.endingTime.text, let lat = strLat, let long = strLong {
            
            let event = ["id": key, "location":location , "StartDateAndTime": startDate,"DjID":djUID,
                         "EndDateAndTime":endDate,"Latitude Coordinates": lat,"Longitude Coordinates":long,"DJ Name":djName] as [String : Any]
            
            self.refEventList.child(key).setValue(event)
            presentAlert(title: "Success", error: "We have added your event to the calendar!")
            
        }
        else {
            print("One of the fields is not present. ")
        }
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
        eventToAddDateAndTime.text = ""
        endingTime.text = ""
        self.view.endEditing(true)
    }
    
    func dismissAlertForLocation(){
        self.navigationController?.popViewController(animated: true)
        self.view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension addEventViewController: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        //print("Place name: \(place.name)")
        //print("Place address: \(place.formattedAddress)")
        //print("Place attributions: \(place.attributions)")
        print("Place coordinate: \(place.coordinate)")
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
        print("Error: ", error.localizedDescription)
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

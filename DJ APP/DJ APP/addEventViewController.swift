//
//  addEventViewController.swift
//  DJ APP
//
//  Created by Marquel Hendricks on 12/24/17.
//  Copyright © 2017 Marquel and Micajuine App Team. All rights reserved.
//

import UIKit
import Firebase

class addEventViewController: UIViewController {

    var eventSnapshot: [String: AnyObject]?
    
    var dj: UserDJ?
    var refEventList: DatabaseReference!
    var startingTime = "DummyValue"
    var doWeHaveDJ = false
    var originalView: CGFloat?
    
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
        if let uidKey = dj?.uid {
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
                    
                    if realDate == eventDateAndTime {
                        return (true, k, realDate)
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
    
    
    func handleEntry(){
        guard let dateAndTime = eventToAddDateAndTime.text, dateAndTime != "" else {
            let alert = UIAlertController(title: "Skrt!", message: "Please enter a valid date and time range.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: { action in
                self.dismissAlert()
            }))
            self.present(alert, animated: true, completion: nil)
            print("date & time is empty, or snap did not load")
            return
        }
        
        guard let endingDateAndTime = endingTime.text, endingDateAndTime != "" else {
            let alert = UIAlertController(title: "Skrt!", message: "Please enter a valid date and time range.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: { action in
                self.dismissAlert()
            }))
            self.present(alert, animated: true, completion: nil)
            print("date & time is empty, or snap did not load")
            return
        }
        
        guard let location = eventLocation.text, location != "" else {
            let alert = UIAlertController(title: "Skrt!", message: "Please enter a venue.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: { action in
                self.dismissAlert()
            }))
            self.present(alert, animated: true, completion: nil)
            print("location is empty, or snap did not load")
            return
        }
        
        let arr = dateAndTime.split(separator: ",")
        let dateAlone = arr[0]
        let dateForPassing = String(dateAlone)
        
        let isFoundTuple = isFound(eventDateAndTime: dateForPassing)
        
        if isFoundTuple.0 { //Checking for event at same date and time
            let alert = UIAlertController(title: "Oops!", message: "It appears as though something is already scheduled on this day.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: { action in
                self.dismissAlert()
            }))
            self.present(alert, animated: true, completion: nil)
            print("something is already scheduled at that time")
            return
        }
        else{
        //Generate new key inside EventList node and return it
        let key = self.refEventList.childByAutoId().key
        print("key is: \(key)\n")

            if doWeHaveDJ {
            let event = ["id": key, "location":self.eventLocation.text!, "StartDateAndTime":self.eventToAddDateAndTime.text!,"DjID":dj?.uid,
                         "EndDateAndTime":self.endingTime.text!] as [String : Any]
                    
                self.refEventList.child(key).setValue(event)
                let alert = UIAlertController(title: "Success", message: "We have added your event to the calendar!", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: { action in
                    self.dismissAlertForAdd()
                }))
                self.present(alert, animated: true, completion: nil)
            }
            }
    }
    
    func dismissAlertForAdd(){
        self.navigationController?.popViewController(animated: true)
        eventToAddDateAndTime.text = ""
        endingTime.text = ""
        eventLocation.text = ""
        self.view.endEditing(true)
    }
    
    func dismissAlert(){
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

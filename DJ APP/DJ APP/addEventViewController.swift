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
        //self.view.backgroundColor = UIColor.gray
        
        if let uidKey = dj?.uid {
            print("DJ has uid")
            doWeHaveDJ = true
            refEventList = Database.database().reference().child("Events")
        }
        else {
            doWeHaveDJ = false
            print("DJ does not have uid")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
    
    func isFound(eventDateAndTime: String) ->(found: Bool, key: String) {
        if let workingSnap = self.eventSnapshot {
            for (k,v) in workingSnap {
                if let dateAndTime = v["DateAndTime"] as? String, dateAndTime == eventDateAndTime {
                    return (true, k)
                }
                
            }
        }
        else {
            print("Guest Snap did not load")
        }
        return (false, "")
    }
    
    func presentCalendar(){
    let storyboard = UIStoryboard(name: "ScehdulingStoryboard", bundle:nil)
    let controller = storyboard.instantiateViewController(withIdentifier: "scheduleView") as! scheduleViewController
    controller.dj = dj
    self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func addEvent(_ sender: Any) {
        handleEntry()
        presentCalendar()
    }
    
    @IBAction func cancelEventAdd(_ sender: Any) {
        presentCalendar()
    }
    
    
    func handleEntry(){
        guard let dateAndTime = eventToAddDateAndTime.text, dateAndTime != "" else {
            print("date & time is empty, or snap did not load")
            return
        }
        
        guard let location = eventLocation.text, location != "" else {
            print("location is empty, or snap did not load")
            return
        }
        
        let isFoundTuple = isFound(eventDateAndTime: dateAndTime)
        if isFoundTuple.0 { //Checking for event at same date and time
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
            }
            }
        }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

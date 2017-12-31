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
    
    @IBOutlet weak var eventLocation: UITextField!
    @IBOutlet weak var eventToAddDateAndTime: UITextField!
    @IBOutlet weak var eventDatePicker: UIDatePicker!
    
    @IBAction func pickerConfig(_ sender: UITextView) {
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = .date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(datePickerChanged), for: .valueChanged)
    }
    
    
    
    
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.short
        
        let strDate = dateFormatter.string(from: eventDatePicker.date)
        eventToAddDateAndTime.text = strDate
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.view.backgroundColor = UIColor.gray
        
        if let uidKey = dj?.uid {
            print("DJ has uid")
            refEventList = Database.database().reference().child("Events").child(uidKey)
        }
        else {
            print("DJ does not have uid")
        }
        
        // Do any additional setup after loading the view.
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

                    let event = ["id": key, "location":self.eventLocation.text!, "DateAndTime":self.eventToAddDateAndTime.text!] as [String : Any]
                    
                    self.refEventList.child(key).setValue(event)
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

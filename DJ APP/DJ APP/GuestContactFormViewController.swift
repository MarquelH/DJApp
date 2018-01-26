//
//  GuestContactFormViewController.swift
//  DJ APP
//
//  Created by Marquel Hendricks on 1/19/18.
//  Copyright © 2018 Marquel and Micajuine App Team. All rights reserved.
//

import UIKit
import Firebase

class GuestContactFormViewController: UIViewController, UITextFieldDelegate {

    var dj: UserDJ?
    var guestID: String?
    var ref: DatabaseReference!
    var messages = [Message]()
    var value = [String : Any]()
    
    @IBOutlet weak var djContactFormLabel: UILabel!
    @IBOutlet weak var guestName: UITextField!
    @IBOutlet weak var guestPhoneNumber: UITextField!
    @IBOutlet weak var guestMessage: UITextView!
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        handleSubmit()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    
    
    func handleSubmit() {
        print("Send was hit")
        //push to database
        let timeStamp = Int(Date().timeIntervalSince1970)
        
        if let message = guestMessage.text, let id = guestID, let uid = dj?.uid, let guestNameForDB = guestName.text {

            if guestPhoneNumber.text != "", message != "",guestNameForDB != "" {
                value = ["message": message, "timeStamp": timeStamp, "djUID":uid, "guestID": id,"guestName": guestNameForDB,"Guest Phone": guestPhoneNumber.text!] as [String : Any]
                ref.childByAutoId().setValue(value)
            }
            else if guestPhoneNumber.text == "", message != "", guestNameForDB != ""{
                value = ["message": message, "timeStamp": timeStamp, "djUID":uid, "guestID": id,"guestName": guestNameForDB,"Guest Phone": "No Number Given"] as [String : Any]
                ref.childByAutoId().setValue(value)
            }
            else{
                let alert = UIAlertController(title: "Skrt!", message: "You must fill out at least the name and message fields!", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in
                    self.navigationController?.popViewController(animated: true)
                }))
                
                self.present(alert, animated: true, completion: nil)
                return
            }
        }
        else {
            print("DJ or guest not present")
        }
        guestMessage.text = ""
        guestName.text = ""
        guestPhoneNumber.text = ""
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLabel()
        // Do any additional setup after loading the view.
        guestName.delegate = self
        guestPhoneNumber.delegate = self
        guestMessage.delegate = self
    }
    
    func setupLabel(){
        djContactFormLabel.adjustsFontSizeToFitWidth = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let uid = dj?.uid, let id = guestID {
            ref = Database.database().reference().child("messages").child(uid)
            
            //messagesRef = Database.database().reference().child("messages").child(id)
        }
        else {
            print("View will appear & guestID or Dj not passed in")
        }
        UIApplication.shared.statusBarStyle = .lightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension GuestContactFormViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}

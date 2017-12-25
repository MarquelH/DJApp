//
//  addEventViewController.swift
//  DJ APP
//
//  Created by Marquel Hendricks on 12/24/17.
//  Copyright © 2017 Marquel and Micajuine App Team. All rights reserved.
//

import UIKit
import Firebase

class addEventViewController: UIViewController, UIPickerViewDelegate, UIScrollViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var dj: UserDJ?
    var refEventList: DatabaseReference!
    
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var addImageButton: UIButton!
    
    @IBOutlet weak var eventLocation: UITextField!
    @IBOutlet weak var eventToAddDateAndTime: UITextField!
    @IBOutlet weak var eventDatePicker: UIDatePicker!
    
    @IBAction func addImageButtonTapped(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImage: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImage = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImage = originalImage
        }
        
        if let selectedImageFromPicker = selectedImage {
            eventImage.image = selectedImageFromPicker
            addImageButton.setTitle("Edit\nPhoto", for: .normal)
            let headphonesColor = UIColor(red: 214/255, green: 29/255, blue: 1, alpha:1.0)
            addImageButton.setTitleColor(headphonesColor, for: .normal)
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func datePickerChanged(_ sender: Any) {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.short
        
        let strDate = dateFormatter.string(from: eventDatePicker.date)
        eventToAddDateAndTime.text = strDate
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleEntry))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 214/255, green: 29/255, blue: 1, alpha:1.0)
        // Do any additional setup after loading the view.
    }
    
    
    func handleEntry(){
        print("Added to list \n")
        //Generate new key inside EventList node and return it
        let key = self.refEventList.childByAutoId().key
        print("key is: \(key)\n")
        
        let imageName = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("\(imageName).jpg")
        
        
        //Image Compression for optimization
        if let EVENTSImage = self.eventImage.image, let uploadData = UIImageJPEGRepresentation(EVENTSImage, 0.075) {
            
            
            storageRef.putData(uploadData, metadata: nil, completion: {
                (metadata, error) in
                if let error = error{
                    print(error.localizedDescription)
                    return
                }
                
                if let eventImageUrl = metadata?.downloadURL()?.absoluteString{
                    let event = ["id": key, "location":self.eventLocation.text!, "DateAndTime":self.eventToAddDateAndTime.text!,
                                 "eventPicURL":eventImageUrl] as [String : Any]
                    
                    self.refEventList.child(key).setValue(event)
                }
    })
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

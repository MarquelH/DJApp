//
//  DJSideProfileViewController.swift
//  DJ APP
//
//  Created by Marquel Hendricks on 1/3/18.
//  Copyright © 2018 Marquel and Micajuine App Team. All rights reserved.
//

import UIKit
import Firebase

class DJSideProfileViewController: UIViewController, UIScrollViewDelegate, UIImagePickerControllerDelegate,
 UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    

    var dj: UserDJ?
    let ref = Database.database().reference()
    
    let genre: [String] = ["Rap", "Hip-Hop", "Reggae", "R&B", "EDM", "House", "Rock", "Country", "Folk", "Indie", "Soul", "Funk", "Jazz", "Alternative", "Pop"]
    
    lazy var genrePickView: UIPickerView = {
        let gp = UIPickerView()
        gp.dataSource = self
        gp.delegate = self
        gp.tintColor = UIColor(red: 214/255, green: 29/255, blue: 1, alpha:1.0)
        return gp
    }()
    
    lazy var agePickView: UIPickerView = {
        let ap = UIPickerView()
        ap.dataSource = self
        ap.delegate = self
        ap.tintColor = UIColor(red: 214/255, green: 29/255, blue: 1, alpha:1.0)
        return ap
    }()
    
    let toolbar: UIToolbar = {
        let tb = UIToolbar()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(handleToolBarDone))
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(handleToolBarCancel))
        tb.barTintColor = UIColor.white
        tb.barStyle = .default
        tb.isTranslucent = true
        tb.tintColor = UIColor(red: 75/255, green: 215/255, blue: 100/255, alpha: 1)
        tb.sizeToFit()
        tb.setItems([cancelButton, spacer, doneButton], animated: true)
        return tb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let name = dj?.uid{
            print("We Have a DJ")
        }
        else{
            print("No DJ")
        }
        
        placeDJImageInView()
        placeDJNameInLabel()
        setupDJInfo()
        setButtonShapes()
    }
    
    lazy var profilePic: ProfileImageView = {
        let pp = ProfileImageView()
        return pp
    }()
    
    @IBOutlet weak var djProfileImage: UIImageView!
    @IBOutlet weak var djNameLabel: UILabel!
    @IBOutlet weak var editPhotoBtn: UIButton!
    @IBOutlet weak var hometownTextField: UITextField!
    @IBOutlet weak var DJNameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var genreTextField: UITextField!
    @IBOutlet weak var twitterInstagramTextField: UITextField!
    
    @IBOutlet weak var saveChangesBtn: UIButton!
    @IBOutlet weak var cancelChangesBtn: UIButton!
    
    @IBAction func hometownEditingDone(_ sender: Any) {
        endEditing()
    }
    @IBAction func djNameEditingDone(_ sender: Any) {
        endEditing()
    }
    @IBAction func twitterEditingDone(_ sender: Any) {
        endEditing()
    }
    
    
    func endEditing (){
        self.view.endEditing(true)
    }
    @IBAction func saveChangesBtnPressed(_ sender: Any) {
        if hometownTextField.text != "", DJNameTextField.text != "", ageTextField.text != "",
            genreTextField.text != "", twitterInstagramTextField.text != "" {
            
            guard let uid = dj?.uid, let age = Int(ageTextField.text!), let genre = genreTextField.text, let name = DJNameTextField.text, let hometown = hometownTextField.text, let twitter = twitterInstagramTextField.text, let profileUrl = dj?.profilePicURL else {
                print("Not valid args passed in.")
                return
            }
            
            let imageName = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("\(imageName).jpg")
            
            //Image compression for optimization
            if let profileImage = self.djProfileImage.image, let uploadData = UIImageJPEGRepresentation(profileImage, 0.075) {
                
                
                storageRef.putData(uploadData, metadata: nil, completion: {
                    (metadata, error) in
                    if let error = error{
                        print(error.localizedDescription)
                        return
                    }
                    
                    if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                        
                        self.ref.child("users").child(uid).updateChildValues(["djName":name, "hometown":hometown, "age":age,
                                                                         "genre":genre, "currentLocation": "Somewhere","profilePicURL": profileImageUrl, "twitterOrInstagram":twitter])
                        
                        let alert = UIAlertController(title: "Success", message: "We have updated your info \(name)!", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.cancel, handler: { action in
                            self.changesSaved()
                        }))
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                })
            }
            
        }
    }
    
    func changesSaved() {
        self.dismiss(animated: true, completion: nil)
        presentRootView()
    }
    
    @IBAction func cancelChangesBtnPressed(_ sender: Any) {
        presentRootView()
    }
    
    func presentRootView(){
        let djRootViewController = DJRootViewController()
        djRootViewController.dj = dj
        
        let djNavController = UINavigationController(rootViewController: djRootViewController)
        self.present(djNavController, animated: true, completion: nil)
    }
    
    
    
    func setButtonShapes(){
        saveChangesBtn.layer.cornerRadius = 15
        cancelChangesBtn.layer.cornerRadius = 15
    }
    
    @IBAction func editPhotoPressed(_ sender: Any) {
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
            djProfileImage.image = selectedImageFromPicker
        }
        dismiss(animated: true, completion: nil)
    }
    
    func placeDJNameInLabel(){
        if let djName = dj?.djName {
            djNameLabel.font = UIFont(name: "SudegnakNo2", size: 60)
            djNameLabel.text = djName
        }
        else{
            print("No DJ Name")
        }
    }
    
    func setupDJInfo(){
        if let name = dj?.djName, let hometown = dj?.hometown, let profileUrl = dj?.profilePicURL, let age = dj?.age, let genre = dj?.genre, let twitter = dj?.twitter{
            hometownTextField.text = hometown
            DJNameTextField.text = name
            ageTextField.text = "\(age)"
            genreTextField.text = genre
            twitterInstagramTextField.text = twitter
        }
        else{
            print("No DJ Info")
        }
    }
    
    func placeDJImageInView(){
        if let profileURL = dj?.profilePicURL{
            profilePic.loadImageWithChachfromUrl(urlString: profileURL)
            djProfileImage.contentMode = .scaleAspectFill
            djProfileImage.layer.cornerRadius = 60
            djProfileImage.layer.masksToBounds = true
            djProfileImage.layer.borderWidth = 1.5
            djProfileImage.layer.borderColor = UIColor(red: 214/255, green: 29/255, blue: 1, alpha:0.9).cgColor
            djProfileImage.clipsToBounds = true
            djProfileImage.translatesAutoresizingMaskIntoConstraints = false
            djProfileImage.image = profilePic.image
        }
        else{
            print("No Image to place")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Configuring pickers for age and genre
    var datePickerView1:UIPickerView = UIPickerView()
    var datePickerView2:UIPickerView = UIPickerView()
    
    @IBAction func genrePickerConfig(_ sender: UITextView) {
        sender.inputView = genrePickView
        sender.inputAccessoryView = toolbar
    }
    
    @IBAction func agePickerConfig(_ sender: UITextView) {
        sender.inputView = agePickView
        sender.inputAccessoryView = toolbar
    }
    
    
    // returns the number of 'columns' to display.
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // returns the # of rows in each component..
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView == agePickView) {
            return 51-16
        }
        else {
            return genre.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView == agePickView) {
            return "\(row + 16)"        }
        else {
            return genre[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (pickerView == agePickView) {
            ageTextField.text = "\(row + 16)"
        }
        else {
            genreTextField.text = "\(genre[row])"
        }
    }
    
    
    func handleToolBarDone() {
        self.view.endEditing(true)
    }
    
    func handleToolBarCancel() {
        if (ageTextField.isEditing) {
            ageTextField.text = ""
        }
        else if (genreTextField.isEditing)  {
            genreTextField.text = ""
        }
        self.view.endEditing(true)
    }

}

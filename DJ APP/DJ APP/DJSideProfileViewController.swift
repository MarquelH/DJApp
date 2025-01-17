//
//  DJSideProfileViewController.swift
//  DJ APP
//
//  Created by Marquel Hendricks on 1/3/18.
//  Copyright © 2018 Marquel and Micajuine App Team. All rights reserved.
//
import UIKit
import Firebase
import GooglePlaces
import NVActivityIndicatorView

class DJSideProfileViewController: UIViewController, UIScrollViewDelegate, UIImagePickerControllerDelegate,
 UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, NVActivityIndicatorViewable {
    

    var dj: UserDJ?
    let ref = Database.database().reference()
    
    @IBAction func tapGestureRecTapped(_ sender: UITapGestureRecognizer) {
        //print("Firing off")
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Edit Profile Picture", style: .default) { action in
            //print("Fired off edit function")
            self.fireOffImagePicker()
        })
        
        alert.addAction(UIAlertAction(title: "View Current Profile Picture", style: .default) { action in
            //print("Fired off ")
            self.tappedActions(sender)
            
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { action in
            self.popAlertOff()
        })
        
        present(alert, animated: true)
    }
    
    
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
            //print("We Have a DJ")
        }
        else{
            //print("No DJ")
        }
        
        placeDJNameInLabel()
        setupDJInfo()
        setButtonShapes()
        placeDJImageInView()
        self.DJNameTextField.delegate = self
        self.twitterInstagramTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setFonts()
    }
    
    
    //override func viewWillDisappear(_ animated: Bool) {
    //    UIApplication.shared.statusBarStyle = .default
  //  }
    
    lazy var profilePic: ProfileImageView = {
        let pp = ProfileImageView()
        pp.contentMode = .scaleAspectFill
        pp.layer.cornerRadius = 30
        pp.layer.masksToBounds = true
        pp.clipsToBounds = true
        pp.layer.borderWidth = 1.0
        pp.layer.borderColor = UIColor.black.cgColor
        pp.translatesAutoresizingMaskIntoConstraints = false
        return pp
    }()
    
    @IBOutlet weak var djProfileImage: ProfileImageView!
    @IBOutlet weak var djNameLabel: UILabel!
    @IBOutlet weak var editPhotoBtn: UIButton!
    @IBOutlet weak var hometownTextField: UITextField!
    @IBOutlet weak var DJNameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var genreTextField: UITextField!
    @IBOutlet weak var twitterInstagramTextField: UITextField!
    @IBOutlet weak var hometownLabel: UILabel!
    @IBOutlet weak var djLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var twitterInstagramLabel: UILabel!
    
    
    @IBOutlet weak var saveChangesBtn: UIButton!
    @IBOutlet weak var cancelChangesBtn: UIButton!
    
    
    @IBAction func hometownEditingBegan(_ sender: Any) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        autocompleteController.modalPresentationStyle = .fullScreen
        present(autocompleteController, animated: true, completion: nil)
    }
    
    func setFonts() {
        djNameLabel.font = UIFont(name: "BebasNeue-Regular", size: 55)
        hometownLabel.font = UIFont(name: "BebasNeue-Regular", size: 18)
        djLabel.font = UIFont(name: "BebasNeue-Regular", size: 18)
        ageLabel.font = UIFont(name: "BebasNeue-Regular", size: 18)
        genreLabel.font = UIFont(name: "BebasNeue-Regular", size: 18)
        twitterInstagramLabel.font = UIFont(name: "BebasNeue-Regular", size: 18)
        hometownTextField.font = UIFont(name: "BebasNeue-Regular", size: 18)
        DJNameTextField.font = UIFont(name: "BebasNeue-Regular", size: 18)
        ageTextField.font = UIFont(name: "BebasNeue-Regular", size: 18)
        genreTextField.font = UIFont(name: "BebasNeue-Regular", size: 18)
        twitterInstagramTextField.font = UIFont(name: "BebasNeue-Regular", size: 18)
        saveChangesBtn.titleLabel?.font = UIFont(name: "BebasNeue-Regular", size: 17)
        cancelChangesBtn.titleLabel?.font = UIFont(name: "BebasNeue-Regular", size: 17)
    }
    
    @IBAction func djNameEditingDone(_ sender: Any) {
        endEditing()
    }
    @IBAction func twitterEditingDone(_ sender: Any) {
        endEditing()
    }
    
    
    func endEditing(){
        self.view.endEditing(true)
    }
    
    @IBAction func saveChangesBtnPressed(_ sender: Any) {
        startAnimating()
        //print("HELLO FROM THIS METHOD")
        if hometownTextField.text != "", DJNameTextField.text != "", ageTextField.text != "",
            genreTextField.text != "" {
            
            guard let uid = dj?.uid, let age = Int(ageTextField.text!), let genre = genreTextField.text, let name = DJNameTextField.text, let hometown = hometownTextField.text, let twitter = twitterInstagramTextField.text, let profileUrl = dj?.profilePicURL else {
                //print("Not valid args passed in.")
                return
            }
            
            let imageName = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("\(imageName).jpg")
            
            //Image compression for optimization
            if let profileImage = self.djProfileImage.image, let uploadData = UIImageJPEGRepresentation(profileImage, 0.075) {
                
                storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                    if let error = error{
                        //print(error.localizedDescription)
                        self.stopAnimating()
                        let alert = UIAlertController(title: "Sorry!", message: "There was an issue saving your changes :(", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { action in
                            self.popAlertOff()
                        }))
                        self.present(alert,animated: true, completion: nil)
                        return
                    }
                    storageRef.downloadURL { (url, error) in
                        if let error = error{
                            //print(error.localizedDescription)
                            self.stopAnimating()
                            let alert = UIAlertController(title: "Sorry!", message: "There was an issue saving your changes :(", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { action in
                                self.popAlertOff()
                            }))
                            self.present(alert, animated: true, completion: nil)
                            return
                        }
                        let profileImageUrl = url?.absoluteString
                        if profileImageUrl == nil {
                            //print("URL was null!")
                            self.stopAnimating()
                            let alert = UIAlertController(title: "Sorry!", message: "There was an issue saving your changes :(", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { action in
                                self.popAlertOff()
                            }))
                            self.present(alert, animated: true, completion: nil)
                            return
                        }
                    self.ref.child("users").child(uid).updateChildValues(["djName":name, "hometown":hometown, "age":age,
                                                                          "genre":genre, "currentLocation": "Somewhere","profilePicURL": profileImageUrl, "twitterOrInstagram":twitter])
                    self.stopAnimating()
                    let alert = UIAlertController(title: "Success", message: "We have updated your info \(name)!", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.default, handler: { action in
                        self.popAlertOff()
                    }))
                    self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    func popAlertOff() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func popAlertOffAndResetTextFields() {
        setupDJInfo()
        placeDJImageInView()
        popAlertOff()
    }
    
    @IBAction func cancelChangesBtnPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Oh No!", message: "Are you sure you want to cancel your changes?!", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.destructive, handler: { action in
            self.popAlertOffAndResetTextFields()
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default
            , handler: { action in
            self.popAlertOff()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    func setButtonShapes(){
        saveChangesBtn.layer.cornerRadius = 15
        cancelChangesBtn.layer.cornerRadius = 15
    }
    
func tappedActions(_ sender: UITapGestureRecognizer){
    let tappedImage = sender.view as! UIImageView
    let newImageView = UIImageView(image: tappedImage.image)
    newImageView.frame = UIScreen.main.bounds
    newImageView.backgroundColor = .black
    newImageView.contentMode = .scaleAspectFit
    newImageView.isUserInteractionEnabled = true
    let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
    newImageView.addGestureRecognizer(tap)
    self.view.addSubview(newImageView)
    self.navigationController?.isNavigationBarHidden = true
    self.tabBarController?.tabBar.isHidden = true
}

@objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
    self.navigationController?.isNavigationBarHidden = false
    self.tabBarController?.tabBar.isHidden = false
    sender.view?.removeFromSuperview()
}
    
    
    
    func fireOffImagePicker (){
        //print("FIRING OFF IMAGE PICKER")
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.modalPresentationStyle = .fullScreen
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
            djNameLabel.text = djName
            djNameLabel.adjustsFontSizeToFitWidth = true
        }
        else{
            //print("No DJ Name")
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
            //print("No DJ Info")
        }
    }
    
    func placeDJImageInView(){
        if let profileURL = dj?.profilePicURL{
            djProfileImage.contentMode = .scaleAspectFill
            djProfileImage.layer.cornerRadius = 20
            djProfileImage.layer.masksToBounds = true
            djProfileImage.clipsToBounds = true
            //djProfileImage.layer.borderWidth = 1.0
            //djProfileImage.layer.borderColor = UIColor(red: 214/255, green: 29/255, blue: 1, alpha:1.0).cgColor
            djProfileImage.translatesAutoresizingMaskIntoConstraints = false
            djProfileImage.loadImageWithChachfromUrl(urlString: profileURL)
        }
        else{
            //print("No Image to place")
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
    
    
    @objc func handleToolBarDone() {
        self.view.endEditing(true)
    }
    
    @objc func handleToolBarCancel() {
        if (ageTextField.isEditing) {
            ageTextField.text = ""
        }
        else if (genreTextField.isEditing)  {
            genreTextField.text = ""
        }
        self.view.endEditing(true)
    }

}

extension DJSideProfileViewController: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        hometownTextField.text = place.name
        dismiss(animated: true, completion: nil)
        endEditing()
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

//
//  RegisterController.swift
//  DJ APP
//
//  Created by arturo ho on 8/28/17.
//  Copyright © 2017 Marquel and Micajuine App Team. All rights reserved.
//

import UIKit
import Firebase

class AddInfoController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIScrollViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    var loginController: LoginController?
    var originalView: CGFloat?
    var username: String?
    var password: String?
    
    let genre: [String] = ["Rap", "Rock", "Country", "Folk", "Indie", "Reggee", "EDM", "House", "R&B", "Soul", "Funk", "Jazz", "Alternative", "Pop"]
    
    lazy var profilePic: UIImageView = {
        let pp = UIImageView()
        pp.alpha = 0.85
        pp.image = UIImage(named: "usernameIcon")
        pp.contentMode = .scaleAspectFill
        pp.layer.cornerRadius = 60
        pp.clipsToBounds = true
        pp.layer.borderWidth = 1.0
        pp.layer.borderColor = UIColor.black.cgColor
        pp.translatesAutoresizingMaskIntoConstraints = false
        //pp.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleImageSelection)))
        return pp
    }()
    
    let addPhoto: UIButton = {
        let ap = UIButton()
        let lightblue = UIColor(colorLiteralRed: 94/255, green: 211/255, blue: 237/255, alpha: 1)
        ap.setTitleColor(lightblue, for: .normal)
        ap.setTitleColor(UIColor.white, for: .highlighted)
        ap.titleLabel?.lineBreakMode = .byWordWrapping
        ap.titleLabel?.textAlignment = .center
        ap.titleLabel?.font = ap.titleLabel?.font.withSize(30)
        ap.setTitle("Add\nphoto", for: .normal)
        ap.translatesAutoresizingMaskIntoConstraints = false
        ap.addTarget(self, action: #selector(handlePicTapped), for: .touchUpInside)
        return ap
    }()
    
    let hometownLabel: UILabel = {
        let ht = UILabel()
        ht.textColor = UIColor.gray
        ht.text = "Hometown:"
        ht.translatesAutoresizingMaskIntoConstraints = false
        return ht
    }()
    
    let hometownTextField: UITextField = {
        let htf = UITextField()
        htf.textColor = UIColor.white
        htf.clearButtonMode = .whileEditing
        htf.addTarget(self, action: #selector(resetView), for: .editingDidBegin)
        htf.translatesAutoresizingMaskIntoConstraints = false
        return htf
    }()
    
    let hometownSep: UIView = {
        let hs = UIView()
        hs.backgroundColor = UIColor.lightGray
        hs.translatesAutoresizingMaskIntoConstraints = false
        return hs
    }()
    
    let djNameLabel: UILabel = {
        let dl = UILabel()
        dl.textColor = UIColor.gray
        dl.text = "DJ Name:"
        dl.translatesAutoresizingMaskIntoConstraints = false
        return dl
    }()
    
    let djNameTextField: UITextField = {
        let dtf = UITextField()
        dtf.textColor = UIColor.white
        dtf.clearButtonMode = .whileEditing
        dtf.addTarget(self, action: #selector(resetView), for: .editingDidBegin)
        dtf.translatesAutoresizingMaskIntoConstraints = false
        return dtf
    }()
    
    let djSep: UIView = {
        let ds = UIView()
        ds.backgroundColor = UIColor.lightGray
        ds.translatesAutoresizingMaskIntoConstraints = false
        return ds
    }()
    
    let ageLabel: UILabel = {
        let al = UILabel()
        al.textColor = UIColor.gray
        al.text = "Age:"
        al.translatesAutoresizingMaskIntoConstraints = false
        return al
    }()
    
    let ageTextField: UITextField = {
        let atf = UITextField()
        atf.textColor = UIColor.white
        atf.clearButtonMode = .whileEditing
        atf.translatesAutoresizingMaskIntoConstraints = false
        atf.addTarget(self, action: #selector(ageClicked), for: UIControlEvents.editingDidBegin)
        return atf
    }()
    
    let ageSep: UIView = {
        let aS = UIView()
        aS.backgroundColor = UIColor.lightGray
        aS.translatesAutoresizingMaskIntoConstraints = false
        return aS
    }()
    
    let genreLabel: UILabel = {
        let gl = UILabel()
        gl.textColor = UIColor.gray
        gl.text = "Genre:"
        gl.translatesAutoresizingMaskIntoConstraints = false
        return gl
    }()
    
    let genreTextField: UITextField = {
        let gtf = UITextField()
        gtf.textColor = UIColor.white
        gtf.clearButtonMode = .whileEditing
        gtf.translatesAutoresizingMaskIntoConstraints = false
        gtf.addTarget(self, action: #selector(genreClicked), for: UIControlEvents.editingDidBegin)
        return gtf
    }()
    
    let genreSep: UIView = {
        let gs = UIView()
        gs.backgroundColor = UIColor.lightGray
        gs.translatesAutoresizingMaskIntoConstraints = false
        return gs
    }()
    
    lazy var genrePickView: UIPickerView = {
        let gp = UIPickerView()
        gp.dataSource = self
        gp.delegate = self
        return gp
    }()
    
    lazy var agePickView: UIPickerView = {
        let ap = UIPickerView()
        ap.dataSource = self
        ap.delegate = self
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
        tb.tintColor = UIColor(colorLiteralRed: 75/255, green: 215/255, blue: 100/255, alpha: 1)
        tb.sizeToFit()
        tb.setItems([cancelButton, spacer, doneButton], animated: true)
        return tb
    }()
    
    
    let backgroundImage: UIImageView = {
        let bi = UIImageView()
        bi.image = UIImage(named: "headphonesImage")
        bi.translatesAutoresizingMaskIntoConstraints = false
        bi.contentMode = .scaleAspectFill
        return bi
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        originalView = self.view.frame.origin.y
        view.backgroundColor = UIColor.black
        setupNavigationBar()
        setupViews()
    }
    
    //func handleImageSelection() {
        
    //}
    
    func handlePicTapped() {
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
            profilePic.image = selectedImageFromPicker
            addPhoto.setTitle("Edit\nPhoto", for: .normal)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func handleBack() {
        navigationController?.popToRootViewController(animated: true)
        
    }
    
    func handleDone() {

        if (genreTextField.isEditing == true || ageTextField.isEditing == true) {
            handleToolBarDone()
        }
        
        guard let ageSting = ageTextField.text else {
            return
        }
        
        //make sure the fields are valid
        guard let usernameUnwrapped = username, let passwordUnwrapper = password, let age = Int(ageSting), let genre = genreTextField.text, let name = djNameTextField.text, let hometown = hometownTextField.text else {
            print("Not valid args passed in.")
            return
        }
        
        if (genre == "" || hometown == "" || name == "") {
            print("Not valid entries");
            return
        }
        
        //create user
        Auth.auth().createUser(withEmail: usernameUnwrapped, password: passwordUnwrapper){ (user, error) in
            if let error = error {
                print ("My error is: \n")
                print(error.localizedDescription)
                return
            }
            else {
                //save user info into database
                
                guard let uid = user?.uid else {
                    return
                }
                // successfully created user
                let imageName = NSUUID().uuidString
                let storageRef = Storage.storage().reference().child("\(imageName).png")
                
                if let uploadData = UIImagePNGRepresentation(self.profilePic.image!){
                
                    storageRef.putData(uploadData, metadata: nil, completion: {
                        (metadata, error) in
                        if let error = error{
                            print(error.localizedDescription)
                            return
                        }
                        
                        if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                            
                            let values = ["djName":name, "hometown":hometown, "age":age, "genre":genre, "email": usernameUnwrapped, "validated": 0, "currentLocation": "Somewhere","profilePicURL": profileImageUrl] as [String : Any]
                        
                        self.registerUserIntoDatabaseWithUID(uid: uid,values: values as [String : AnyObject])
                        }
                    })
                }

            
                
                //display alert
                let alert = UIAlertController(title: "Registration Complete", message: "Congratulations!\nYou have finished the registration process. Please allow up to 48 hours for your DJ account to be processed and created.\nPress 'Continue' to be taken the main view.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.default, handler: { action in
                    print("I was pressed")
                    self.registrationComplete()
                }))
                
                self.present(alert, animated: true, completion: nil)
            }
        }
        
    }
    
    private func registerUserIntoDatabaseWithUID(uid: String, values: [String: AnyObject]) {
        let ref = Database.database().reference()
        let usersRef = ref.child("users").child(uid)
        usersRef.updateChildValues(values, withCompletionBlock: { (err, ref) in
            if let err = err {
                print("Adding values error: \n")
                print(err.localizedDescription)
                return
            }
            print ("Adding values was a success!")
        })
        
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
        resetView()
    }
    
    func handleToolBarCancel() {
        if (ageTextField.isEditing) {
            ageTextField.text = ""
        }
        else if (genreTextField.isEditing)  {
            genreTextField.text = ""
        }
        self.view.endEditing(true)
        resetView()
    }
  
    func ageClicked() {
        resetView()
        self.view.frame.origin.y -= 65
        ageTextField.inputView = agePickView
        ageTextField.inputAccessoryView = toolbar
    }
   
    func genreClicked() {
        resetView()
        self.view.frame.origin.y -= 110
        genreTextField.inputView = genrePickView
        genreTextField.inputAccessoryView = toolbar
    }
    
    func registrationComplete() {
        self.dismiss(animated: true, completion: nil)
        self.loginController?.handleGuestEnter()
    }
    
    func resetView() {
        if let ov = originalView {
            self.view.frame.origin.y = ov
        } else {
            print ("Didn't safely unwrap originalView")
        }
    }
    
    func setupNavigationBar() {
        self.navigationItem.title = "Enter Info"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(handleDone))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleBack))
    }
    
    func setupViews(){
        view.addSubview(backgroundImage)
        view.addSubview(profilePic)
        view.addSubview(addPhoto)
        view.addSubview(hometownLabel)
        view.addSubview(hometownTextField)
        view.addSubview(hometownSep)
        view.addSubview(djNameLabel)
        view.addSubview(djNameTextField)
        view.addSubview(djSep)
        view.addSubview(ageLabel)
        view.addSubview(ageTextField)
        view.addSubview(ageSep)
        view.addSubview(genreLabel)
        view.addSubview(genreTextField)
        view.addSubview(genreSep)
        
        
        backgroundImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        backgroundImage.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        backgroundImage.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        backgroundImage.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
        profilePic.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profilePic.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 24).isActive = true
        profilePic.widthAnchor.constraint(equalToConstant: 120).isActive = true
        profilePic.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        
        addPhoto.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        addPhoto.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 25).isActive = true
        addPhoto.widthAnchor.constraint(equalTo: profilePic.widthAnchor, multiplier: 1).isActive = true
        addPhoto.heightAnchor.constraint(equalTo: profilePic.heightAnchor, multiplier: 1).isActive = true
        
        hometownLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        hometownLabel.topAnchor.constraint(equalTo: profilePic.bottomAnchor, constant: 24).isActive = true
        hometownLabel.widthAnchor.constraint(equalToConstant: hometownLabel.intrinsicContentSize.width).isActive = true
        hometownLabel.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        hometownTextField.leftAnchor.constraint(equalTo: hometownLabel.rightAnchor, constant: 12).isActive = true
        hometownTextField.topAnchor.constraint(equalTo: hometownLabel.topAnchor).isActive = true
        hometownTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive = true
        hometownTextField.heightAnchor.constraint(equalTo: hometownLabel.heightAnchor).isActive = true
        
        hometownSep.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        hometownSep.topAnchor.constraint(equalTo: hometownLabel.bottomAnchor, constant: 6).isActive = true
        hometownSep.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        hometownSep.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        
        djNameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        djNameLabel.topAnchor.constraint(equalTo: hometownSep.bottomAnchor, constant: 6).isActive = true
        djNameLabel.widthAnchor.constraint(equalToConstant: djNameLabel.intrinsicContentSize.width).isActive = true
        djNameLabel.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        djNameTextField.leftAnchor.constraint(equalTo: djNameLabel.rightAnchor, constant: 12).isActive = true
        djNameTextField.topAnchor.constraint(equalTo: djNameLabel.topAnchor).isActive = true
        djNameTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive = true
        djNameTextField.heightAnchor.constraint(equalTo: djNameLabel.heightAnchor).isActive = true
        
        djSep.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        djSep.topAnchor.constraint(equalTo: djNameLabel.bottomAnchor, constant: 6).isActive = true
        djSep.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        djSep.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        
        ageLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        ageLabel.topAnchor.constraint(equalTo: djSep.bottomAnchor, constant: 6).isActive = true
        ageLabel.widthAnchor.constraint(equalToConstant: ageLabel.intrinsicContentSize.width).isActive = true
        ageLabel.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        ageTextField.leftAnchor.constraint(equalTo: ageLabel.rightAnchor, constant: 12).isActive = true
        ageTextField.topAnchor.constraint(equalTo: ageLabel.topAnchor).isActive = true
        ageTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive = true
        ageTextField.heightAnchor.constraint(equalTo: ageLabel.heightAnchor).isActive = true
        
        ageSep.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        ageSep.topAnchor.constraint(equalTo: ageLabel.bottomAnchor, constant: 6).isActive = true
        ageSep.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        ageSep.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        genreLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        genreLabel.topAnchor.constraint(equalTo: ageSep.bottomAnchor, constant: 6).isActive = true
        genreLabel.widthAnchor.constraint(equalToConstant: genreLabel.intrinsicContentSize.width).isActive = true
        genreLabel.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        genreTextField.leftAnchor.constraint(equalTo: genreLabel.rightAnchor, constant: 12).isActive = true
        genreTextField.topAnchor.constraint(equalTo: genreLabel.topAnchor).isActive = true
        genreTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive = true
        genreTextField.heightAnchor.constraint(equalTo: genreLabel.heightAnchor).isActive = true
        
        genreSep.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        genreSep.topAnchor.constraint(equalTo: genreLabel.bottomAnchor, constant: 6).isActive = true
        genreSep.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        genreSep.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        
    }
}

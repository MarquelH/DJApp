//
//  GuestChatViewController.swift
//  DJ APP
//
//  Created by arturo ho on 12/30/17.
//  Copyright © 2017 Marquel and Micajuine App Team. All rights reserved.
//

import UIKit
import Firebase

class GuestChatViewController: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout {
    
    var dj: UserDJ? {
        didSet {
            navigationItem.title = dj?.djName
        }
    }
    var guestID: String?
    var ref: DatabaseReference!
   // var messagesRef: DatabaseReference!
    var messages = [Message]()
    var handle: UInt?
    var tabbarHeight: CGFloat?
    
    let sendContanier: UIView = {
       let sc = UIView()
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.backgroundColor = UIColor.lightGray
        return sc
    }()
    
    let sendLineSeperator: UIView = {
        let sc = UIView()
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.backgroundColor = UIColor.darkGray
        return sc
    }()
    
    let sendButton: UIButton = {
        let sb = UIButton(type: .system)
        sb.setTitle("Send", for: .normal)
        sb.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        sb.translatesAutoresizingMaskIntoConstraints = false
        return sb
    }()
    
    lazy var messageTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Message..."
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.delegate = self
        return tf
    }()
    
    let cellId = "cellId"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let uid = dj?.uid, let id = guestID {
            ref = Database.database().reference().child("messages").child(id).child(uid)

            //messagesRef = Database.database().reference().child("messages").child(id)
            getMessages()
        }
        else {
            print("Chat will appear guestID or Dj not passed in")
        }
        if let height = tabbarHeight  {
            collectionView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: height, right: 0)
            collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: height, right: 0)
        }
        else {
            print("Tabbar height was not passed in.")
        }
    }
    
    override func viewDidLoad() {
        setupNavigationBar()
        
        
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(MessageCell.self, forCellWithReuseIdentifier: cellId)
        
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MessageCell
        
        cell.message = messages[indexPath.row]
        if let id = guestID, let text = cell.message?.message {
            cell.guestID = id
            cell.textBubble.widthAnchor.constraint(equalToConstant: estimateFrameForText(text: text).width + 16).isActive = true
            cell.textBubble.heightAnchor.constraint(equalToConstant: estimateFrameForText(text: text).height + 8).isActive = true
           

        }
        else {
            print("Loading table problem with GuestID")
        }
        
    
        
        return cell
    }
    
    //Estimate height of cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat = 80
        if let text = messages[indexPath.row].message {
            height = estimateFrameForText(text: text).height + 12
        }

        return CGSize(width: view.frame.width, height: height)
    }
    
    //Estimate height of text
    fileprivate func estimateFrameForText(text: String) -> CGRect {
        let size = CGSize(width: 200, height: 100)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 14)], context: nil)
    }
    
  
    func getMessages() {
        let query = ref.queryOrdered(byChild: "count")
        query.observeSingleEvent(of: .value, with: {(snapshot) in
            
            self.messages.removeAll()

            
            if !snapshot.exists() {
                print("Snapshot does not exist")
                return
            }
            for snap in snapshot.children.allObjects as! [DataSnapshot] {
                if let value = snap.value as? [String: AnyObject],let message = value["message"] as? String, let guestID = value["guestID"] as? String,  let timeStamp = value["timeStamp"] as? NSNumber, let djUID = value["djUID"] as? String, let guestName = value["guestName"] as? String, let guestPhone = value["Guest Phone"] as? String{
                    
                    let newMessage = Message(message: message, timeStamp: timeStamp, djUID: djUID, guestID: guestID,guestName: guestName,guestPhone: guestPhone)

             
                    self.messages.append(newMessage)
                  
                    DispatchQueue.main.async {
                        self.collectionView?.reloadData()
                    }
                }
                else {
                    print("Unable to convert snapshot children into [String:AnyObjects]")
                }
            }

            
        }) { (error) in
            print("Error getting snapshot: \(error.localizedDescription)")
        }
        
    }
    
    func setupNavigationBar() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor(red: 214/255, green: 29/255, blue: 1, alpha:1.0)
    }
    
    func handleSend() {
        print("Send was hit")
        //push to database
        let timeStamp = Int(Date().timeIntervalSince1970)
       
        if let message = messageTextField.text, let id = guestID, let uid = dj?.uid {
            let value = ["message": message, "timeStamp": timeStamp, "djUID":uid, "guestID": id] as [String : Any]
            ref.childByAutoId().setValue(value)
        }
        else {
            print("Problem unwrapping message value, or dj, or guestID")
        }
        messageTextField.text = ""
        getMessages()
    }
    
    func handleCancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        view.addSubview(sendContanier)
        sendContanier.addSubview(sendLineSeperator)
        sendContanier.addSubview(sendButton)
        sendContanier.addSubview(messageTextField)
        
        sendContanier.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        sendContanier.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        sendContanier.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        sendContanier.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        sendLineSeperator.topAnchor.constraint(equalTo: sendContanier.topAnchor).isActive = true
        sendLineSeperator.leftAnchor.constraint(equalTo: sendContanier.leftAnchor).isActive = true
        sendLineSeperator.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        sendLineSeperator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        sendButton.centerYAnchor.constraint(equalTo: sendContanier.centerYAnchor).isActive = true
        sendButton.rightAnchor.constraint(equalTo: sendContanier.rightAnchor, constant: 12).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: sendContanier.heightAnchor).isActive = true
        
        messageTextField.leftAnchor.constraint(equalTo: sendContanier.leftAnchor, constant: 12).isActive = true
        messageTextField.centerYAnchor.constraint(equalTo: sendContanier.centerYAnchor).isActive = true
        messageTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor, constant: 12).isActive = true
        messageTextField.heightAnchor.constraint(equalTo: sendContanier.heightAnchor).isActive = true
    }
}

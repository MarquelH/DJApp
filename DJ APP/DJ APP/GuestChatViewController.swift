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
    var messageCount: Int = -1
    
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
        if let id = guestID {
            cell.guestID = id
        }
        else {
            print("Loading table problem with GuestID")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 40)
    }
    
  
    func getMessages() {
        ref.queryOrdered(byChild: "count").observeSingleEvent(of: .value, with: {(snapshot) in
            
            if let workingSnap = snapshot.value as? [String: AnyObject] {
                self.messages.removeAll()
                
                for (_, value) in workingSnap {
                  
                    if let message = value["message"] as? String, let guestID = value["guestID"] as? String, let djUID = value["djUID"] as? String, let timeStamp = value["timeStamp"] as? NSNumber, let count = value["count"] as? Int {
    
                        let newMessage = Message(message: message, timeStamp: timeStamp, djUID: djUID, guestID: guestID, count: count)
                        
                        print("Message: \(message)count: \(count)\n")
                        if count > self.messageCount {
                            self.messageCount = count
                        }
                        self.messages.append(newMessage)
                        self.messages.sorted(by: { (message1, message2) -> Bool in
                            let count = message1.count!
                            let count2 = message2.count!
                            return count > count2
                        })
                        print(self.messages)
                        
                        DispatchQueue.main.async {
                            self.collectionView?.reloadData()
                        }
                    }
                    else {
                        print("Error getting values from working snap")
                    }

                }
                
            }
            else {
                print("Error converting snapshot.value to [string:Anyobject]")
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
        messageCount = messageCount + 1
        if let message = messageTextField.text, let id = guestID, let uid = dj?.uid {
            let value = ["message": message, "timeStamp": timeStamp, "djUID":uid, "guestID": id, "count": messageCount] as [String : Any]
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
//        if let ref = self.ref, let handle = handle {
//            ref.removeObserver(withHandle: handle)
//        }
        
    }
    
    override func viewWillLayoutSubviews() {
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

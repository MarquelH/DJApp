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
    
    var messages = [Message]()
    
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
    
    override func viewDidLoad() {
        setupNavigationBar()
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
    
    func setupNavigationBar() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor(red: 214/255, green: 29/255, blue: 1, alpha:1.0)
    }
    
    func handleSend() {
        print("Send was hit")
    }
    
    func handleCancel() {
        self.dismiss(animated: true, completion: nil)
    }
}

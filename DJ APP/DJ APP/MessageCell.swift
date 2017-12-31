//
//  MessageCell.swift
//  DJ APP
//
//  Created by arturo ho on 12/30/17.
//  Copyright © 2017 Marquel and Micajuine App Team. All rights reserved.
//

import UIKit

class MessageCell: UICollectionViewCell {
    
    var message: Message? {
        didSet {
            textView.text = message?.message
        }
    }
    var guestID: String? {
        didSet {
            setupChatBubble()
        }
    }
    
    
    let textView: UITextView = {
       let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.textColor = UIColor.white
        tv.backgroundColor = UIColor.clear
        tv.textAlignment = .left
        tv.textContainerInset = .zero
        return tv
    }()
    
    let textBubble: UIView = {
        let tb = UIView()
        tb.translatesAutoresizingMaskIntoConstraints = false
        tb.layer.borderColor = UIColor.black.cgColor
        tb.layer.borderWidth = 1
        tb.layer.cornerRadius = 6
        tb.layer.masksToBounds = true
        return tb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func setupChatBubble() {
        addSubview(textBubble)
        textBubble.addSubview(textView)
        
        if let textGuestID = message?.guestID, let id = guestID {
            
            if id == textGuestID {
                setupGuestBubble()
            }
            else {
                setupDJBubble()
            }
           
        }
        else {
            print("Problem with cell message guest ID or guest ID")
        }
        textView.leftAnchor.constraint(equalTo: textBubble.leftAnchor, constant: 8).isActive = true
        textView.topAnchor.constraint(equalTo: textBubble.topAnchor, constant: 6).isActive = true
        textView.widthAnchor.constraint(equalTo: textBubble.widthAnchor, constant: -8).isActive = true
        textView.heightAnchor.constraint(equalTo: textBubble.heightAnchor, constant: -6).isActive = true
        
    }
    
    func setupGuestBubble() {
        textBubble.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12).isActive = true
        textBubble.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        //textView.widthAnchor.constraint(equalToConstant: 125).isActive = true
        //textView.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -20).isActive = true
        
        textBubble.backgroundColor = UIColor.blue
    }
    func setupDJBubble() {
        //left with positive constant moves it to the right, right with positive constant moves it to the right
        textBubble.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12).isActive = true
        textBubble.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        //textView.widthAnchor.constraint(equalToConstant: 125).isActive = true
        //textView.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -20).isActive = true
        
        textBubble.backgroundColor = UIColor.darkGray
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

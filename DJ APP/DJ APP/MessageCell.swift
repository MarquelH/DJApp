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
        tv.layer.borderColor = UIColor.black.cgColor
        tv.layer.borderWidth = 1
        tv.layer.cornerRadius = 10
        tv.layer.masksToBounds = true
        tv.textAlignment = .center
        return tv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func setupChatBubble() {
        addSubview(textView)
        
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
    }
    
    func setupGuestBubble() {
        textView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        textView.widthAnchor.constraint(equalToConstant: 125).isActive = true
        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        textView.backgroundColor = UIColor.blue
    }
    func setupDJBubble() {
        textView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        textView.widthAnchor.constraint(equalToConstant: 125).isActive = true
        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        textView.backgroundColor = UIColor.darkGray
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

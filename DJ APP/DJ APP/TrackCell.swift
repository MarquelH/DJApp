//
//  TrackCell.swift
//  DJ APP
//
//  Created by arturo ho on 9/22/17.
//  Copyright © 2017 Marquel and Micajuine App Team. All rights reserved.
//

import UIKit

class TrackCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    let separator: UIView = {
        let s = UIView()
        s.translatesAutoresizingMaskIntoConstraints = false
        s.backgroundColor = UIColor(red: 214/255, green: 29/255, blue: 1, alpha:1.0)
        return s
    }()
    
    let profileImageView: ProfileImageView = {
        let iv = ProfileImageView()
        //iv.image = UIImage(named: "usernameIcon")
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.masksToBounds = true
        iv.layer.cornerRadius = 30
        iv.layer.borderColor = UIColor.white.cgColor
        iv.layer.borderWidth = 1
        return iv
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        textLabel?.backgroundColor = UIColor.clear
        detailTextLabel?.backgroundColor = UIColor.clear
        
        detailTextLabel?.textColor = UIColor.white
        textLabel?.textColor = UIColor.white
        
        textLabel?.font = UIFont(name: "SudegnakNo2", size: 20)
        detailTextLabel?.font = UIFont(name: "SudegnakNo2", size: 12)
        
        backgroundColor = UIColor.black
        
        
        //Check if it will run off, then change the width of the text label, so that
        //when we truncate it by character, is stops at the edge of the screen
        //80 is from 10 for left and right, 60 for size of image
        if (textLabel?.frame.width)! > self.frame.width - 80 {
            let difference = (textLabel?.frame.width)! - self.frame.width + 80
            textLabel?.frame = CGRect(x: 80, y: textLabel!.frame.origin.y, width: textLabel!.frame.width - difference, height: textLabel!.frame.height)
        }
        else {
            textLabel?.frame = CGRect(x: 80, y: textLabel!.frame.origin.y, width: textLabel!.frame.width, height: textLabel!.frame.height)
        }
        textLabel?.backgroundColor = UIColor.clear
        textLabel?.lineBreakMode = .byTruncatingTail
        
        
        //Do I have to check if this guy will run off too?
        detailTextLabel?.frame = CGRect(x: 80, y: detailTextLabel!.frame.origin.y, width: detailTextLabel!.frame.width, height: textLabel!.frame.height)
        detailTextLabel?.backgroundColor = UIColor.clear
        detailTextLabel?.lineBreakMode = .byTruncatingTail
        
    }
    
    
    
    func setupViews() {
        contentView.addSubview(separator)
        contentView.addSubview(profileImageView)

        
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        
        separator.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        separator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 2.5).isActive = true
        separator.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}




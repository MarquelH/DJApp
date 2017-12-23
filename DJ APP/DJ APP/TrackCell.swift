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
        iv.layer.cornerRadius = 20
        iv.layer.borderColor = UIColor.black.cgColor
        iv.layer.borderWidth = 1
        return iv
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //10 for left and right, 50 for size of image

        //Check if it will run off, then change the width of the text label, so that
        //when we truncate it by character, is stops at the edge of the screen
        if (textLabel?.frame.width)! > self.frame.width - 70 {
            let difference = (textLabel?.frame.width)! - self.frame.width + 70
            textLabel?.frame = CGRect(x: 70, y: textLabel!.frame.origin.y - 3, width: textLabel!.frame.width - difference, height: textLabel!.frame.height)
        }
        else {
            textLabel?.frame = CGRect(x: 70, y: textLabel!.frame.origin.y - 3, width: textLabel!.frame.width, height: textLabel!.frame.height)
        }
        textLabel?.backgroundColor = UIColor.clear
        textLabel?.lineBreakMode = .byTruncatingTail
        
        detailTextLabel?.frame = CGRect(x: 70, y: detailTextLabel!.frame.origin.y + 1, width: detailTextLabel!.frame.width, height: textLabel!.frame.height)
        detailTextLabel?.backgroundColor = UIColor.clear
        detailTextLabel?.lineBreakMode = .byTruncatingTail
        
    }
    
    
    
    func setupViews() {
        contentView.addSubview(separator)
        contentView.addSubview(profileImageView)

        
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        
        separator.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        separator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 2.5).isActive = true
        separator.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}




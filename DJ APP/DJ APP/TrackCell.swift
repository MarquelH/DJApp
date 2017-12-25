//
//  TrackCell.swift
//  DJ APP
//
//  Created by arturo ho on 9/22/17.
//  Copyright © 2017 Marquel and Micajuine App Team. All rights reserved.
//

import UIKit

class TrackCell: BaseCell {
    


    
    //profile image view width height, search cell left + 10, + 15
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.font = UIFont(name: "SudegnakNo2", size: 20)
        detailTextLabel?.font = UIFont(name: "SudegnakNo2", size: 12)
        
        textLabel?.backgroundColor = UIColor.clear
        detailTextLabel?.backgroundColor = UIColor.clear
        
        detailTextLabel?.textColor = UIColor.white
        textLabel?.textColor = UIColor.white
        
        
        textLabel?.lineBreakMode = .byTruncatingTail
        
        
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
        
        
        //Do I have to check if this guy will run off too?
        detailTextLabel?.frame = CGRect(x: 80, y: detailTextLabel!.frame.origin.y, width: detailTextLabel!.frame.width, height: textLabel!.frame.height)
        detailTextLabel?.backgroundColor = UIColor.clear
        detailTextLabel?.lineBreakMode = .byTruncatingTail
    }
    
    
    override func setupViews() {
        super.setupViews()
        contentView.backgroundColor = UIColor.black
        contentView.addSubview(profileImageView)
        
        profileImageView.layer.cornerRadius = 30
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
}




//
//  SearchCell.swift
//  DJ APP
//
//  Created by arturo ho on 11/15/17.
//  Copyright © 2017 Marquel and Micajuine App Team. All rights reserved.
//

import UIKit

class SearchCell: BaseCell {

    override func setupViews() {
        super.setupViews()
        contentView.backgroundColor = UIColor.purple
        
        contentView.addSubview(profileImageView)

        profileImageView.layer.cornerRadius = 20
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
    }
    

    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.font = UIFont(name: "SudegnakNo2", size: 18)
        detailTextLabel?.font = UIFont(name: "SudegnakNo2", size: 12)
        
        textLabel?.backgroundColor = UIColor.clear
        detailTextLabel?.backgroundColor = UIColor.clear

        textLabel?.lineBreakMode = .byTruncatingTail

        //15 + 15 + 40 =
        if (textLabel?.frame.width)! > self.frame.width - 70 {
            let difference = (textLabel?.frame.width)! - self.frame.width + 70
            textLabel?.frame = CGRect(x: 70, y: textLabel!.frame.origin.y - 1, width: textLabel!.frame.width - difference, height: textLabel!.frame.height)
        }
        else {
            textLabel?.frame = CGRect(x: 70, y: textLabel!.frame.origin.y - 1, width: textLabel!.frame.width, height: textLabel!.frame.height)
        }
        
        
        //Do I have to check if this guy will run off too?
        detailTextLabel?.frame = CGRect(x: 70, y: detailTextLabel!.frame.origin.y + 1, width: detailTextLabel!.frame.width, height: textLabel!.frame.height)
    }
    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
    
}

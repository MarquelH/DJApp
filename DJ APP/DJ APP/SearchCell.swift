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
        contentView.backgroundColor = UIColor.black
        
        contentView.addSubview(profileImageView)

        profileImageView.layer.cornerRadius = 2
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    

    override func layoutSubviews() {
        super.layoutSubviews()
        
        //textLabel?.font = UIFont(name: "SudegnakNo2", size: 26)
        //detailTextLabel?.font = UIFont(name: "SudegnakNo2", size: 24)
        
        textLabel?.textColor = UIColor.white
        detailTextLabel?.textColor = UIColor.white
        
        textLabel?.backgroundColor = UIColor.clear
        detailTextLabel?.backgroundColor = UIColor.clear

        textLabel?.lineBreakMode = .byTruncatingTail
        detailTextLabel?.lineBreakMode = .byTruncatingTail


        //15 + 15 + 40 = 70
        if (textLabel?.frame.width)! > self.frame.width - 70 {
            let difference = (textLabel?.frame.width)! - self.frame.width + 70
            textLabel?.frame = CGRect(x: 70, y: textLabel!.frame.origin.y - 1, width: textLabel!.frame.width - difference, height: textLabel!.frame.height)
             detailTextLabel?.frame = CGRect(x: 70, y: detailTextLabel!.frame.origin.y + 1, width: detailTextLabel!.frame.width - difference, height: textLabel!.frame.height)
        }
        else {
            textLabel?.frame = CGRect(x: 70, y: textLabel!.frame.origin.y - 1, width: textLabel!.frame.width, height: textLabel!.frame.height)
             detailTextLabel?.frame = CGRect(x: 70, y: detailTextLabel!.frame.origin.y + 1, width: detailTextLabel!.frame.width, height: textLabel!.frame.height)
        }
    }
    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
    
}

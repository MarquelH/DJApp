//
//  DJCell.swift
//  DJ APP
//
//  Created by arturo ho on 12/25/17.
//  Copyright © 2017 Marquel and Micajuine App Team. All rights reserved.
//

import UIKit


class DJCell: BaseCell {
    
    //Check that text doesn't go over edge
    override func layoutSubviews() {
        super.layoutSubviews()

        textLabel?.textColor = UIColor.white.withAlphaComponent(1.5)
        textLabel?.font = UIFont(name: "BebasNeue-Regular", size : 22)

        detailTextLabel?.textColor = UIColor.white.withAlphaComponent(1.5)
        detailTextLabel?.font = UIFont(name: "BebasNeue-Regular", size : 18)
        
        //10 for left and right, 70 for size of image
        textLabel?.frame = CGRect(x: 90, y: textLabel!.frame.origin.y - 3, width: textLabel!.frame.width, height: textLabel!.frame.height)
        textLabel?.backgroundColor = UIColor.clear
        detailTextLabel?.frame = CGRect(x: 90, y: detailTextLabel!.frame.origin.y + 1, width: detailTextLabel!.frame.width, height: textLabel!.frame.height)
        detailTextLabel?.backgroundColor = UIColor.clear
        
    }

    override func setupViews() {
        super.setupViews()
        separator.backgroundColor = UIColor.white
        
        contentView.addSubview(profileImageView)
        
        profileImageView.layer.cornerRadius = 35
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
    }
    
    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
}

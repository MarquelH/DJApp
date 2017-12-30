//
//  TrackCell.swift
//  DJ APP
//
//  Created by arturo ho on 9/22/17.
//  Copyright © 2017 Marquel and Micajuine App Team. All rights reserved.
//

import UIKit

class TrackCell: BaseCell {
    
    let upArrowImage: UIImage = UIImage(named: "UpArrow")!
    let downArrowImage: UIImage = UIImage(named: "DownArrow")!

    let totalvotesLabel: UILabel = {
       let tvl = UILabel()
        tvl.translatesAutoresizingMaskIntoConstraints = false
        tvl.textColor = UIColor.lightGray
        tvl.font = UIFont.boldSystemFont(ofSize: 18)
        return tvl
    }()
    
    lazy var upArrowImageView: ProfileImageView = {
        let iv = ProfileImageView()
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    lazy var downArrowImageView: ProfileImageView = {
        let iv = ProfileImageView()
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    func upArrowSelected() {
        upArrowImageView.image = upArrowImage.maskWithColor(color: UIColor.green)
        downArrowImageView.image = downArrowImage.maskWithColor(color: UIColor.lightGray)
        totalvotesLabel.textColor = UIColor.green
    }
    
    func downArrowSelected() {
        upArrowImageView.image = upArrowImage.maskWithColor(color: UIColor.lightGray)
        downArrowImageView.image = downArrowImage.maskWithColor(color: UIColor.red)
        totalvotesLabel.textColor = UIColor.red
    }
    
    func noSelection() {
        upArrowImageView.image = upArrowImage.maskWithColor(color: UIColor.lightGray)
        downArrowImageView.image = downArrowImage.maskWithColor(color: UIColor.lightGray)
        totalvotesLabel.textColor = UIColor.lightGray
    }


    
    //profile image view width height, search cell left + 10, + 15
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //textLabel?.font = UIFont(name: "SudegnakNo2", size: 26)
        //detailTextLabel?.font = UIFont(name: "SudegnakNo2", size: 24)
        
        textLabel?.backgroundColor = UIColor.clear
        detailTextLabel?.backgroundColor = UIColor.clear
        
        detailTextLabel?.textColor = UIColor.white
        textLabel?.textColor = UIColor.white
        
        
        textLabel?.lineBreakMode = .byTruncatingTail
        
        
        //Check if it will run off, then change the width of the text label, so that
        //when we truncate it by character, is stops at the edge of the screen
        //80 is from 10 for left and right, 60 for size of image, 35 for thumb 15 for right, 5 for left = 135
        if (textLabel?.frame.width)! > self.frame.width - 135 {
            let difference = (textLabel?.frame.width)! - self.frame.width + 135
            textLabel?.frame = CGRect(x: 80, y: textLabel!.frame.origin.y, width: textLabel!.frame.width - difference, height: textLabel!.frame.height)
        }
        else {
            textLabel?.frame = CGRect(x: 80, y: textLabel!.frame.origin.y, width: textLabel!.frame.width, height: textLabel!.frame.height)
        }
        
        
        //Do I have to check if this guy will run off too? Yes...
        detailTextLabel?.frame = CGRect(x: 80, y: detailTextLabel!.frame.origin.y, width: detailTextLabel!.frame.width, height: textLabel!.frame.height)
        detailTextLabel?.backgroundColor = UIColor.clear
        detailTextLabel?.lineBreakMode = .byTruncatingTail
    }
    
    
    override func setupViews() {
        super.setupViews()
        
        upArrowImageView.image = upArrowImage.maskWithColor(color: UIColor.lightGray)
        downArrowImageView.image = downArrowImage.maskWithColor(color: UIColor.lightGray)
        
        contentView.backgroundColor = UIColor.black
        contentView.addSubview(profileImageView)
        contentView.addSubview(upArrowImageView)
        contentView.addSubview(downArrowImageView)
        contentView.addSubview(totalvotesLabel)

        
        profileImageView.layer.cornerRadius = 30
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        upArrowImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -20).isActive = true
        upArrowImageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        upArrowImageView.widthAnchor.constraint(equalToConstant: 35).isActive = true
        upArrowImageView.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        
        downArrowImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 20).isActive = true
        downArrowImageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        downArrowImageView.widthAnchor.constraint(equalToConstant: 35).isActive = true
        downArrowImageView.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        totalvotesLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        totalvotesLabel.centerXAnchor.constraint(equalTo: downArrowImageView.centerXAnchor, constant: 3).isActive = true
        totalvotesLabel.widthAnchor.constraint(equalToConstant: 15).isActive = true
       
        totalvotesLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
    }
    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
}




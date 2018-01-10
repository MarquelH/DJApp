 //
//  djTrackCell.swift
//  DJ APP
//
//  Created by Marquel Hendricks on 1/6/18.
//  Copyright © 2018 Marquel and Micajuine App Team. All rights reserved.
//

import UIKit
import Firebase

 class djTrackCell: BaseCell {
    let upArrowImage: UIImage = UIImage(named: "UpArrow")!
    let downArrowImage: UIImage = UIImage(named: "DownArrow")!
    
    let totalvotesLabel: UILabel = {
        let tvl = UILabel()
        tvl.translatesAutoresizingMaskIntoConstraints = false
        tvl.textColor = UIColor.lightGray
        tvl.font = UIFont.boldSystemFont(ofSize: 18)
        tvl.backgroundColor = UIColor.clear
        tvl.textAlignment = .center
        return tvl
    }()
    
    func noSelection() {
        let numberOfVotes = Int(totalvotesLabel.text!)
        if (numberOfVotes! == 0){
        totalvotesLabel.textColor = UIColor.lightGray
        }
        else if (numberOfVotes! < 0){
            totalvotesLabel.textColor = UIColor.red
        }
        else{
            totalvotesLabel.textColor = UIColor.green
        }
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
        
        textLabel?.font = UIFont(name: "Mikodacs", size : 19)
        detailTextLabel?.font = UIFont(name: "Mikodacs", size : 15)
        
        textLabel?.lineBreakMode = .byTruncatingTail
        detailTextLabel?.lineBreakMode = .byTruncatingTail
        
        
        //Check if it will run off, then change the width of the text label, so that
        //when we truncate it by character, is stops at the edge of the screen
        //80 is from 10 for left and right, 60 for size of image, 35 for thumb 15 for right, 5 for left = 135
        if (textLabel?.frame.width)! > self.frame.width - 135 {
            let difference = (textLabel?.frame.width)! - self.frame.width + 135
            textLabel?.frame = CGRect(x: 80, y: textLabel!.frame.origin.y, width: textLabel!.frame.width - difference, height: textLabel!.frame.height)
            detailTextLabel?.frame = CGRect(x: 80, y: detailTextLabel!.frame.origin.y, width: detailTextLabel!.frame.width - difference, height: textLabel!.frame.height)
        }
        else {
            textLabel?.frame = CGRect(x: 80, y: textLabel!.frame.origin.y, width: textLabel!.frame.width, height: textLabel!.frame.height)
            detailTextLabel?.frame = CGRect(x: 80, y: detailTextLabel!.frame.origin.y, width: detailTextLabel!.frame.width, height: textLabel!.frame.height)
        }
    }
    
    
    override func setupViews() {
        super.setupViews()
        
        contentView.backgroundColor = UIColor.black
        contentView.addSubview(profileImageView)
        contentView.addSubview(totalvotesLabel)
        
        
        profileImageView.layer.cornerRadius = 3
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        totalvotesLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        totalvotesLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
    }
    
    //    required init?(coder aDecoder: NSCoder) {
    //        super.init(coder: aDecoder)
    //    }
 }


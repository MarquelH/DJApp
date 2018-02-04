//
//  MessageTableViewCell.swift
//  DJ APP
//
//  Created by Marquel Hendricks on 1/22/18.
//  Copyright © 2018 Marquel and Micajuine App Team. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    let separator: UIView = {
        let s = UIView()
        s.translatesAutoresizingMaskIntoConstraints = false
        s.backgroundColor = UIColor(red: 214/255, green: 29/255, blue: 1, alpha:1.0)
        return s
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.backgroundColor = UIColor.black
        detailTextLabel?.backgroundColor = UIColor.black
        
        detailTextLabel?.textColor = UIColor.white
        textLabel?.textColor = UIColor.white
        
        textLabel?.font = UIFont(name: "Mikodacs", size : 19)
        detailTextLabel?.font = UIFont(name: "Mikodacs", size : 16)
        
        contentView.addSubview(separator)
        
        separator.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        separator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 2.5).isActive = true
        separator.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        
        textLabel?.lineBreakMode = .byTruncatingTail
        detailTextLabel?.lineBreakMode = .byTruncatingTail
        
       // textLabel?.frame = CGRect(x: 90, y: textLabel!.frame.origin.y - 3, width: textLabel!.frame.width, height: textLabel!.frame.height)
        textLabel?.backgroundColor = UIColor.clear
       // detailTextLabel?.frame = CGRect(x: 90, y: detailTextLabel!.frame.origin.y + 1, width: detailTextLabel!.frame.width, height: textLabel!.frame.height)
        detailTextLabel?.backgroundColor = UIColor.clear
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

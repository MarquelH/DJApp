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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //10 for left and right, 50 for size of image
        textLabel?.frame = CGRect(x: 5, y: textLabel!.frame.origin.y - 3, width: textLabel!.frame.width, height: textLabel!.frame.height)
        //textLabel?.backgroundColor = UIColor.clear
        detailTextLabel?.frame = CGRect(x: 5, y: detailTextLabel!.frame.origin.y + 1
            , width: detailTextLabel!.frame.width, height: textLabel!.frame.height)
        //detailTextLabel?.backgroundColor = UIColor.clear
        
        // darkView.frame = contentView.frame
        
    }
    
    
    //    func cellClicked() {
    //        contentView.addSubview(darkView)
    //    }
    //
    //    func cellEndedClick() {
    //            darkView.removeFromSuperview()
    //    }
    
    func setupViews() {
        contentView.addSubview(separator)
        
        
        separator.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        separator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 3.5).isActive = true
        separator.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

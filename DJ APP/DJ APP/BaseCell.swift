//
//  BaseCell.swift
//  DJ APP
//
//  Created by arturo ho on 12/25/17.
//  Copyright © 2017 Marquel and Micajuine App Team. All rights reserved.
//

import UIKit

class BaseCell: UITableViewCell {

  
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
        iv.layer.borderColor = UIColor.white.cgColor
        iv.layer.borderWidth = 1
        return iv
    }()
    
  
    
    //Only add seperator
    func setupViews() {
        contentView.addSubview(separator)
        
        separator.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        separator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 2.5).isActive = true
        separator.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

}

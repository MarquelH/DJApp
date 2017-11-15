//
//  SearchCell.swift
//  DJ APP
//
//  Created by arturo ho on 11/15/17.
//  Copyright © 2017 Marquel and Micajuine App Team. All rights reserved.
//

import UIKit

class SearchCell: TrackCell {
    
    let threeDots: UIImageView = {
        let td = UIImageView(image: UIImage(named: "3 dots"))
        td.translatesAutoresizingMaskIntoConstraints = false
        td.contentMode = .scaleAspectFit
        return td
    }()
    
    override func setupViews() {
        super.setupViews()
        contentView.backgroundColor = UIColor.purple
        contentView.addSubview(threeDots)
        
        threeDots.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        threeDots.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        threeDots.widthAnchor.constraint(equalToConstant: 20).isActive = true
        threeDots.heightAnchor.constraint(equalToConstant: 10).isActive = true
    }
    
}

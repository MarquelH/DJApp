//
//  DJCollectionViewCell.swift
//  DJ APP
//
//  Created by Marquel Hendricks on 2/22/19.
//  Copyright © 2019 Marquel and Micajuine App Team. All rights reserved.
//

import UIKit

class DJCollectionViewCell: UICollectionViewCell {
    
    let profileImageView: ProfileImageView = {
        let iv = ProfileImageView()
        iv.image = UIImage(named: "usernameIcon")
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.masksToBounds = true
        iv.layer.borderColor = UIColor.white.cgColor
        iv.layer.borderWidth = 1
        return iv
    }()
    
    let DJNameLabel: UILabel = {
       let tl = UILabel()
        tl.text = "DJ So&So"
        tl.translatesAutoresizingMaskIntoConstraints = false
        tl.font = UIFont(name: "BebasNeue-Regular", size: 25)
        tl.textColor = UIColor.black
        return tl
    }()
    
    let genresLabel: UILabel = {
       let gl = UILabel()
        gl.text = "Favorite Genre"
        gl.translatesAutoresizingMaskIntoConstraints = false
        gl.font = UIFont(name: "BebasNeue-Regular", size: 20)
        gl.textColor = UIColor.black
        return gl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        //super.setupViews()
        //separator.backgroundColor = UIColor.white
        
        
        contentView.addSubview(profileImageView)
        contentView.addSubview(DJNameLabel)
        contentView.addSubview(genresLabel)
        
        //textLabel1.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        //textLabel1.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        
        self.contentView.centerXAnchor.constraint(equalTo: DJNameLabel.centerXAnchor).isActive = true
        self.contentView.centerYAnchor.constraint(equalTo: DJNameLabel.centerYAnchor).isActive = true
        
        self.genresLabel.topAnchor.constraint(equalTo: DJNameLabel.bottomAnchor, constant: 15).isActive = true
        self.genresLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        
        profileImageView.layer.cornerRadius = 35
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        profileImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        //profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
    }
    
}

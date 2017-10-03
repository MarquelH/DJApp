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
    
    let darkView: UIView = {
        let dk = UIView()
        dk.backgroundColor = UIColor.darkGray
        return dk
    }()
    
    let separator: UIView = {
        let s = UIView()
        s.translatesAutoresizingMaskIntoConstraints = false
        s.backgroundColor = UIColor.white
        return s
    }()
    
    lazy var gradientLayer: CAGradientLayer = {
        let gl = CAGradientLayer()
        let firstColor: CGColor = UIColor(red: 0, green: 0.832, blue: 0.557, alpha: 1.0).cgColor
        let secondColor: CGColor = UIColor(red: 0, green: 0.635, blue: 0.923, alpha: 1.0).cgColor
        gl.colors = [firstColor, secondColor]
        gl.locations = [0, 0.5]
        gl.startPoint = CGPoint(x: 0, y: 0)
        gl.endPoint = CGPoint(x: 0, y: 1)
        return gl
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //10 for left and right, 50 for size of image
        textLabel?.frame = CGRect(x: 5, y: textLabel!.frame.origin.y - 3, width: textLabel!.frame.width, height: textLabel!.frame.height)
        textLabel?.backgroundColor = UIColor.clear
        detailTextLabel?.frame = CGRect(x: 5, y: detailTextLabel!.frame.origin.y + 1
           , width: detailTextLabel!.frame.width, height: textLabel!.frame.height)
        detailTextLabel?.backgroundColor = UIColor.clear
        //contentView.layer.insertSublayer(gradientLayer, at: 0)
        //contentView.backgroundColor = UIColor(red: 214/255, green: 29/255, blue: 1, alpha:1.0)
        //gradientLayer.frame = contentView.frame
        darkView.frame = contentView.frame
        
    }
    
    
    func cellClicked() {
        contentView.addSubview(darkView)
    }
    
    func cellEndedClick() {
        darkView.removeFromSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        contentView.addSubview(separator)

        
        
        separator.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        separator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
        separator.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
    }
    
}

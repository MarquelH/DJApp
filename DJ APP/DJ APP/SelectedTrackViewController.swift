//
//  ViewController.swift
//  DJ APP
//
//  Created by arturo ho on 11/16/17.
//  Copyright © 2017 Marquel and Micajuine App Team. All rights reserved.
//

import UIKit

class SelectedTrackViewController: UIViewController {

    var track: TrackItem?
    
   
    let mainview: UIView = {
       let mv = UIView()
        mv.translatesAutoresizingMaskIntoConstraints = false
        mv.backgroundColor = UIColor.darkGray
        return mv
    }()
    
    let addButton: UIButton = {
       let ab = UIButton(type: .system)
        ab.setTitle("Add Song", for: .normal)
        ab.setTitleColor(UIColor.white, for: .normal)
        ab.backgroundColor = UIColor.black.withAlphaComponent(0.25)
        ab.layer.cornerRadius = 24
        ab.layer.borderWidth = 1
        ab.layer.borderColor = UIColor.purple.cgColor
        ab.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        ab.addTarget(self, action: #selector(handleAdd), for: .touchUpInside)
        ab.translatesAutoresizingMaskIntoConstraints = false
        
        return ab
    }()
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //definesPresentationContext = true
        print("selected Track view controller shown")
        setupViews()
        // Do any additional setup after loading the view.
    }
    
    
    // HELPERS --------------------
    func handleAdd() {
        print ("add")
        dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupViews() {
        self.view.addSubview(mainview)
        
        mainview.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        mainview.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        mainview.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        mainview.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        
        mainview.addSubview(addButton)
        
        addButton.centerXAnchor.constraint(equalTo: mainview.centerXAnchor).isActive = true
        if #available(iOS 11.0, *) {
            addButton.bottomAnchor.constraintEqualToSystemSpacingBelow(mainview.bottomAnchor, multiplier: -0.25).isActive = true
        } else {
            // Fallback on earlier versions
            addButton.bottomAnchor.constraint(equalTo: mainview.bottomAnchor, constant: -25)
        }
        addButton.widthAnchor.constraint(equalTo: mainview.widthAnchor, constant: 24).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 48)
        
    }


}

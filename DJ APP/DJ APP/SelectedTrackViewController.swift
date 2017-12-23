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
        mv.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        mv.isOpaque = false
        
        return mv
    }()
    
    let addButton: UIButton = {
       let ab = UIButton(type: .system)
        ab.setTitle("Add To Queue", for: .normal)
        ab.setTitleColor(UIColor.white, for: .normal)
        ab.backgroundColor = UIColor.darkGray
        ab.layer.cornerRadius = 24
        ab.layer.borderWidth = 1
        ab.layer.borderColor = UIColor.purple.cgColor
        ab.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        ab.addTarget(self, action: #selector(handleAdd), for: .touchUpInside)
        ab.translatesAutoresizingMaskIntoConstraints = false
        
        return ab
    }()
    let cancelButton: UIButton = {
        let cb = UIButton(type: .system)
        cb.setTitle("Cancel", for: .normal)
        cb.setTitleColor(UIColor.white, for: .normal)
        cb.backgroundColor = UIColor.darkGray
        cb.layer.cornerRadius = 24
        cb.layer.borderWidth = 1
        cb.layer.borderColor = UIColor.purple.cgColor
        cb.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        cb.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        cb.translatesAutoresizingMaskIntoConstraints = false
        
        return cb
    }()
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Change status bar background color
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.black
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        //Change status bar background color
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.darkGray
    }
    
    
    // HELPERS --------------------
    func handleAdd() {
        print ("add")
        dismiss(animated: true, completion: nil)
    }
    
    func handleCancel() {
        print ("cancel")
        dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupViews() {
        self.view.addSubview(mainview)
        mainview.addSubview(addButton)
        mainview.addSubview(cancelButton)

        mainview.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        mainview.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        mainview.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        mainview.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        
        
        addButton.centerXAnchor.constraint(equalTo: mainview.centerXAnchor).isActive = true
        addButton.centerYAnchor.constraint(equalTo: mainview.centerYAnchor).isActive = true
        addButton.widthAnchor.constraint(equalTo: mainview.widthAnchor, constant: -24).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        cancelButton.centerXAnchor.constraint(equalTo: mainview.centerXAnchor).isActive = true
        cancelButton.topAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 8).isActive = true
        cancelButton.widthAnchor.constraint(equalTo: addButton.widthAnchor).isActive = true
        cancelButton.heightAnchor.constraint(equalTo: addButton.heightAnchor).isActive = true
        
    }


}

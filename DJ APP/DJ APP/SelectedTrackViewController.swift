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
    
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//    }
//    
    let mainview: UIView = {
       let mv = UIView()
        mv.translatesAutoresizingMaskIntoConstraints = false
        mv.backgroundColor = UIColor.purple
        return mv
    }()
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //definesPresentationContext = true
        print("selected Track view controller shown")
        setupViews()
        // Do any additional setup after loading the view.
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
        
        
    }


}

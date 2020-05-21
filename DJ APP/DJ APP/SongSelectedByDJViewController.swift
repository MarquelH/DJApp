//
//  SongSelectedByDJViewController.swift
//  DJ APP
//
//  Created by Marquel Hendricks on 1/9/18.
//  Copyright © 2018 Marquel and Micajuine App Team. All rights reserved.
//

import UIKit

class SongSelectedByDJViewController: BaseTrackViewController {
    var songTableController: DJSongTableViewController?
    var index: Int?
    
        let trackAlbum: UILabel = {
            let tn = UILabel()
            tn.textColor = UIColor.white
            tn.textAlignment = .center
           tn.font = UIFont.boldSystemFont(ofSize: 14)
            tn.translatesAutoresizingMaskIntoConstraints = false
            tn.isUserInteractionEnabled = true
            return tn
       }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        trackArtist.isUserInteractionEnabled = true
        setupViews()
    }
    
    
    override func setupViews() {
        super.setupViews()
        
        if let track = self.track {
            trackAlbum.text = track.trackAlbum
        }
        else {
            print("Song Selected no track passed in")
        }
        
        cancelButton.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        mainview.addSubview(trackAlbum)
        mainview.addSubview(cancelButton)
        
        trackAlbum.centerXAnchor.constraint(equalTo: mainview.centerXAnchor).isActive = true
        trackAlbum.topAnchor.constraint(equalTo: trackArtist.bottomAnchor, constant: 8).isActive = true
        trackAlbum.widthAnchor.constraint(equalTo: mainview.widthAnchor, constant: -24).isActive = true
        trackAlbum.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        cancelButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        cancelButton.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        cancelButton.widthAnchor.constraint(equalTo: mainview.widthAnchor, constant: -72).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        print("DONE WITH CONSTRAINTS")
    }
    
    //check if parent still has DJ and such
    @objc func handleCancel()  {
        print("Cancel was clicked")
        
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //Change status bar background color
        //UIApplication.shared.statusBarView?.backgroundColor = UIColor.lightGray
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

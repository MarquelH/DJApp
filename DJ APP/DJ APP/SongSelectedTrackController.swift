//
//  SongSelectedTrackController.swift
//  DJ APP
//
//  Created by arturo ho on 12/27/17.
//  Copyright © 2017 Marquel and Micajuine App Team. All rights reserved.
//

import UIKit

class SongSelectedTrackController: BaseTrackViewController {
    
    var songTableController: SongTableViewController?
    var index: Int?
    
    let trackAlbum: UILabel = {
        let tn = UILabel()
        tn.textColor = UIColor.white
        tn.textAlignment = .center
        tn.font = UIFont.boldSystemFont(ofSize: 14)
        tn.translatesAutoresizingMaskIntoConstraints = false
        return tn
    }()
    
    lazy var thumbsUp: ProfileImageView = {
        let iv = ProfileImageView()
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    lazy var thumbsDown: ProfileImageView = {
        let iv = ProfileImageView()
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    let thumbsUpImage: UIImage = UIImage(named: "ThumbsUp")!
    let thumbsDownImage: UIImage = UIImage(named: "ThumbsDown")!

//    let upTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(thumbsUpTapped(tapGestureRecognizer:)))
//    upTapGestureRecognizer.numberOfTapsRequired = 1
    
    //    let downTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(thumbsDownTapped(tapGestureRecognizer:)))
//    upTapGestureRecognizer.numberOfTapsRequired
    
    lazy var upTapGestureRecognizer: UITapGestureRecognizer = {
        let gr = UITapGestureRecognizer(target: self, action: #selector(self.thumbsUpTapped(tapGestureRecognizer:)))
        gr.numberOfTapsRequired = 1
        return gr
    }()
    
    lazy var downTapGestureRecognizer: UITapGestureRecognizer = {
        let gr = UITapGestureRecognizer(target: self, action: #selector(self.thumbsDownTapped(tapGestureRecognizer:)))
        gr.numberOfTapsRequired = 1
        return gr
    }()


    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func thumbsUpTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        thumbsUp.image = thumbsUpImage.maskWithColor(color: UIColor.lightGray)
        thumbsUp.layer.borderColor = UIColor.lightGray.cgColor
        print("Up was tapped")
        self.dismiss(animated: true, completion: {() in

            if let parent = self.songTableController, let index = self.index {
                parent.addUpvote(index: index)
             }
            else {
                print("Parent or index sent was invalid")
            }
        })
    }
    
    func thumbsDownTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        thumbsDown.image = thumbsDownImage.maskWithColor(color: UIColor.lightGray)
        thumbsDown.layer.borderColor = UIColor.lightGray.cgColor
        print("Down was tapped")
        self.dismiss(animated: true, completion: {() in
            if let parent = self.songTableController, let index = self.index {
                parent.addDownvote(index: index)
            }
            else {
                print("Parent or index sent was invalid")
            }
        })

    }
    
    override func setupViews() {
        super.setupViews()
        
        if let track = self.track {
            trackAlbum.text = track.trackAlbum
        }
        else {
            print("Song Selected no track passed in")
        }
        
        thumbsUp.image = thumbsUpImage.maskWithColor(color: UIColor.green)
        thumbsDown.image = thumbsDownImage.maskWithColor(color: UIColor.red)
        thumbsUp.addGestureRecognizer(upTapGestureRecognizer)
        thumbsDown.addGestureRecognizer(downTapGestureRecognizer)
        cancelButton.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        mainview.addSubview(trackAlbum)
        mainview.addSubview(cancelButton)
        mainview.addSubview(thumbsUp)
        mainview.addSubview(thumbsDown)
        
        trackAlbum.centerXAnchor.constraint(equalTo: mainview.centerXAnchor).isActive = true
        trackAlbum.topAnchor.constraint(equalTo: trackArtist.bottomAnchor, constant: 8).isActive = true
        trackAlbum.widthAnchor.constraint(equalTo: mainview.widthAnchor, constant: -24).isActive = true
        trackAlbum.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        thumbsDown.centerXAnchor.constraint(equalTo: mainview.centerXAnchor, constant: -65).isActive = true
        thumbsDown.topAnchor.constraint(equalTo: trackAlbum.bottomAnchor, constant: 12).isActive = true
        thumbsDown.widthAnchor.constraint(equalToConstant: 85).isActive = true
        thumbsDown.heightAnchor.constraint(equalToConstant: 85).isActive = true
        
        thumbsUp.centerXAnchor.constraint(equalTo: mainview.centerXAnchor, constant: 65).isActive = true
        thumbsUp.topAnchor.constraint(equalTo: thumbsDown.topAnchor).isActive = true
        thumbsUp.widthAnchor.constraint(equalToConstant: 85).isActive = true
        thumbsUp.heightAnchor.constraint(equalToConstant: 85).isActive = true
        
        cancelButton.centerXAnchor.constraint(equalTo: mainview.centerXAnchor).isActive = true
        cancelButton.topAnchor.constraint(equalTo: thumbsUp.bottomAnchor, constant: 12).isActive = true
        cancelButton.widthAnchor.constraint(equalTo: mainview.widthAnchor, constant: -72).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
    }
    
    //check if parent still has DJ and such
    func handleCancel()  {
        print("Cancel was clicked")
        
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //Change status bar background color
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.lightGray
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

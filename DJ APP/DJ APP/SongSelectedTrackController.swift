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
    
    let thumbsUp: UIButton = {
        let iv = UIButton()
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        if let image = UIImage(named: "ThumbsUp"), let newImage = image.maskWithColor(color: UIColor.green) {
            iv.setImage(newImage, for: .normal)
        }
        iv.addTarget(self, action: #selector(thumbsUpTapped), for: .touchUpInside)
        return iv
    }()
    
    let thumbsDown: UIButton = {
        let iv = UIButton()
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        if let image = UIImage(named: "ThumbsDown"), let newImage = image.maskWithColor(color: UIColor.red) {
            iv.setImage(newImage, for: .normal)
        }
        iv.addTarget(self, action: #selector(thumbsDownTapped), for: .touchUpInside)
        return iv
    }()
    
    let trackAlbum: UIButton = {
        let iv = UIButton()
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.addTarget(self, action: #selector(albumTapped), for: .touchUpInside)
        return iv
    }()
    


    lazy var artistTapGestureRecognizer: UITapGestureRecognizer = {
        let gr = UITapGestureRecognizer(target: self, action: #selector(self.artistTapped(tapGestureRecognizer:)))
        gr.numberOfTapsRequired = 1
        return gr
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        trackArtist.isUserInteractionEnabled = true
        setupViews()
    }
    
    @objc func thumbsUpTapped() {
        self.dismiss(animated: true, completion: {() in

            if let parent = self.songTableController, let index = self.index {
                parent.addUpvote(index: index)
             }
            else {
                //print("Parent or index sent was invalid")
            }
        })
    }
    
    @objc func thumbsDownTapped() {
        self.dismiss(animated: true, completion: {() in
            if let parent = self.songTableController, let index = self.index {
                parent.addDownvote(index: index)
            }
            else {
                //print("Parent or index sent was invalid")
            }
        })

    }
    
    @objc func artistTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: {() in
            if let parent = self.songTableController, let artist = self.track?.trackArtist {
                parent.callSearch(str: artist)
            }
            else {
                //print("Parent or track sent was invalid")
            }
        })
    }
    
    @objc func albumTapped() {
        self.dismiss(animated: true, completion: {() in
            if let parent = self.songTableController, let album = self.track?.trackAlbum {
                parent.callSearch(str: album)
            }
            else {
                //print("Parent or track sent was invalid")
            }
        })
    }
    
    
    override func setupViews() {
        super.setupViews()
        
        if let track = self.track {
            trackAlbum.setTitle(track.trackAlbum, for: .normal)
        }
        else {
            //print("Song Selected no track passed in")
        }
        

        trackArtist.addGestureRecognizer(artistTapGestureRecognizer)
        
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
    @objc func handleCancel()  {
        //print("Cancel was clicked")
        
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

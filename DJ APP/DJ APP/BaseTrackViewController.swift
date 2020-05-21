//
//  BaseTrackViewController.swift
//  DJ APP
//
//  Created by arturo ho on 12/27/17.
//  Copyright © 2017 Marquel and Micajuine App Team. All rights reserved.
//

import UIKit

class BaseTrackViewController: UIViewController {
    
    var track: TrackItem?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Change status bar background color
        //UIApplication.shared.statusBarView?.backgroundColor = UIColor.black
    }
    
    func setTrackImage(urlString: String) {
        
        
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!, completionHandler: {(data, response, error) in
            if let error = error {
                print("Adding values error: \n")
                print(error.localizedDescription)
                return
            }
            
            DispatchQueue.main.async {
                if let imageData = data, let downloadedImage = UIImage(data: imageData) {
                    self.trackImageView.image = downloadedImage
                }
            }
            
        }).resume()
        
    }
    
  
    
    func setupViews() {
        if let trackImageAbsString = track?.trackImage?.addHTTPS()?.absoluteString.replaceWith600() {
            setTrackImage(urlString: trackImageAbsString)
        }
        else {
            print("Problem with absolute string")
        }
        trackName.text = track?.trackName
        trackArtist.text = track?.trackArtist
        trackName.font = UIFont(name: "BebasNeue-Regular", size : 20)
        trackArtist.font = UIFont(name: "BebasNeue-Regular", size : 20)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.view.addSubview(mainview)
        mainview.addSubview(trackImageView)
        mainview.addSubview(trackName)
        mainview.addSubview(trackArtist)
        
        
        mainview.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        mainview.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        mainview.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        mainview.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        
        
        trackImageView.centerXAnchor.constraint(equalTo: mainview.centerXAnchor).isActive = true
        trackImageView.topAnchor.constraint(equalTo: mainview.topAnchor, constant: 75).isActive = true
        trackImageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        trackImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        trackName.centerXAnchor.constraint(equalTo: mainview.centerXAnchor).isActive = true
        trackName.topAnchor.constraint(equalTo: trackImageView.bottomAnchor, constant: 24).isActive = true
        trackName.widthAnchor.constraint(equalTo: mainview.widthAnchor, constant: -24).isActive = true
        trackName.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        trackArtist.centerXAnchor.constraint(equalTo: mainview.centerXAnchor).isActive = true
        trackArtist.topAnchor.constraint(equalTo: trackName.bottomAnchor, constant: 8).isActive = true
        trackArtist.widthAnchor.constraint(equalTo: mainview.widthAnchor, constant: -24).isActive = true
        trackArtist.heightAnchor.constraint(equalToConstant: 24).isActive = true
    }
    
    let cancelButton: UIButton = {
        let cb = UIButton(type: .system)
        cb.setTitle("Cancel", for: .normal)
        cb.setTitleColor(UIColor.white, for: .normal)
        cb.backgroundColor = UIColor.darkGray
        cb.layer.cornerRadius = 24
        cb.layer.borderWidth = 1
        cb.layer.borderColor = UIColor.purple.cgColor
        cb.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        cb.translatesAutoresizingMaskIntoConstraints = false
        return cb
    }()
    
    let mainview: UIView = {
        let mv = UIView()
        mv.translatesAutoresizingMaskIntoConstraints = false
        mv.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        mv.isOpaque = false
        
        return mv
    }()
    
    let trackImageView: UIImageView = {
        let tiv = UIImageView()
        tiv.translatesAutoresizingMaskIntoConstraints = false
        tiv.contentMode = .scaleAspectFill
        return tiv
    }()
    
    let trackName: UILabel = {
        let tn = UILabel()
        tn.textColor = UIColor.white
        tn.textAlignment = .center
        tn.font = UIFont.boldSystemFont(ofSize: 24)
        tn.translatesAutoresizingMaskIntoConstraints = false
        return tn
    }()
    
    let trackArtist: UILabel = {
        let ta = UILabel()
        ta.textColor = UIColor.white
        ta.textAlignment = .center
        ta.font = UIFont.boldSystemFont(ofSize: 18)
        ta.translatesAutoresizingMaskIntoConstraints = false
        ta.isUserInteractionEnabled = true
        return ta
    }()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

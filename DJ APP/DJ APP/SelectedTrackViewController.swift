//
//  ViewController.swift
//  DJ APP
//
//  Created by arturo ho on 11/16/17.
//  Copyright © 2017 Marquel and Micajuine App Team. All rights reserved.
//

import UIKit
import Firebase

protocol SearchToSelectedProtocol {
    
    //Pass back dj reference
    func setSeachDJ(dj: UserDJ)
    
}

class SelectedTrackViewController: UIViewController {
    
    var delegate : SearchToSelectedProtocol?
    var track: TrackItem?
    var dj: UserDJ?
    var refSongList: DatabaseReference!
    var currentSnapshot: [String: AnyObject]?
   
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
        ta.font = UIFont.boldSystemFont(ofSize: 16)
        ta.translatesAutoresizingMaskIntoConstraints = false
        return ta
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

        if let uidKey = dj?.uid {
            refSongList = Database.database().reference().child("SongList").child(uidKey)
        }
        else {
            print("DJ does not have uid")
        }
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
    
    func songIsPresentInCurrentSnapshot() -> (isPresent: Bool, key: String) {

        guard let workingSnap = currentSnapshot else {
            print("Selected Track add, nothing in current snapshot")
            return (false, "")
        }
        
        for (key,value) in workingSnap {
            
            if value["name"] as? String == track?.trackName && value["artist"] as? String == track?.trackArtist {
                return (true, key)
            }
        }
        
        return (false, "")
    }
    
    func handleAdd() {
        print ("add")
        
        let isPresentTuple = songIsPresentInCurrentSnapshot()
        //it is present in the songlist
        if isPresentTuple.0 {
            print("the Key of the song to be updated is: \(isPresentTuple.1)")
            updateSongList(key: isPresentTuple.1)
            
        }
        //it isn't present in the songlist
        else {
            addToList()

        }
        

        dismiss(animated: true, completion: {
            //change this
            self.delegate?.setSeachDJ(dj: self.dj!)
        })
    }

    
    func updateSongList(key: String) {
        
        guard let workingSnap = self.currentSnapshot, let workingSong = workingSnap[key], var upvotes = workingSong["upvotes"] as? Int, var totalvotes = workingSong["totalvotes"] as? Int, let downvotes = workingSong["downvotes"] as? Int, let name = workingSong["name"] as? String, let artist = workingSong["artist"] as? String, let artwork = workingSong["artwork"] as? String, let id = workingSong["id"] as? String else {
            
            print("Current snapshot is empty.")
            return
        }
        upvotes = upvotes + 1
        totalvotes = totalvotes + 1

        let song = ["id": id, "name":name, "artist":artist, "artwork":artwork, "upvotes": upvotes, "downvotes":downvotes, "totalvotes":totalvotes] as [String : AnyObject]
        
        refSongList.child(key).setValue(song)
    }
    
    func addToList() {
        //Generate new key inside SongList node and return it
        let key = self.refSongList.childByAutoId().key

        //Create song object, and insert into node
        if let name = track?.trackName, let artist = track?.trackArtist, let artwork = track?.trackImage?.absoluteString {
            
            let song = ["id": key, "name":name, "artist":artist, "artwork":artwork, "upvotes": 1, "downvotes":0, "totalvotes":1] as [String : AnyObject]
            
            refSongList.child(key).setValue(song)
        }
        else {
            print("Track has no info in it")
        }
    }
    
    func handleCancel() {
        print ("cancel")
        dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        self.view.addSubview(mainview)
        if let trackImageAbsString = track?.trackImage?.addHTTPS()?.absoluteString.replaceWith600() {
            setTrackImage(urlString: trackImageAbsString)
        }
        else {
            print("Problem with absolute string")
        }
        trackName.text = track?.trackName
        trackArtist.text = track?.trackArtist
        mainview.addSubview(addButton)
        mainview.addSubview(cancelButton)
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
        
        addButton.centerXAnchor.constraint(equalTo: mainview.centerXAnchor).isActive = true
        addButton.topAnchor.constraint(equalTo: trackArtist.bottomAnchor, constant: 36).isActive = true
        addButton.widthAnchor.constraint(equalTo: mainview.widthAnchor, constant: -72).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        cancelButton.centerXAnchor.constraint(equalTo: mainview.centerXAnchor).isActive = true
        cancelButton.topAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 8).isActive = true
        cancelButton.widthAnchor.constraint(equalTo: addButton.widthAnchor).isActive = true
        cancelButton.heightAnchor.constraint(equalTo: addButton.heightAnchor).isActive = true
        
    }


}

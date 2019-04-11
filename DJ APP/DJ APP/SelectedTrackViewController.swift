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
    func setSeachDJandGuestID(dj: UserDJ, guestID: String)
    
}

class SelectedTrackViewController: BaseTrackViewController, FetchDataForSelectedTrack {

    var delegate : SearchToSelectedProtocol?
    var dj: UserDJ?
    var guestID: String?
    var refSongList: DatabaseReference!
    var refGuestByDJ: DatabaseReference!
    var tableSongList = [TrackItem]()
    var upvoteIDs: [String] = []
    var downvoteIDs: [String] = []
    var currentSnapshot: [String: AnyObject]?
    var homeTabController: HomeViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Set the reference to the dj selected
        if let uidKey = dj?.uid {
            refSongList = Database.database().reference().child("SongList").child(uidKey)
            //Set the reference to the guest
            if let id = self.guestID {
                refGuestByDJ = Database.database().reference().child("guests").child(id).child(uidKey)
                
            }
            else {
                print("Guest ID is not in SongTable viewDidLoad")
            }
            
        }
        else {
            print("DJ does not have uid")
        }
        guard let homeController = homeTabController else {
            print("Something wrong with tabbar controller")
            return
        }
        
        //Inital set up for SongList, Snapshot, and UP/Downvotes
        homeController.selectedTrackDelegate = self
        homeController.fetchSongList()
        homeController.fetchGuestUpVotesAndDownVotes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //Change status bar background color
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
    }
    
    
    // HELPERS --------------------
    
    func setSongList(fetchedSnapshot: [String : AnyObject], songTableList: [TrackItem]) {
        self.currentSnapshot = fetchedSnapshot
        self.tableSongList = songTableList
    }
    
    func setGuestByDJ(fetchedUpvote: [String], fetchedDownvote: [String]) {
        self.upvoteIDs = fetchedUpvote
        self.downvoteIDs = fetchedDownvote
    }
    
    //Might have to change this to pull data just before we add. But if we do this, not guarenteed to get the correct data
    @objc func handleAdd() {
        
        let isPresentTuple = songIsPresentInCurrentSnapshot()
        //it is present in the songlist
        if isPresentTuple.0 {
            
            //check if not in upvote
            if !upvoteIDs.contains(isPresentTuple.1) {
                
                //check if in downvote, if it is, then upvote by two and add to upvote
                if downvoteIDs.contains(isPresentTuple.1) {
                    if let index = downvoteIDs.index(of: isPresentTuple.1) {
                        downvoteIDs.remove(at: index)
                        upvoteIDs.append(isPresentTuple.1)
                        updateRefGuestByDJ()
                        addUpvoteToSong(key: isPresentTuple.1, amount: 1)

                    }
                }
                //else in neither, add to upvote and upvote by 1
                else {
                    upvoteIDs.append(isPresentTuple.1)
                    updateRefGuestByDJ()
                    addUpvoteToSong(key: isPresentTuple.1, amount: 1)

                }
            }
            //it is in upvote -> can't upvote again -> exit
        }
        //it isn't present in the songlist, so no upvotes or downvotes
        else {
            print("Song not present, must add")
            addToList()
        }
        dismiss(animated: true, completion: {
            if let dj = self.dj, let guestID = self.guestID {
                self.delegate?.setSeachDJandGuestID(dj: dj, guestID: guestID)
            }
            else {
                print("No DJ or Guest ID when selected Track being dismissed")
            }
        })
    }
    
    func updateRefGuestByDJ() {
        let value = ["upvotes": self.upvoteIDs, "downvotes": self.downvoteIDs]
        refGuestByDJ.setValue(value)
    }
    
    func songIsPresentInCurrentSnapshot() -> (isPresent: Bool, key: String) {

        guard let workingSnap = currentSnapshot else {
            return (false, "")
        }
        
        for (key,value) in workingSnap {
            
            if value["name"] as? String == track?.trackName && value["artist"] as? String == track?.trackArtist {
                return (true, key)
            }
        }
        
        return (false, "")
    }
    
    //Adds either 1 (or 2, and removes a downvote) upvotes to the Songlist through snapshot helper
    func addUpvoteToSong(key: String, amount: Int) {
       
        if let workingSnapshot = self.currentSnapshot {
            
            let song = SnapshotHelper.shared.updateTotalvotes(key: key, currentSnapshot: workingSnapshot, amount: amount)
            refSongList.child(key).setValue(song)

        }
        else {
            print("Attempting to upvote: snapshot is empty")
        }
    }
    
    func addToList() {
        //Generate new key inside SongList node and return it
        let key = self.refSongList.childByAutoId().key

        //Create song object, and insert into node
        if let name = track?.trackName, let artist = track?.trackArtist, let artwork = track?.trackImage?.absoluteString, let album = track?.trackAlbum, let accepted = track?.accepted {
            
            let song = ["id": key, "name":name, "artist":artist, "album": album, "artwork":artwork, "upvotes": 1, "downvotes":0, "totalvotes":1, "accepted":accepted] as [String : AnyObject]
            
            let theKey = key as! String
            refSongList.child(theKey).setValue(song)
            
            //update the upvoteIDs
            upvoteIDs.append(theKey)
            updateRefGuestByDJ()
        }
        else {
            print("Track has no info in it")
        }
    }
    
    @objc func handleCancel() {
        print ("cancel")
        dismiss(animated: true, completion: {
            if let dj = self.dj, let guestID = self.guestID {
                self.delegate?.setSeachDJandGuestID(dj: dj, guestID: guestID)
            }
            else {
                print("No DJ or Guest ID when selected Track being dismissed")
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        cancelButton.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)

        
        mainview.addSubview(addButton)
        mainview.addSubview(cancelButton)
        
        addButton.centerXAnchor.constraint(equalTo: mainview.centerXAnchor).isActive = true
        addButton.topAnchor.constraint(equalTo: trackArtist.bottomAnchor, constant: 36).isActive = true
        addButton.widthAnchor.constraint(equalTo: mainview.widthAnchor, constant: -72).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        
        cancelButton.centerXAnchor.constraint(equalTo: mainview.centerXAnchor).isActive = true
        cancelButton.topAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 8).isActive = true
        cancelButton.widthAnchor.constraint(equalTo: addButton.widthAnchor).isActive = true
        cancelButton.heightAnchor.constraint(equalTo: addButton.heightAnchor).isActive = true
    }

    
 
    let addButton: UIButton = {
        let ab = UIButton(type: .system)
        ab.setTitle("Request", for: .normal)
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



}

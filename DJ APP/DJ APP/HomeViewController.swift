//
//  HomeViewController.swift
//  DJ APP
//
//  Created by arturo ho on 12/23/17.
//  Copyright © 2017 Marquel and Micajuine App Team. All rights reserved.
//

import UIKit
import Firebase

protocol FetchDataForSongTable {
    func setSongList(fetchedSnapshot: [String: AnyObject], songTableList: [TrackItem])
    func setGuestByDJ(fetchedUpvote: [String], fetchedDownvote: [String])
}
protocol FetchDataForSelectedTrack {
    func setSongList(fetchedSnapshot: [String: AnyObject], songTableList: [TrackItem])
    func setGuestByDJ(fetchedUpvote: [String], fetchedDownvote: [String])
}

class HomeViewController: UIViewController {

    var djID: String?
    var guestID: String?
    var refSongList: DatabaseReference!
    var refGuestByDJ: DatabaseReference!
    var songListHandle: UInt?
    var guestHandle: UInt?
    var tableSongList = [TrackItem]()
    var upvoteIDs: [String] = []
    var downvoteIDs: [String] = []
    var currentSnapshot: [String: AnyObject]?
    var songTableDelegate: FetchDataForSongTable?
    var selectedTrackDelegate: FetchDataForSelectedTrack?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func setUpRefs(uidKey: String, id: String) {
        refSongList = Database.database().reference().child("SongList").child(uidKey)
        refGuestByDJ = Database.database().reference().child("guests").child(id).child(uidKey)
    }
    
    func fetchSongList() {
        
        songListHandle = refSongList.queryOrdered(byChild: "totalvotes").observe(.value, with: {(snapshot) in
        
            self.tableSongList.removeAll()
            
            //No Snap for Song list -> Remove all songs from song list, unless it was empty to begin with
            guard let workingSnap = snapshot.value as? [String: AnyObject] else {
                if var currSnap = self.currentSnapshot {
                    currSnap.removeAll()
                }
                //DELEGATE CALL HERE
                if let delegate = self.songTableDelegate {
                    if let workingSnap = self.currentSnapshot {
                        delegate.setSongList(fetchedSnapshot: workingSnap, songTableList: self.tableSongList)
                    }
                    else {
                        delegate.setSongList(fetchedSnapshot: [:], songTableList: self.tableSongList)
                    }
                }
                else {
                    print("Song Table delegate not set.")
                }
                
                if let delegate = self.selectedTrackDelegate {
                    if let workingSnap = self.currentSnapshot {
                        delegate.setSongList(fetchedSnapshot: workingSnap, songTableList: self.tableSongList)
                    }
                    else {
                        print("currentSnapshot not instantiated. ")
                    }
                }
                else {
                    print("Selected Track delegate not set.")
                }
                return
            }
            //Assign working snap to current snap
            self.currentSnapshot = workingSnap
            
            //SongList -> DJ ID -> [String: AnyObject]
            for snap in snapshot.children.allObjects as! [DataSnapshot] {
                
                if let value = snap.value as? [String: AnyObject], let name = value["name"] as? String, let artist = value["artist"] as? String, let artwork = value["artwork"] as? String, let id = value["id"] as? String, let upvotes = value["upvotes"] as? Int, let downvotes = value["downvotes"] as? Int, let totalvotes = value["totalvotes"] as? Int {
                    
                    let newTrack = TrackItem(trackName: name, trackArtist: artist, trackImage: artwork, id: id, upvotes: upvotes, downvotes: downvotes, totalvotes: totalvotes)
                    
                    self.tableSongList.insert(newTrack, at: 0)
                    //Delegate call here
                    
                }
            }
            //OR Delegate call here
            if let delegate = self.songTableDelegate {
                if let workingSnap = self.currentSnapshot {
                    delegate.setSongList(fetchedSnapshot: workingSnap, songTableList: self.tableSongList)
                }
                else {
                    print("currentSnapshot not instantiated. ")
                }
            }
            else {
                print("Song Table delegate not set.")
            }
            
            if let delegate = self.selectedTrackDelegate {
                if let workingSnap = self.currentSnapshot {
                    delegate.setSongList(fetchedSnapshot: workingSnap, songTableList: self.tableSongList)
                }
                else {
                    print("currentSnapshot not instantiated. ")
                }
            }
            else {
                print("Selected Track delegate not set.")
            }
        }, withCancel: {(error) in
            print("\(error.localizedDescription)")
        })
    }
    
    func fetchGuestUpVotesAndDownVotes() {
        
        guestHandle = refGuestByDJ.observe(.value, with: {(snapshot) in
            
            self.upvoteIDs.removeAll()
            self.downvoteIDs.removeAll()
            
            //No snap -> return empty lists
            guard let workingSnapshot = snapshot.value as? [String: AnyObject] else {
                //Delegate Call here
                if let delegate = self.songTableDelegate {
                    delegate.setGuestByDJ(fetchedUpvote: self.upvoteIDs, fetchedDownvote: self.downvoteIDs)
                }
                else {
                    print("Delegate not assigned")
                }
                if let delegate = self.selectedTrackDelegate {
                    delegate.setGuestByDJ(fetchedUpvote: self.upvoteIDs, fetchedDownvote: self.downvoteIDs)
                }
                else {
                    print("Delegate2 not assigned")
                }
                return
            }

            
            //Guests -> GuestID -> DJ ID -> [String:[Strubg]]
            if let value = workingSnapshot as? [String: [String]] {
                
                if let currUpvotes = value["upvotes"] {
                    self.upvoteIDs = currUpvotes
                }
                if let currDownvotes = value["downvotes"] {
                    self.downvoteIDs =  currDownvotes
                }
                
            //Delegate call here
                if let delegate = self.songTableDelegate {
                    delegate.setGuestByDJ(fetchedUpvote: self.upvoteIDs, fetchedDownvote: self.downvoteIDs)
                }
                else {
                    print("Delegate not assigned")
                }
                if let delegate = self.selectedTrackDelegate {
                    delegate.setGuestByDJ(fetchedUpvote: self.upvoteIDs, fetchedDownvote: self.downvoteIDs)
                }
                else {
                    print("Delegate2 not assigned")
                }
                
            }
            else {
                print("The types for fetching are wrong")
            }

        }, withCancel: {(error) in
            print(error.localizedDescription)})
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.parent?.dismiss(animated: true, completion: nil)
    }
    
    
    
}

//
//  SongTableViewController.swift
//  DJ APP
//
//  Created by arturo ho on 9/21/17.
//  Copyright © 2017 Marquel and Micajuine App Team. All rights reserved.
//

import UIKit
import Firebase


class SongTableViewController: UITableViewController, FetchDataForSongTable {

    var dj: UserDJ?
    var guestID: String?
    let trackCellId: String = "trackCellId"
    //Used for up and down arrows to send to database
    var currentSnapshot: [String: AnyObject]?
    var guestSnapshot: [String: AnyObject]?
    var refSongList: DatabaseReference!
    var refGuestByDJ: DatabaseReference!
    var tableSongList = [TrackItem]() {
        //do i have to dispatch main
        didSet{
            tableView.reloadData()
        }
    }
    var songListHandle: UInt?
    var guestHandle: UInt?
    var upvoteIDs: [String] = []
    var downvoteIDs: [String] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

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
        
        tableView.register(TrackCell.self, forCellReuseIdentifier: trackCellId)
        
        self.edgesForExtendedLayout = []
        //self.navigationController?.navigationBar.isTranslucent = false
        self.extendedLayoutIncludesOpaqueBars = true
        self.automaticallyAdjustsScrollViewInsets = true
        
     
        
        setupNavigationBar()
        setupViews()
        
        guard let homeTabController = self.tabBarController?.viewControllers?[0] as? HomeViewController else {
            print("Something wrong with tabbar controller")
            return
        }
        
        homeTabController.songTableDelegate = self
        homeTabController.fetchSongList()
        homeTabController.fetchGuestUpVotesAndDownVotes()
//        fetchSongList()
//        fetchGuestUpVotesAndDownVotes()
    }
    
    //HELPERS -------------------------
    func setGuestByDJ(fetchedUpvote: [String], fetchedDownvote: [String]) {
        self.upvoteIDs = fetchedUpvote
        self.downvoteIDs = fetchedDownvote
    }
    
    func setSongList(fetchedSnapshot: [String : AnyObject], songTableList: [TrackItem]) {
        self.currentSnapshot = fetchedSnapshot
        self.tableSongList = songTableList
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
//    func fetchGuestUpVotesAndDownVotes() {
//
//        guestHandle = refGuestByDJ.observe(.value, with: {(snapshot) in
//
//
//            print("Votes will be reloaded")
//
//            self.upvoteIDs.removeAll()
//            self.downvoteIDs.removeAll()
//
//            //No snap -> remove all from guessSnapShot unless none to begin with
//            guard let workingSnapshot = snapshot.value as? [String: AnyObject] else {
//
//                if var currSnap = self.guestSnapshot {
//                     currSnap.removeAll()
//                }
//
////                searchTrackTabController.guestSnapshot = self.guestSnapshot
//                return
//            }
//
//            //Assign working snapshot to guest snapshot
//            self.guestSnapshot = workingSnapshot
//
//            print("Current snapshot:")
//            dump(self.guestSnapshot)
//
//            //Assign selectedTrack guest snap to be our guestsnap
////            searchTrackTabController.guestSnapshot = self.guestSnapshot
//
//            //Guests -> GuestID -> DJ ID -> [String:[Strubg]]
//            if let value = workingSnapshot as? [String: [String]] {
//
//                if let currUpvotes = value["upvotes"] {
//                    self.upvoteIDs = currUpvotes
//                }
//                if let currDownvotes = value["downvotes"] {
//                    self.downvoteIDs =  currDownvotes
//                }
//
//                DispatchQueue.main.async {
//                    self.tableView.reloadData()
//                }
//
//            }
//            else {
//                print("The types for fetching are wrong")
//            }
//
//
//
//            }, withCancel: {(error) in
//                print(error.localizedDescription)})
//    }
    

    
//    func fetchSongList() {
//
//        songListHandle = refSongList.queryOrdered(byChild: "totalvotes").observe(.value, with: {(snapshot) in
////            guard let searchTrackTabController = self.tabBarController?.viewControllers?[2] as? SearchTrackViewController else {
////
////                print("Something wrong with tabbar controller")
////                return
////            }
//
//            //Change occured so remove all of the songs in tableSongList
//            self.tableSongList.removeAll()
//
//            //No Snap for Song list -> Remove all songs from song list, unless it was empty to begin with
//            guard let workingSnap = snapshot.value as? [String: AnyObject] else {
//                if var currSnap = self.currentSnapshot {
//                    currSnap.removeAll()
//                    DispatchQueue.main.async {
//                        self.tableView.reloadData()
//                    }
//                }
////                searchTrackTabController.currentSnapshot = self.currentSnapshot
//                return
//            }
//            //Assign working snap to current snap
//            self.currentSnapshot = workingSnap
//
//            //Assign selectedTrack current snap to be our working/current snap
////            searchTrackTabController.currentSnapshot = workingSnap
//
//
//            //SongList -> DJ ID -> [String: AnyObject]
//            for snap in snapshot.children.allObjects as! [DataSnapshot] {
//
//                if let value = snap.value as? [String: AnyObject], let name = value["name"] as? String, let artist = value["artist"] as? String, let artwork = value["artwork"] as? String, let id = value["id"] as? String, let upvotes = value["upvotes"] as? Int, let downvotes = value["downvotes"] as? Int, let totalvotes = value["totalvotes"] as? Int {
//
//                    let newTrack = TrackItem(trackName: name, trackArtist: artist, trackImage: artwork, id: id, upvotes: upvotes, downvotes: downvotes, totalvotes: totalvotes)
//
//                    self.tableSongList.insert(newTrack, at: 0)
//                    DispatchQueue.main.async {
//                        self.tableView.reloadData()
//                    }
//
//                }
//            }
//
//        }, withCancel: {(error) in
//            print("\(error.localizedDescription)")
//        })
//    }
    
    
    func upArrowTapped(tapGesture: UITapGestureRecognizer) {

        let taplocation = tapGesture.location(in: self.tableView)
        
        if let indexPath = self.tableView.indexPathForRow(at: taplocation), let workingSnapshot = self.currentSnapshot, let key = tableSongList[indexPath.row].id  {
  
            //Does not have an upvote for this song
            if !(self.upvoteIDs.contains(key)) {
                
                //Has a downvote, so remove from downvote
                if self.downvoteIDs.contains(key) {
                    if let index = self.downvoteIDs.index(of: key) {
                        self.downvoteIDs.remove(at: index)
                        let value = ["upvotes": self.upvoteIDs, "downvotes": self.downvoteIDs]
                        refGuestByDJ.setValue(value)
                    }
                    else {
                        print("Downvote said it contained key, but it can't find index")
                    }
                }
                
                    //does not have either, so add to upvote
                else {
                    self.upvoteIDs.append(key)
                    let value = ["upvotes": self.upvoteIDs, "downvotes": self.downvoteIDs]
                    refGuestByDJ.setValue(value)
                }
                
                let song = SnapshotHelper.shared.updateTotalvotes(key: key, currentSnapshot: workingSnapshot, num: 1)
                refSongList.child(key).setValue(song)
            }
            //Already has an upvote
            else {
                print("Already upvoted this guy, cannot upvote again. ")
            }

        }
        else {
            print("Issue with finding index path, workingSnapshot, or key from index path")
        }
    }
    
    func downArrowTapped(tapGesture: UITapGestureRecognizer) {
  
        let taplocation = tapGesture.location(in: self.tableView)
        if let indexPath = self.tableView.indexPathForRow(at: taplocation), let workingSnapshot = self.currentSnapshot, let key = tableSongList[indexPath.row].id  {
            
            ///Does not have an downvote for this song
            if !(self.downvoteIDs.contains(key)) {
                
                //Has a upvote, so remove from upvote
                if self.upvoteIDs.contains(key) {
                    if let index = self.upvoteIDs.index(of: key) {
                        self.upvoteIDs.remove(at: index)
                        let value = ["upvotes": self.upvoteIDs, "downvotes": self.downvoteIDs]
                        refGuestByDJ.setValue(value)
                    }
                    else {
                        print("Upvote said it contained key, but it can't find index")
                    }
                }
                    
                //does not have either, so add to downvote
                else {
                    self.downvoteIDs.append(key)
                    let value = ["upvotes": self.upvoteIDs, "downvotes": self.downvoteIDs]
                    refGuestByDJ.setValue(value)
                }
                
                let song = SnapshotHelper.shared.updateTotalvotes(key: key, currentSnapshot: workingSnapshot, num: -1)
                refSongList.child(key).setValue(song)
            }
            //Already has downvote
            else {
                print("Already downvoted this guy, cannot downvote again. ")
            }
            
        }
        else {
            print("Issue with finding index path, workingSnapshot, or key from index path")
        }
    }
    
    func setupNavigationBar() {
        
        //Back button
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .rewind, target: self, action: #selector(handleBack))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor(red: 214/255, green: 29/255, blue: 1, alpha:1.0)
        //Bar text
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "SudegnakNo2", size : 29) as Any]
        
        if let name = dj?.djName {
            self.navigationItem.title = "\(name)" + "'s Requests"
        }
        else {
            print("Nothing to see here")
        }
    }

    func setupViews() {
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.black
    }
    
    func handleBack() {
        self.parent?.dismiss(animated: true, completion: nil)
    }

   
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tableSongList.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: trackCellId, for: indexPath) as! TrackCell
        
        guard let name = tableSongList[indexPath.row].trackName, let artist = tableSongList[indexPath.row].trackArtist, let artwork = tableSongList[indexPath.row].trackImage, let totalvotes = tableSongList[indexPath.row].totalvotes, let key = tableSongList[indexPath.row].id else {
            
            print("Issue parsing from tableSongList")
            return cell
        }
        
        cell.textLabel?.text = "\(name)"
        cell.detailTextLabel?.text = "Artist: \(artist)"
        cell.totalvotesLabel.text = "\(totalvotes)"
    
        
        if let imageURL = artwork.addHTTPS()?.absoluteString.replaceWith60() {
            cell.profileImageView.loadImageWithChachfromUrl(urlString: imageURL)
        }
        else {
            print("problem with URL parsing")
        }
        
            
        let tapGestureUp = UITapGestureRecognizer(target: self, action: #selector(upArrowTapped(tapGesture:)))
        tapGestureUp.numberOfTapsRequired = 1
        
        let tapGestureDown = UITapGestureRecognizer(target: self, action: #selector(downArrowTapped(tapGesture:)))
        tapGestureDown.numberOfTapsRequired = 1
        
        
        cell.upArrowImageView.addGestureRecognizer(tapGestureUp)
        cell.downArrowImageView.addGestureRecognizer(tapGestureDown)
        
        
        //If the upvoteIDs or downvoteIDs array contains the key, do not add tapGesture
        if self.upvoteIDs.contains(key) {
            cell.upArrowSelected()
        }
        else if self.downvoteIDs.contains(key) {
            cell.downArrowSelected()
        }
        else {
            cell.noSelection()
        }
    
        return cell
    }
    
    
    
}


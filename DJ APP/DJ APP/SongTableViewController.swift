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
    var refSongList: DatabaseReference!
    var refGuestByDJ: DatabaseReference!
    var tableSongList = [TrackItem]()
    {
        //do i have to dispatch main
        didSet{
            tableView.reloadData()
        }
    }
    var upvoteIDs: [String] = []
    var downvoteIDs: [String] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.refreshData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("SongTable viewDidLoad")

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
    
    func upArrowTapped(tapGesture: UITapGestureRecognizer) {

        let taplocation = tapGesture.location(in: self.tableView)
        var song: [String:AnyObject]?
        
        if let indexPath = self.tableView.indexPathForRow(at: taplocation), let workingSnapshot = self.currentSnapshot, let key = tableSongList[indexPath.row].id  {
  
            //Does not have an upvote for this song
            if !(self.upvoteIDs.contains(key)) {
                
                //Has a downvote, so remove from downvote, and add to upvote (add 2 upvotes)
                if self.downvoteIDs.contains(key) {
                    
                    if let index = self.downvoteIDs.index(of: key) {
                        self.downvoteIDs.remove(at: index)
                        self.upvoteIDs.append(key)
                        let value = ["upvotes": self.upvoteIDs, "downvotes": self.downvoteIDs]
                        refGuestByDJ.setValue(value)
                        song = SnapshotHelper.shared.updateTotalvotes(key: key, currentSnapshot: workingSnapshot, amount: 2)
                        changeCellScore(index: indexPath.row, amount: 2)
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
                    song = SnapshotHelper.shared.updateTotalvotes(key: key, currentSnapshot: workingSnapshot, amount: 1)
                    changeCellScore(index: indexPath.row, amount: 1)
                }
                
                if let workingSong = song {
                    refSongList.child(key).setValue(workingSong)
                }
                else {
                    print("Adding total values to song was not successful")
                }
            }
            //Already has an upvote -> remove it
            else {
                if let index = self.upvoteIDs.index(of: key) {
                    self.upvoteIDs.remove(at: index)
                    let value = ["upvotes": self.upvoteIDs, "downvotes": self.downvoteIDs]
                    refGuestByDJ.setValue(value)
                    song = SnapshotHelper.shared.updateTotalvotes(key: key, currentSnapshot: workingSnapshot, amount: 3)
                    changeCellScore(index: indexPath.row, amount: 3)
                }
                else {
                    print("Upvote said it contained key, but it can't find index")
                }
                //store the change
                if let workingSong = song {
                    refSongList.child(key).setValue(workingSong)
                }
                else {
                    print("Adding totalvotes was unsucessful for downvote")
                }
                
            }

        }
        else {
            print("Issue with finding index path, workingSnapshot, or key from index path")
        }
        
        print("Relaoding Table")
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func downArrowTapped(tapGesture: UITapGestureRecognizer) {
  
        let taplocation = tapGesture.location(in: self.tableView)
        var song: [String: AnyObject]?
        
        if let indexPath = self.tableView.indexPathForRow(at: taplocation), let workingSnapshot = self.currentSnapshot, let key = tableSongList[indexPath.row].id  {
            
            ///Does not have an downvote for this song
            if !(self.downvoteIDs.contains(key)) {
                
                //Has a upvote, so remove from upvote and add to downvote (add 2 to downvote)
                if self.upvoteIDs.contains(key) {
                    if let index = self.upvoteIDs.index(of: key) {
                        self.upvoteIDs.remove(at: index)
                        self.downvoteIDs.append(key)
                        let value = ["upvotes": self.upvoteIDs, "downvotes": self.downvoteIDs]
                        refGuestByDJ.setValue(value)
                        song = SnapshotHelper.shared.updateTotalvotes(key: key, currentSnapshot: workingSnapshot, amount: -2)
                        changeCellScore(index: indexPath.row, amount: -2)
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
                    song = SnapshotHelper.shared.updateTotalvotes(key: key, currentSnapshot: workingSnapshot, amount: -1)
                    changeCellScore(index: indexPath.row, amount: -1)

                }
                
                if let workingSong = song {
                    refSongList.child(key).setValue(workingSong)
                }
                else {
                    print("Adding totalvotes was unsucessful for downvote")
                }
            }
            //Already has downvote, so remove it
            else {
                if let index = self.downvoteIDs.index(of: key) {
                    self.downvoteIDs.remove(at: index)
                    let value = ["upvotes": self.upvoteIDs, "downvotes": self.downvoteIDs]
                    refGuestByDJ.setValue(value)
                    song = SnapshotHelper.shared.updateTotalvotes(key: key, currentSnapshot: workingSnapshot, amount: -3)
                    changeCellScore(index: indexPath.row, amount: -3)
                }
                else {
                    print("Downvote said it contained key, but it can't find index")
                }
                //store the change
                if let workingSong = song {
                    refSongList.child(key).setValue(workingSong)
                }
                else {
                    print("Adding totalvotes was unsucessful for downvote")
                }
            }
         
        }
        else {
            print("Issue with finding index path, workingSnapshot, or key from index path")
        }
        
        print("Relaoding Table")
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func changeCellScore(index: Int, amount: Int) {
        let track = self.tableSongList[index]
        if let upvotes = track.upvotes, let downvotes = track.downvotes, let totalvotes = track.totalvotes {
            var result = SnapshotHelper.shared.changeAllScore(upvotes: upvotes, downvotes: downvotes, totalvotes: totalvotes, amount: amount)
            self.tableSongList[index].upvotes = result[0]
            self.tableSongList[index].downvotes = result[1]
            self.tableSongList[index].totalvotes = result[2]

        }
        else {
            print("Change Cell Score no data in track")
        }
    }
    
    func refreshData() {
        if let homeTabController = self.tabBarController?.viewControllers?[0] as? HomeViewController  {
            print("Fetching songlist and up/downvotes ")
            //Set the as the delegate
            homeTabController.songTableDelegate = self
            homeTabController.fetchGuestUpVotesAndDownVotes()
            homeTabController.fetchSongList()
        }
        else {
            print("Something wrong with tabbar controller")
        }
    }
    
    
    func setupNavigationBar() {
        
        //Back button
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .rewind, target: self, action: #selector(handleBack))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor(red: 214/255, green: 29/255, blue: 1, alpha:1.0)
        
        //Refresh button
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshData))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 214/255, green: 29/255, blue: 1, alpha:1.0)
        
        //Bar text
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "SudegnakNo2", size : 29) as Any]
        
        if let name = dj?.djName {
            self.navigationItem.title = "\(name)" + "'s Requests"
        }
        else {
            print("Dj Passed in has no name")
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
        
        print("totalvotes: \(tableSongList[indexPath.row].totalvotes)")
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


//
//  SongTableViewController.swift
//  DJ APP
//
//  Created by arturo ho on 9/21/17.
//  Copyright © 2017 Marquel and Micajuine App Team. All rights reserved.
//

import UIKit
import Firebase


class SongTableViewController: UITableViewController  {

    var dj: UserDJ?
    let trackCellId: String = "trackCellId"
    var currentSnapshot: [String: AnyObject]?
    var refSongList: DatabaseReference!
    var tableSongList = [TrackItem]() {
        //do i have to dispatch main
        didSet{
            tableView.reloadData()
        }
    }
    var handle: UInt?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        

        tableView.register(TrackCell.self, forCellReuseIdentifier: trackCellId)
        
        self.edgesForExtendedLayout = []
        //self.navigationController?.navigationBar.isTranslucent = false
        self.extendedLayoutIncludesOpaqueBars = true
        self.automaticallyAdjustsScrollViewInsets = true
        
        //Set the reference to the dj selected
        if let uidKey = dj?.uid {
            refSongList = Database.database().reference().child("SongList").child(uidKey)
        }
        else {
            print("DJ does not have uid")
        }
        
        setupNavigationBar()
        setupViews()
        fetchSongList()


    }
    
    //HELPERS -------------------------
    func fetchSongList() {
     
        handle = refSongList.queryOrdered(byChild: "totalvotes").observe(.value, with: {(snapshot) in
            
            //Make sure snapshot is there
            guard let workingSnap = snapshot.value as? [String: AnyObject] else {
                print("Snapshot.value is not OK")
                return
            }
            //Assign working snap to current snap
            self.currentSnapshot = workingSnap
    
        
            //Assign selectedTrack current snap to be our working/current snap
            if let searchTrackTabController = self.tabBarController?.viewControllers?[2] as? SearchTrackViewController {
                searchTrackTabController.currentSnapshot = workingSnap
                
            }
            else {
                print("Something wrong with tabbar controller")
            }
            
            
            //Change occured so remove all of the songs in tableSongList
            self.tableSongList.removeAll()
            
            //for (key, value) in workingSnap {
            for snap in snapshot.children.allObjects as! [DataSnapshot] {
                
                if let value = snap.value as? [String: AnyObject], let name = value["name"] as? String, let artist = value["artist"] as? String, let artwork = value["artwork"] as? String, let id = value["id"] as? String, let upvotes = value["upvotes"] as? Int, let downvotes = value["downvotes"] as? Int, let totalvotes = value["totalvotes"] as? Int {
                    
                    let newTrack = TrackItem(trackName: name, trackArtist: artist, trackImage: artwork, id: id, upvotes: upvotes, downvotes: downvotes, totalvotes: totalvotes)
                    
                    self.tableSongList.insert(newTrack, at: 0)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                }
            }
            
        }, withCancel: {(error) in
            print("\(error.localizedDescription)")
        })
    }
    
    
    func upArrowTapped(tapGesture: UITapGestureRecognizer) {
        print("Up Arrow was tapped")
        
        
    }
    
    func downArrowTapped(tapGesture: UITapGestureRecognizer) {
        print("Down Arrow was tapped")
        
        
    }
    
    func setupNavigationBar() {
        
        //Back button
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleBack))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor(red: 214/255, green: 29/255, blue: 1, alpha:1.0)
        //Bar
        self.navigationController?.navigationBar.barTintColor = UIColor.darkGray
        //Bar text
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.purple]
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "SudegnakNo2", size : 25) as Any]
        
        if let name = dj?.djName {
            self.navigationItem.title = "\(name)" + "'s Requests"
        }
        else {
            print("Nothing to see here")
        }
    }

    func setupViews() {
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.darkGray
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
        
        guard let name = tableSongList[indexPath.row].trackName, let artist = tableSongList[indexPath.row].trackArtist, let artwork = tableSongList[indexPath.row].trackImage else {
            
            print("Issue parsing from tableSongList")
            return cell
        }
        
        cell.textLabel?.text = "\(name)"
        cell.detailTextLabel?.text = "Artist: \(artist)"
        
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
        
        cell.upArrowImageView.tag = indexPath.row
        cell.downArrowImageView.tag = indexPath.row
        
        cell.upArrowImageView.addGestureRecognizer(tapGestureUp)
        cell.downArrowImageView.addGestureRecognizer(tapGestureDown)

                
        return cell
    }
    
    
    
}


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
    var tableSongList = [TrackItem]()

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
        print("Will now fetch songlist")
        refSongList.observe(.value, with: {(snapshot) in
            print("Recieved Snapshot")
            if snapshot.exists() {
                print("Snapshot exists")
            }
            else {
                print("Snapshot does not exist")
            }
            
            //Make sure snapshot is there
            guard let workingSnap = snapshot.value as? [String: AnyObject] else {
                print("Snapshot.value is not OK")
                return
            }
            //Assign working snap to current snap
            self.currentSnapshot = workingSnap
            print("SongTable working snap: ")
            dump(workingSnap)
            //Tell delegate to assign its current snap to be our working/current snap
            if let searchTrackTabController = self.tabBarController?.viewControllers?[2] as? SearchTrackViewController {
                searchTrackTabController.currentSnapshot = workingSnap
                
            }
            else {
                print("Something wrong with tabbar controller")
            }
            
            
            //Change occured so remove all of the songs in tableSongList
            self.tableSongList.removeAll()
            
            for (key, value) in workingSnap {
                
                var newTrack = TrackItem()
                
                newTrack.trackName = value["name"] as? String
                newTrack.trackArtist = value["artist"] as? String
                newTrack.id = key
                newTrack.downvotes = value["downvotes"] as? Int
                newTrack.upvotes = value["upvotes"] as? Int
                newTrack.totalvotes = value["totalvotes"] as? Int
                if let artwork = value["artwork"] as? String {
                    newTrack.trackImage = URL.init(string: artwork)
                }
                else {
                    print("artwork field for song \(newTrack.trackName ?? "trackName"), is nil")
                }
                
                self.tableSongList.append(newTrack)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            
        }, withCancel: {(error) in
            print("\(error.localizedDescription)")
        })
        
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
        return 5
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: trackCellId, for: indexPath) as! TrackCell
            
            cell.textLabel?.text = "Track \(indexPath.row)"
            cell.detailTextLabel?.text = "Artist: "
        
            cell.textLabel?.backgroundColor = UIColor.clear
            cell.detailTextLabel?.backgroundColor = UIColor.clear
        
            cell.detailTextLabel?.textColor = UIColor.white
            cell.textLabel?.textColor = UIColor.white
        
            cell.textLabel?.font = UIFont(name: "SudegnakNo2", size: 45)
            cell.detailTextLabel?.font = UIFont(name: "SudegnakNo2", size: 25)
        
            cell.backgroundColor = UIColor.black
        
        return cell
    }
    
    
    
}


//
//  DJSongTableViewController.swift
//  DJ APP
//
//  Created by Marquel Hendricks on 1/4/18.
//  Copyright © 2018 Marquel and Micajuine App Team. All rights reserved.
//

import UIKit
import Firebase

class DJSongTableViewController: UITableViewController {

    var dj: UserDJ?
    
    @IBOutlet weak var theNavItem: UINavigationItem!
    let djTrackCellId: String = "djTrackCellId"
    //Used for up and down arrows to send to database
    var currentSnapshot: [String: AnyObject]?
    var refSongList: DatabaseReference!
    var refEventList: DatabaseReference!
    var tableSongList = [TrackItem]()
    {
        //do i have to dispatch main
        didSet{
            tableView.reloadData()
        }
    }
    
    lazy var refreshController: UIRefreshControl = {
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(self.fetchSongList), for: UIControlEvents.valueChanged)
        rc.tintColor = UIColor.blue.withAlphaComponent(0.75)
        return rc
    }()
    
    let noRequestLabel: UILabel = {
        let nrl = UILabel()
        nrl.translatesAutoresizingMaskIntoConstraints = false
        nrl.textColor = UIColor.white
        nrl.text = "No songs requested yet!"
        nrl.font = UIFont(name: "Mikodacs", size: 20)
        nrl.textAlignment = .center
        //nrl.font = UIFont.boldSystemFont(ofSize: 20)
        nrl.lineBreakMode = .byWordWrapping
        nrl.numberOfLines = 0
        return nrl
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Set the reference to the dj selected & to the guest
        if let uidKey = dj?.uid {
            refSongList = Database.database().reference().child("SongList").child(uidKey)
            refEventList = Database.database().reference().child("Events")
        }
        else {
            print("DJ does not have uid")
        }
        setupNavigationBar()
        setupViews()
        fetchEventList()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()        
    }
    
    //HELPERS -------------------------
    
    func getSongSnapshot(){
        refSongList.observeSingleEvent(of: .value, with: {(snapshot) in
            if snapshot.exists() {
                print("snap exists")
            }
            else {
                print("snap does not exist")
            }
            DispatchQueue.main.async {
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    self.currentSnapshot = dictionary
                }
            }
        }, withCancel: nil)
    }
    
    func fetchEventList() {
        var hasEvent: Bool = false
        
        refEventList.observeSingleEvent(of: .value, with: {(snapshot) in
            
            self.tableSongList.removeAll()
            
            guard let workingSnap = snapshot.value as? [String: AnyObject] else {
                print("No snapshot for event")
                return
            }
            
            for (_,value) in workingSnap {
                //Find the events with the correct dj id
                if let uid = value["DjID"] as? String, uid == self.dj?.uid {

                    //check if the event time lines up
                    if let endTime = value["EndDateAndTime"] as? String, let startTime = value["StartDateAndTime"] as? String {
                        
                        
                        let currDateTime = Date()
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "M/dd/yy, h:mm a"
                        
                        guard let sd = dateFormatter.date(from: startTime), let ed = dateFormatter.date(from: endTime) else {
                            print("Failed converting the the dates")
                            return
                        }
                        
                        
                        
                        //Check if the current time is within the start and end times
                        //Add to the events list if it is.
                        if ((sd.timeIntervalSince1970) <= currDateTime.timeIntervalSince1970 &&
                            (ed.timeIntervalSince1970) >= currDateTime.timeIntervalSince1970) {
                            hasEvent = true

                        }
                    }
                }
            }
            
            if hasEvent {
                self.fetchSongList(found: true)
            }
            else {
                self.fetchSongList(found: false)
            }
            
            
        }, withCancel: {(error) in
            print(error.localizedDescription)
            return
        })
    }
    
    func fetchSongList(found: Bool) {
        if !found {
            refreshController.endRefreshing()
            displayLabel()
            return
        }
        refSongList.queryOrdered(byChild: "totalvotes").observeSingleEvent(of: .value, with: {(snapshot) in
            
            //No Snap for Song list -> Remove all songs from song list, unless it was empty to begin with
            guard let workingSnap = snapshot.value as? [String: AnyObject] else {
                if var currSnap = self.currentSnapshot {
                    currSnap.removeAll()
                }
                return
            }
            //self.getSongSnapshot()
            //self.setSongList(fetchedSnapshot: workingSnap, songTableList: self.tableSongList)
            
            self.currentSnapshot = workingSnap
            
            for snap in snapshot.children.allObjects as! [DataSnapshot] {
                
                if let value = snap.value as? [String: AnyObject], let name = value["name"] as? String, let artist = value["artist"] as? String, let artwork = value["artwork"] as? String, let id = value["id"] as? String, let upvotes = value["upvotes"] as? Int, let downvotes = value["downvotes"] as? Int, let totalvotes = value["totalvotes"] as? Int, let album = value["album"] as? String {
                    
                    let newTrack = TrackItem(trackName: name, trackArtist: artist, trackImage: artwork, id: id, upvotes: upvotes, downvotes: downvotes, totalvotes: totalvotes, trackAlbum: album)
                    
                    self.tableSongList.insert(newTrack, at: 0)
                    
                }
            }
            
            
        }, withCancel: {(error) in
            print(error.localizedDescription)
            return
        })
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        refreshController.endRefreshing()
        displayLabel()
    }

    
    
    func setupNavigationBar() {
        
        //Back button
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .rewind, target: self, action: #selector(handleLogout))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor(red: 214/255, green: 29/255, blue: 1, alpha:1.0)
        
        //Refresh button
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(fetchSongList))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 214/255, green: 29/255, blue: 1, alpha:1.0)
        
        //Bar text
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "SudegnakNo2", size : 29) as Any]
        
        if let name = dj?.djName{
            theNavItem.title = "\(name)" + "'s Requests"
        }
        else{
            print("No DJ Name")
        }
    }
    
    func setupViews() {
        self.tableView.register(djTrackCell.self, forCellReuseIdentifier: djTrackCellId)
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = UIColor.black
        self.tableView.refreshControl = refreshController
        
        self.edgesForExtendedLayout = []
        self.extendedLayoutIncludesOpaqueBars = true
        self.automaticallyAdjustsScrollViewInsets = true
        
        self.tableView.addSubview(noRequestLabel)
        noRequestLabel.centerXAnchor.constraint(equalTo: self.tableView.centerXAnchor).isActive = true
        noRequestLabel.centerYAnchor.constraint(equalTo: self.tableView.centerYAnchor).isActive = true
        noRequestLabel.widthAnchor.constraint(equalTo: self.tableView.widthAnchor).isActive = true
        noRequestLabel.heightAnchor.constraint(equalTo: self.tableView.heightAnchor).isActive = true
    }
    
    func displayLabel() {
        if tableSongList.isEmpty {
            print("EMPTY")
            noRequestLabel.isHidden = false
        }
        else {
            print("NOT EMPTY")
            noRequestLabel.isHidden = true
        }
    }
    
    func handleLogout() {
        let fireAuth = Auth.auth()
        
        do {
            try fireAuth.signOut()
        } catch let signoutError as NSError {
            print("Error signing out: %@", signoutError)
        }
        
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedSongTrack = SongSelectedByDJViewController()
        if self.presentedViewController != nil {
            //do i have to keep this? w
            self.dismiss(animated: true, completion: nil)
        }
        selectedSongTrack.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        selectedSongTrack.track = tableSongList[indexPath.row]
        selectedSongTrack.songTableController = self
        selectedSongTrack.index = indexPath.row
        self.tabBarController?.present(selectedSongTrack, animated: true, completion: {() in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: {() in
                self.tableView.deselectRow(at: indexPath, animated: false)
            })
        })
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if (tableSongList.count == 0 ){
            noRequestLabel.isHidden = false
        }
        else {
            noRequestLabel.isHidden = true
        }
        return tableSongList.count
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let accept = UITableViewRowAction(style: .normal, title: "Accept") { action, index in
            print("Accept tapped")
        }
        accept.backgroundColor = .green
        
        let deny = UITableViewRowAction(style: .destructive, title: "Deny") { action, index in
            print("Deny tapped")
        }
        //deny.backgroundColor = .red

        return [accept, deny]
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: djTrackCellId, for: indexPath) as! djTrackCell
        
        guard let name = tableSongList[indexPath.row].trackName, let artist = tableSongList[indexPath.row].trackArtist, let artwork = tableSongList[indexPath.row].trackImage, let totalvotes = tableSongList[indexPath.row].totalvotes, let _ = tableSongList[indexPath.row].id else {
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
        
        cell.noSelection()
        return cell
    }

}

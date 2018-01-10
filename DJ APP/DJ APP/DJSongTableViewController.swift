//
//  DJSongTableViewController.swift
//  DJ APP
//
//  Created by Marquel Hendricks on 1/4/18.
//  Copyright © 2018 Marquel and Micajuine App Team. All rights reserved.
//

import UIKit
import Firebase

class DJSongTableViewController: UITableViewController, FetchDataForSongTable {

    var dj: UserDJ?
    let djTrackCellId: String = "djTrackCellId"
    //Used for up and down arrows to send to database
    var currentSnapshot: [String: AnyObject]?
    var refSongList: DatabaseReference!
    var tableSongList = [TrackItem]()
    {
        //do i have to dispatch main
        didSet{
            tableView.reloadData()
            
            
        }
    }
    var upvoteIDs: [String] = []
    var downvoteIDs: [String] = []
    
    lazy var refreshController: UIRefreshControl = {
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(self.refreshData), for: UIControlEvents.valueChanged)
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
        self.refreshData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Set the reference to the dj selected & to the guest
        if let uidKey = dj?.uid {
            refSongList = Database.database().reference().child("SongList").child(uidKey)
        }
        else {
            print("DJ does not have uid")
        }
        
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
        
        displayLabel()
        refreshController.endRefreshing()
    }
    
    func refreshData() {
        if let homeTabController = self.tabBarController?.viewControllers?[0] as? HomeViewController  {
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
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .rewind, target: self, action: #selector(handleLogout))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor(red: 214/255, green: 29/255, blue: 1, alpha:1.0)
        
        //Refresh button
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshData))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 214/255, green: 29/255, blue: 1, alpha:1.0)
        
        //Bar text
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "SudegnakNo2", size : 29) as Any]
        
        if let name = dj?.djName {
            self.navigationController?.navigationItem.title = "\(name)" + "'s Requests"
        }
        else {
            print("Dj Passed in has no name")
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
            noRequestLabel.isHidden = false
        }
        else {
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
        return tableSongList.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: djTrackCellId, for: indexPath) as! djTrackCell
        
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
            cell.noSelection()
        
        return cell
    }

}

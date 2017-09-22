//
//  SongTableViewController.swift
//  DJ APP
//
//  Created by arturo ho on 9/21/17.
//  Copyright © 2017 Marquel and Micajuine App Team. All rights reserved.
//

import UIKit

class SongTableViewController: UITableViewController, UISearchControllerDelegate, UISearchBarDelegate {

    var dj: UserDJ?
    let searchBarCellId: String = "searchBarCellId"
    let trackCellId: String = "trackCellId"

    var trackSelector: TrackSearchTableViewController = TrackSearchTableViewController()

    
    lazy var searchController: UISearchController = {
       let sc = UISearchController(searchResultsController: self.trackSelector)
        sc.searchResultsUpdater = self.trackSelector
        //sc.searchBar.placeholder = "Search Tracks"
        sc.delegate = self
        sc.searchBar.delegate = self
        sc.hidesNavigationBarDuringPresentation = false
        sc.dimsBackgroundDuringPresentation = false
        sc.definesPresentationContext = true
        return sc
    }()
    
    let searchBarContainer: UIView = {
       let sbc = UIView()
        sbc.backgroundColor = UIColor.lightGray
        sbc.layer.cornerRadius = 5
        sbc.translatesAutoresizingMaskIntoConstraints = false
        return sbc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    func setupViews() {
        self.navigationItem.titleView = nil
        self.navigationItem.title = dj?.djName
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showSearchBar))
    }
    
    func showSearchBar() {
        self.navigationItem.rightBarButtonItem = nil
        self.navigationItem.titleView = self.searchController.searchBar
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: trackCellId, for: indexPath) as! TrackCell
            
            cell.textLabel?.text = "Track \(indexPath.row - 1)"
            cell.detailTextLabel?.text = "Artist: "
     
        return cell
    }
    
}


class TrackCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

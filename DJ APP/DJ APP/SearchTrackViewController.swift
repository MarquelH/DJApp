//
//  SearchTrackViewController.swift
//  DJ APP
//
//  Created by arturo ho on 9/22/17.
//  Copyright © 2017 Marquel and Micajuine App Team. All rights reserved.
//

import UIKit

class SearchTrackViewController: UITableViewController, UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate  {

    let trackCellId = "trackId"
    var tracks = ["Hello", "Goodbye", "Who's the goodest doggo?"]
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    
    lazy var searchController: UISearchController = {
       let sc = UISearchController(searchResultsController: nil)
        sc.searchResultsUpdater = self
        sc.searchBar.placeholder = "Search Tracks"
        sc.dimsBackgroundDuringPresentation = false
        sc.definesPresentationContext = true
        sc.hidesNavigationBarDuringPresentation = false
        sc.searchBar.searchBarStyle = .minimal
        sc.searchBar.tintColor = UIColor.lightGray
        sc.searchBar.backgroundColor = UIColor.black
        sc.searchBar.translatesAutoresizingMaskIntoConstraints = false
        return sc
    }()
    

    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func handleBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: trackCellId, for: indexPath) as! TrackCell
        
        cell.textLabel?.text = tracks[indexPath.row]
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.purple
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
        
        if (self.searchController.isActive) {
            self.searchController.isActive = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: UIApplication.shared.statusBarFrame.height, left: 0, bottom: 0, right: 0)
        setupTableView()
        self.tableView.register(TrackCell.self, forCellReuseIdentifier: trackCellId)
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
        print("I am updating from TrackSearchTableView")
    }
    
    func setupTableView() {
        tableView.tableHeaderView = searchController.searchBar
        
        let newBackgroundView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        newBackgroundView.backgroundColor = UIColor.purple
        tableView.backgroundView = newBackgroundView
    }
}

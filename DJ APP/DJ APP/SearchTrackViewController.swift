//
//  SearchTrackViewController.swift
//  DJ APP
//
//  Created by arturo ho on 9/22/17.
//  Copyright © 2017 Marquel and Micajuine App Team. All rights reserved.
//

import UIKit

class SearchTrackViewController: UIViewController, UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {

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
        sc.searchBar.translatesAutoresizingMaskIntoConstraints = false
        return sc
    }()
    
    lazy var trackTableView: UITableView = {
        let ttvc = UITableView()
        ttvc.dataSource = self
        ttvc.delegate = self
       ttvc.translatesAutoresizingMaskIntoConstraints = false
        return ttvc
    }()
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: trackCellId, for: indexPath) as! TrackCell
        
        cell.textLabel?.text = tracks[indexPath.row]
        
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.trackTableView.register(TrackCell.self, forCellReuseIdentifier: trackCellId)
        view.backgroundColor = UIColor.purple
        setupViews()
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        print("I am updating from TrackSearchTableView")
    }
    
    func setupViews() {
        view.addSubview(searchController.searchBar)
        view.addSubview(trackTableView)
        
        searchController.searchBar.topAnchor.constraint(equalTo: view.topAnchor, constant: UIApplication.shared.statusBarFrame.height).isActive = true
        searchController.searchBar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        searchController.searchBar.heightAnchor.constraint(equalToConstant: 40).isActive = true
        searchController.searchBar.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        trackTableView.topAnchor.constraint(equalTo: searchController.searchBar.bottomAnchor).isActive = true
        trackTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        trackTableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        trackTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        
    }
}

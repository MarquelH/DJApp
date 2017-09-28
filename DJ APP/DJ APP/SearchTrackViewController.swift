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
//    
//    let backButton: UIButton = {
//        let bb = UIButton()
//        bb.setTitle("Back", for: .normal)
//        bb.translatesAutoresizingMaskIntoConstraints = false
//        bb.setTitleColor(UIColor.lightGray, for: .normal)
//        bb.tintColor = UIColor.clear
//        bb.backgroundColor = UIColor.purple
//        bb.translatesAutoresizingMaskIntoConstraints = false
//        bb.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
//        return bb
//    }()
    
    lazy var searchController: UISearchController = {
       let sc = UISearchController(searchResultsController: nil)
        sc.searchResultsUpdater = self
        sc.searchBar.placeholder = "Search Tracks"
        sc.dimsBackgroundDuringPresentation = false
        sc.definesPresentationContext = true
        sc.hidesNavigationBarDuringPresentation = false
        sc.searchBar.searchBarStyle = .minimal
        sc.searchBar.tintColor = UIColor.lightGray
        sc.searchBar.backgroundColor = UIColor.purple
        sc.searchBar.translatesAutoresizingMaskIntoConstraints = false
        return sc
    }()
    
//    lazy var searchView: UIView = {
//       let sv = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40))
//        sv.backgroundColor = UIColor.black
//        return sv
//    }()
//    
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
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        self.tableView.register(TrackCell.self, forCellReuseIdentifier: trackCellId)
        self.navigationController?.extendedLayoutIncludesOpaqueBars = true
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
        print("I am updating from TrackSearchTableView")
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableHeaderView = searchController.searchBar
        
//        searchController.searchBar.topAnchor.constraint(equalTo: searchView.topAnchor).isActive = true
//        searchController.searchBar.rightAnchor.constraint(equalTo: searchView.rightAnchor).isActive = true
//        searchController.searchBar.widthAnchor.constraint(equalTo: searchView.widthAnchor, multiplier: 5/6).isActive = true
//        searchController.searchBar.heightAnchor.constraint(equalTo: searchView.heightAnchor).isActive = true
        
//        backButton.topAnchor.constraint(equalTo: searchView.topAnchor).isActive = true
//        backButton.leftAnchor.constraint(equalTo: searchView.leftAnchor).isActive = true
//        backButton.widthAnchor.constraint(equalTo: searchView.widthAnchor, multiplier: 1/6).isActive = true
//        backButton.heightAnchor.constraint(equalTo: searchView.heightAnchor).isActive = true
//        
        let newBackgroundView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        newBackgroundView.backgroundColor = UIColor.purple
        tableView.backgroundView = newBackgroundView
    }
}

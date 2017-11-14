//
//  SearchTrackViewController.swift
//  DJ APP
//
//  Created by arturo ho on 9/22/17.
//  Copyright © 2017 Marquel and Micajuine App Team. All rights reserved.
//

import UIKit
import Alamofire

//UISearchResultsUpdating,
class SearchTrackViewController: UITableViewController, UISearchControllerDelegate, UISearchBarDelegate  {

    let trackCellId = "trackId"
    //var tracks = ["Hello", "Goodbye", "Who's the goodest doggo?"]
    var results = [TrackItem]() {
        didSet{
            tableView.reloadData()
        }
    }
    
    var searchText: String?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    
    lazy var searchController: UISearchController = {
       let sc = UISearchController(searchResultsController: nil)
        //sc.searchResultsUpdater = self
        sc.searchBar.placeholder = "Search Tracks"
        sc.dimsBackgroundDuringPresentation = false
        sc.definesPresentationContext = true
        sc.hidesNavigationBarDuringPresentation = false
        sc.searchBar.searchBarStyle = .minimal
        sc.searchBar.tintColor = UIColor.lightGray
        sc.searchBar.backgroundColor = UIColor.black
        var textField = sc.searchBar.value(forKey: "searchField") as? UITextField
        textField?.textColor = UIColor.lightGray
        sc.searchBar.translatesAutoresizingMaskIntoConstraints = false
        sc.searchBar.delegate = self
        return sc
    }()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: UIApplication.shared.statusBarFrame.height, left: 0, bottom: 0, right: 0)
        setupTableView()
        self.tableView.register(TrackCell.self, forCellReuseIdentifier: trackCellId)
    }
    
    func callAlamo(url: String) {
        
    }
    
    func search() {
        print("I am going to call the api service")
        guard let text = self.searchText else {
            print("text is empty")
            return
        }
        ApiService.shared.fetchResults(term: text) { items in
            self.results = items
        }
        
    }
    
  
    
//    func updateSearchResults(for searchController: UISearchController) {
//    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(search), object: nil)
        self.perform(#selector(search), with: nil, afterDelay: 0.5)
    }
    
    func setupTableView() {
        tableView.tableHeaderView = searchController.searchBar
        
        let newBackgroundView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        newBackgroundView.backgroundColor = UIColor.purple
        tableView.backgroundView = newBackgroundView
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func handleBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: trackCellId, for: indexPath) as! TrackCell
        
        let track = results[indexPath.row]
        
        cell.textLabel?.text = track.trackName
        cell.detailTextLabel?.text = track.trackArtist
        
        if let imageURL = track.trackImage?.absoluteString {
            cell.profileImageView.loadImageWithChachfromUrl(urlString: imageURL)

        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
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
    
}

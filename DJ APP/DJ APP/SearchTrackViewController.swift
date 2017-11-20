//
//  SearchTrackViewController.swift
//  DJ APP
//
//  Created by arturo ho on 9/22/17.
//  Copyright © 2017 Marquel and Micajuine App Team. All rights reserved.
//

import UIKit

//UISearchResultsUpdating,
class SearchTrackViewController: UITableViewController, UISearchControllerDelegate, UISearchBarDelegate  {

    let searchCellId = "searchCellId"
    var searchText: String?

    var results = [TrackItem]() {
        didSet{
            tableView.reloadData()
            if (results.count == 0) {
                turnScrollAndBouncOff()
            }
            else {
                turnScrollAndBounceOn()
            }
        }
    }
    
    
    var noResults: UIImageView = {
       let nr = UIImageView(image: UIImage(named: "no-results"))
        nr.contentMode = .scaleAspectFit
        return nr
    }()
    
    lazy var searchController: UISearchController = {
       let sc = UISearchController(searchResultsController: nil)
        sc.searchBar.placeholder = "Search Tracks"
        sc.dimsBackgroundDuringPresentation = false
        sc.definesPresentationContext = true
        //sc.hidesNavigationBarDuringPresentation = false
        sc.searchBar.searchBarStyle = .minimal
        sc.searchBar.tintColor = UIColor.white
        sc.searchBar.backgroundColor = UIColor.darkGray
        //Change color of searching text
        var textField = sc.searchBar.value(forKey: "searchField") as? UITextField
        textField?.textColor = UIColor.white
        
        //Change color of placeholder text
        var placeholderTextLabel = textField?.value(forKey: "placeholderLabel") as? UILabel
        placeholderTextLabel?.textColor = UIColor.white
        sc.searchBar.delegate = self
        return sc
    }()
    
    
    //VIEW ---------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Register reusable cell with class
        self.tableView.register(SearchCell.self, forCellReuseIdentifier: searchCellId)

        setupTableView()
        turnScrollAndBouncOff()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Change status bar background color
        //UIApplication.shared.statusBarView?.backgroundColor = UIColor.black
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
        
        if (self.searchController.isActive) {
            self.searchController.isActive = false
        }
    }

    
    // HELPERS -------------
    
    func search() {
        guard let text = self.searchText else {
            print("text is empty")
            return
        }
        ApiService.shared.fetchResults(term: text) { items in
            self.results = items
        }
    }
    
    func threeDotsTapped(tapGesture: UITapGestureRecognizer) {
        print ("I was tapped")
        if let index = tapGesture.view?.tag {
       
            let selectedTrack = SelectedTrackViewController()
            selectedTrack.track = results[index]
            present(selectedTrack, animated: true, completion: nil)

            //present new view 
        }
    }
    
    func turnScrollAndBouncOff() {
        tableView.bounces = false
        tableView.alwaysBounceVertical = false
    }
    
    func turnScrollAndBounceOn() {
        tableView.bounces = true
        tableView.alwaysBounceVertical = true
    }
    
    //SEARCH BAR ------
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("I was tapped")
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        if (!(searchController.searchBar.text?.isEmpty)!) {
            self.searchText = searchText
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(search), object: nil)
            self.perform(#selector(search), with: nil, afterDelay: 0.5)
        }
        else {
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(search), object: nil)
            results.removeAll()
        }
        
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        results.removeAll()
    }
    
    
    
    //TABLE VIEW --------------
    
    func setupTableView() {
        //UIApplication.shared.statusBarFrame.height
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: (tabBarController?.tabBar.frame.height)!, right: 0)
        
        tableView.separatorStyle = .none
        tableView.tableHeaderView = searchController.searchBar
        tableView.backgroundColor = UIColor.darkGray
        tableView.backgroundView = noResults
        

    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: searchCellId, for: indexPath) as! SearchCell
        
        let track = results[indexPath.row]
        
        cell.textLabel?.text = track.trackName
        cell.detailTextLabel?.text = track.trackArtist
        
        if let imageURL = track.trackImage?.absoluteString {
            cell.profileImageView.loadImageWithChachfromUrl(urlString: imageURL)
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(threeDotsTapped(tapGesture:)))
        tapGesture.numberOfTapsRequired = 1
        cell.threeDots.tag = indexPath.row
        cell.threeDots.addGestureRecognizer(tapGesture)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

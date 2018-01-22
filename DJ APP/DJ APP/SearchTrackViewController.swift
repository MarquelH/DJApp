//
//  SearchTrackViewController.swift
//  DJ APP
//
//  Created by arturo ho on 9/22/17.
//  Copyright © 2017 Marquel and Micajuine App Team. All rights reserved.
//

import UIKit
import Firebase

class SearchTrackViewController: UITableViewController, UISearchControllerDelegate, UISearchBarDelegate, SearchToSelectedProtocol  {
    
    let searchCellId = "searchCellId"
    var searchText: String?
    var dj: UserDJ?
    var guestID: String?
    var currentSnapshot: [String: AnyObject]?
    var guestSnapshot: [String: AnyObject]?


    
    var results = [TrackItem]() {
        didSet{
            tableView.reloadData()
        }
    }
    
    
    var noResults: UIImageView = {
       let nr = UIImageView(image: UIImage(named: "no-results"))
        nr.contentMode = .scaleAspectFit
        return nr
    }()
    
    lazy var searchController: UISearchController = {
       let sc = UISearchController(searchResultsController: nil)
        sc.searchBar.placeholder = "Search Tracks, Artist, or Albums"
        sc.dimsBackgroundDuringPresentation = false
        sc.hidesNavigationBarDuringPresentation = false
        sc.searchBar.searchBarStyle = .minimal
        //sc.searchBar.barTintColor =
        //sc.searchBar.tintColor = UIColor.white
        //sc.searchBar.backgroundColor = UIColor.lightGray
        //Change color of searching text
        var textField = sc.searchBar.value(forKey: "searchField") as? UITextField
        textField?.textColor = UIColor.white
        
        //Change color of placeholder text
        var placeholderTextLabel = textField?.value(forKey: "placeholderLabel") as? UILabel
        placeholderTextLabel?.textColor = UIColor.white
        sc.searchBar.delegate = self
        sc.definesPresentationContext = true

        //definesPresentationContext = true
        return sc
    }()
    
    
    //VIEW ---------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Need this to display the next screen
        self.definesPresentationContext = true
        
        //Register reusable cell with class
        self.tableView.register(SearchCell.self, forCellReuseIdentifier: searchCellId)

        
        setupTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available (iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = false
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if #available (iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = true
        }
    }
    
    // HELPERS -------------
    
    func setSeachDJandGuestID(dj: UserDJ, guestID: String) {
        self.dj = dj
        self.guestID = guestID
    }
    
    func search() {
        guard let text = self.searchText else {
            print("text is empty")
            return
        }
        ApiService.shared.fetchResults(term: text) { items in
            self.results = items
        }
    }
    
    func presentSelectedTrackController(index: Int) {
        let selectedTrack = SelectedTrackViewController()
        if self.presentedViewController != nil {
            //do i have to keep this? w
            self.dismiss(animated: true, completion: nil)
        }
        selectedTrack.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        selectedTrack.track = results[index]
        selectedTrack.dj = dj
        selectedTrack.delegate = self
  
        if let workingID = guestID, let homeController = self.tabBarController?.viewControllers?[0] as? HomeViewController {
            selectedTrack.guestID = workingID
            selectedTrack.homeTabController = homeController
        }
        else {
            print("NO Guest ID or homeTabController being sent to Selected Track")
        }
        
        self.tabBarController?.present(selectedTrack, animated: true, completion: nil)
    }
    
    
    //SEARCH BAR ------
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
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

        navigationItem.title = "Search"
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "SudegnakNo2", size : 35) as Any]
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
            navigationItem.searchController = self.searchController  
        }
        else {
            tableView.tableHeaderView = searchController.searchBar
        }

        let navBarHeight = (self.navigationController?.navigationBar.frame.size.height)! + (self.navigationController?.navigationBar.frame.origin.y)!
        let seachBarHeight = self.searchController.searchBar.frame.size.height + self.searchController.searchBar.frame.origin.y
        
        tableView.contentInset = UIEdgeInsets(top: seachBarHeight + navBarHeight + 10.0, left: 0, bottom: (tabBarController?.tabBar.frame.height)!, right: 0)

        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.darkGray
        tableView.backgroundView = noResults
        tableView.separatorColor = UIColor(red: 214/255, green: 29/255, blue: 1, alpha:0.9)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presentSelectedTrackController(index: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: searchCellId, for: indexPath) as! SearchCell
        
        let track = results[indexPath.row]
        
        cell.textLabel?.text = track.trackName
        cell.detailTextLabel?.text = track.trackArtist
        
        cell.textLabel?.font = UIFont(name: "Mikodacs", size : 19)
        cell.detailTextLabel?.font = UIFont(name: "Mikodacs", size : 15)
        
        
        if let imageURL = track.trackImage?.addHTTPS()?.absoluteString.replaceWith60() {

            cell.profileImageView.loadImageWithChachfromUrl(urlString: imageURL)
        }
        else {
            print("problem with URL parsing")
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

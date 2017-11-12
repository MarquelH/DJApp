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
    var tracks = ["Hello", "Goodbye", "Who's the goodest doggo?"]
    var searchText: String?
    typealias JSONStandard = [String : AnyObject]
    
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
        guard let text = self.searchText?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            return
        }
        
        
        //let query = "https://api.spotify.com/v1/search?q=" + text + "&type=track,artist,album"
        let query = "https://itunes.apples.com/search?term=" + text + "&entity=music&limit=20"
        //print(query)
        
        Alamofire.request(query).response(completionHandler: {
            response in
            if let data = response.data {
                self.parseData(JSONData: data)
            }
            else {
                print ("Query Empty")
            }
        })
    }
    
    func parseData(JSONData: Data) {
        do {
            var readableJSON = try JSONSerialization.jsonObject(with: JSONData, options: .mutableContainers) as? JSONStandard
            print(readableJSON!)
            
            
            
        }
        catch {
            print(error)
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
    
}

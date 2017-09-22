//
//  SearchTrackViewController.swift
//  DJ APP
//
//  Created by arturo ho on 9/22/17.
//  Copyright © 2017 Marquel and Micajuine App Team. All rights reserved.
//

import UIKit

class SearchTrackViewController: UIViewController, UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate {

    lazy var searchController: UISearchController = {
       let sc = UISearchController(searchResultsController: nil)
        sc.searchResultsUpdater = self
        sc.searchBar.placeholder = "Search Tracks"
        sc.delegate = self
        sc.searchBar.delegate = self
        sc.hidesNavigationBarDuringPresentation = false
        sc.dimsBackgroundDuringPresentation = false
        sc.definesPresentationContext = true
        sc.searchBar.translatesAutoresizingMaskIntoConstraints = false
        return sc
    }()
    
    
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
        setupViews()
        view.backgroundColor = UIColor.black
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        print("I am updating from TrackSearchTableView")
    }
    
    func setupViews() {
        
    }
}

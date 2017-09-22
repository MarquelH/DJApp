//
//  TrackSearchTableViewController.swift
//  DJ APP
//
//  Created by arturo ho on 9/21/17.
//  Copyright © 2017 Marquel and Micajuine App Team. All rights reserved.
//

import UIKit

class TrackSearchTableViewController: UITableViewController, UISearchResultsUpdating {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = UIColor.black

    }

 
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    func updateSearchResults(for searchController: UISearchController) {
        print("I am updating from TrackSearchTableView")
    }
}

//
//  SongTableViewController.swift
//  DJ APP
//
//  Created by arturo ho on 9/21/17.
//  Copyright © 2017 Marquel and Micajuine App Team. All rights reserved.
//

import UIKit

class SongTableViewController: UITableViewController  {

    var dj: UserDJ?
    let trackCellId: String = "trackCellId"

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(TrackCell.self, forCellReuseIdentifier: trackCellId)
        setupViews()
    }

    func setupViews() {
        if let name = dj?.djName {
            self.navigationItem.title = "\(name)" + "'s List"
        }

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showSearchBar))
    }
    
    func showSearchBar() {
        let searchTrackController = SearchTrackViewController()
        self.navigationController?.pushViewController(searchTrackController, animated: true)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: trackCellId, for: indexPath) as! TrackCell
            
            cell.textLabel?.text = "Track \(indexPath.row)"
            cell.detailTextLabel?.text = "Artist: "
     
        return cell
    }
    
}


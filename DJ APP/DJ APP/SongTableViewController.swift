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
    var customTabBarController: CustomTabBarController?
    let trackCellId: String = "trackCellId"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
        tableView.register(TrackCell.self, forCellReuseIdentifier: trackCellId)
        setupViews()
    }

    func setupViews() {
        if let name = dj?.djName {
            self.navigationItem.title = "\(name)" + "'s List"
        }
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleBack))
    }
    
    func handleBack() {
        self.customTabBarController?.dissmissTabBar()
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: trackCellId, for: indexPath) as! TrackCell
            
            cell.textLabel?.text = "Track \(indexPath.row)"
            cell.detailTextLabel?.text = "Artist: "
     
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {

    }
    
}


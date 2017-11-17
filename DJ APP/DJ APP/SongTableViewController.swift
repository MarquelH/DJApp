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
        tableView.register(TrackCell.self, forCellReuseIdentifier: trackCellId)
        
        self.edgesForExtendedLayout = []
        self.navigationController?.navigationBar.isTranslucent = false
        self.extendedLayoutIncludesOpaqueBars = true
        self.automaticallyAdjustsScrollViewInsets = true
        
        //self.tableView.backgroundColor = UIColor.black
        setupViews()

    }

    func setupViews() {
        //Fonts
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Exo-Thin", size : 21) as Any]
        self.navigationController?.tabBarController?.tabBar.barTintColor = UIColor.black
        self.navigationController?.tabBarController?.tabBar.tintColor = UIColor(red: 214/255, green: 29/255, blue: 1, alpha:1.0)
        
        if let name = dj?.djName {
            self.navigationItem.title = "\(name)" + "'s Requests"
        }
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleBack))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor(red: 214/255, green: 29/255, blue: 1, alpha:1.0)
        
        tableView.separatorStyle = .none
    }
    
    func handleBack() {
        self.customTabBarController?.dissmissTabBar()
    }

   
    


    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: trackCellId, for: indexPath) as! TrackCell
            
            cell.textLabel?.text = "Track \(indexPath.row)"
            cell.detailTextLabel?.text = "Artist: "
        
            cell.textLabel?.backgroundColor = UIColor.clear
            cell.detailTextLabel?.backgroundColor = UIColor.clear
        
            cell.detailTextLabel?.textColor = UIColor.white
            cell.textLabel?.textColor = UIColor.white
        
            cell.textLabel?.font = UIFont(name: "SudegnakNo2", size: 45)
            cell.detailTextLabel?.font = UIFont(name: "SudegnakNo2", size: 25)
        
            cell.backgroundColor = UIColor.black
            
        
     
        return cell
    }
    
    
    
}


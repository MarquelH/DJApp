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

        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Exo-Thin", size : 17) as Any]
        self.navigationController?.tabBarController?.tabBar.barTintColor = UIColor.black
        self.navigationController?.tabBarController?.tabBar.tintColor = UIColor(red: 214/255, green: 29/255, blue: 1, alpha:1.0)

        let backgroundImage: UIImageView = UIImageView(frame: view.bounds)
        backgroundImage.image = UIImage(named: "headphonesImage")
        backgroundImage.contentMode = .scaleAspectFill
        
        //view.insertSubview(backgroundImage, at: 0)
        tableView.backgroundView = backgroundImage
        setupViews()
        tableView.backgroundColor = UIColor.black
        tableView.separatorStyle = .none
        //self.tabBarController?.tabBar.barTintColor = UIColor(red: 214/255, green: 29/255, blue: 1, alpha:1.0)
    }

    func setupViews() {
        if let name = dj?.djName {
            self.navigationItem.title = "\(name)" + "'s List"
        }
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleBack))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor(red: 214/255, green: 29/255, blue: 1, alpha:1.0)
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

        
            cell.detailTextLabel?.textColor = UIColor.white
            cell.textLabel?.textColor = UIColor.white
        
            cell.textLabel?.font = UIFont(name: "Exo-Thin", size: 17)
            cell.detailTextLabel?.font = UIFont(name: "Exo-Thin", size: 13)
        
            cell.backgroundColor = UIColor.black
            
        

            cell.textLabel?.textColor = UIColor.white.withAlphaComponent(1.5)
            cell.textLabel?.font = UIFont(name: "Exo-Thin", size: 24)
     
            cell.detailTextLabel?.textColor = UIColor.white.withAlphaComponent(1.5)
            cell.detailTextLabel?.font = UIFont(name: "Exo-Thin", size: 15)


        
        if (indexPath.row % 3 == 0){
            //cell.backgroundColor = UIColor(red: 214/255, green: 29/255, blue: 1, alpha:1.0)
            cell.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        }
        else if (indexPath.row % 2 == 0){
            //cell.backgroundColor = UIColor(red: 214/255, green: 29/255, blue: 1, alpha:0.5)
            cell.backgroundColor = UIColor.lightGray.withAlphaComponent(0.8)
            
        }
        else{
            //cell.backgroundColor = UIColor(red: 214/255, green: 29/255, blue: 1, alpha:0.25)
            cell.backgroundColor = UIColor(red: 214/255, green: 29/255, blue: 1, alpha:0.8)
            
        }

        
        
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {

    }
    
}


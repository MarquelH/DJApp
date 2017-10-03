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
        let backgroundImage: UIImageView = UIImageView(frame: view.bounds)
        backgroundImage.image = UIImage(named: "headphonesImage")
        backgroundImage.contentMode = .scaleAspectFill
        
        //view.insertSubview(backgroundImage, at: 0)
        tableView.backgroundView = backgroundImage
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
<<<<<<< HEAD
<<<<<<< HEAD
        return 105
=======
<<<<<<< HEAD
        return 60
>>>>>>> a96087274615ab185af5110dd80cdb8e2eaab0b1
=======
=======
>>>>>>> parent of 38cfaa5... Merge branch 'master' of https://github.com/micajuine-ho/DJApp
        return 60
>>>>>>> a96087274615ab185af5110dd80cdb8e2eaab0b1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: trackCellId, for: indexPath) as! TrackCell
            
            cell.textLabel?.text = "Track \(indexPath.row)"
            cell.detailTextLabel?.text = "Artist: "
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


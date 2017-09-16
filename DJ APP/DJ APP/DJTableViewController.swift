//
//  DJTableViewController.swift
//  DJ APP
//
//  Created by arturo ho on 8/24/17.
//  Copyright © 2017 Marquel and Micajuine App Team. All rights reserved.
//

import UIKit
import Firebase

class DJTableViewController: UITableViewController {

    var users = [UserDJ]()
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        
        tableView.register(DJCell.self, forCellReuseIdentifier: cellId)
        
        fetchDjs()
        
    }

    func fetchDjs() {
        
        Database.database().reference().child("users").observeSingleEvent(of: .value, with: {(snapshot) in
        
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                for (_,value) in dictionary {
                    let dj = UserDJ()
                    
                    print(snapshot.value as Any)
                    dj.djName = value["djName"] as? String
                    dj.age = value["age"] as? Int
                    dj.currentLocation = value["currentLocation"] as? String
                    dj.email = value["email"] as? String
                    dj.genere = value["genre"] as? String
                    dj.hometown = value["hometown"] as? String
                    dj.validated = value["validated"] as? Int
                    
                    self.users.append(dj)
                    print(self.users.count)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
                
            }
            
        }, withCancel: nil)
        
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        
        let dj = users[indexPath.row]
        cell.textLabel?.text = dj.djName

        if let loc = dj.currentLocation  {
            cell.detailTextLabel?.text = "Playing at: " +  "\(loc)"
        }
        return cell
    }

    func setupNavBar() {
        navigationItem.title = "DJ List"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(handleLogout))
    }

    func handleLogout() {
        dismiss(animated: true, completion: nil)
    }
   
}

class DJCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

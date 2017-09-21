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
        tableView.backgroundColor = UIColor.lightGray
        //remove seperators from empty cells
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.register(DJCell.self, forCellReuseIdentifier: cellId)
        
        fetchDjs()
        
    }

    func fetchDjs() {
        
        Database.database().reference().child("users").observeSingleEvent(of: .value, with: {(snapshot) in
        
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                for (_,value) in dictionary {
                    let dj = UserDJ()
                    
                    dj.djName = value["djName"] as? String
                    dj.age = value["age"] as? Int
                    dj.currentLocation = value["currentLocation"] as? String
                    dj.email = value["email"] as? String
                    dj.genere = value["genre"] as? String
                    dj.hometown = value["hometown"] as? String
                    dj.validated = value["validated"] as? Bool
                    dj.profilePicURL = value["profilePicURL"] as? String
                    
                    self.users.append(dj)
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! DJCell
        
        
        let dj = users[indexPath.row]
        cell.textLabel?.text = dj.djName

        if let loc = dj.currentLocation  {
            cell.detailTextLabel?.text = "Playing at: " +  "\(loc)"
        }

        
        if let profileUrl = dj.profilePicURL {
            cell.profileImageView.loadImageWithChachfromUrl(urlString: profileUrl)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
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
    let gradientLayer = CAGradientLayer()
    let firstColor: CGColor = UIColor(red: 0, green: 0.832, blue: 0.557, alpha: 1.0).cgColor
    let secondColor: CGColor = UIColor(red: 0, green: 0.635, blue: 0.923, alpha: 1.0).cgColor
   
    let profileImageView: UIImageView = {
       let iv = UIImageView()
        iv.image = UIImage(named: "usernameIcon")
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.masksToBounds = true
        iv.layer.cornerRadius = 25
        iv.layer.borderColor = UIColor.black.cgColor
        iv.layer.borderWidth = 2
        return iv
    }()
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //10 for left and right, 50 for size of image
        textLabel?.frame = CGRect(x: 70, y: textLabel!.frame.origin.y - 3, width: textLabel!.frame.width, height: textLabel!.frame.height)
        textLabel?.backgroundColor = UIColor.clear
        detailTextLabel?.frame = CGRect(x: 70, y: detailTextLabel!.frame.origin.y + 1
            , width: detailTextLabel!.frame.width, height: textLabel!.frame.height)
        detailTextLabel?.backgroundColor = UIColor.clear
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
   
        gradientLayer.colors = [firstColor, secondColor]
        gradientLayer.locations = [0, 0.5]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.frame = self.layer.bounds
        
        layer.insertSublayer(gradientLayer, at: 0)
        
        setupViews()
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(profileImageView)
        
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
   
    }
}



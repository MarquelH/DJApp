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
        //remove seperators from empty cells
        tableView.separatorStyle = .none
        tableView.register(DJCell.self, forCellReuseIdentifier: cellId)
        
        let backgroundImage: UIImageView = UIImageView(frame: view.bounds)
        backgroundImage.image = UIImage(named: "headphonesImage")
        backgroundImage.contentMode = .scaleAspectFill
        
        //view.insertSubview(backgroundImage, at: 0)
        tableView.backgroundView = backgroundImage
        
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
        cell.textLabel?.textColor = UIColor.white.withAlphaComponent(1.5)
        cell.textLabel?.font = UIFont(name: "Exo-Thin", size: 24)
        

        if let loc = dj.currentLocation  {
            cell.detailTextLabel?.text = "Playing at: " +  "\(loc)"
            cell.detailTextLabel?.textColor = UIColor.white.withAlphaComponent(1.5)
            cell.detailTextLabel?.font = UIFont(name: "Exo-Thin", size: 15)
        }

        
        if let profileUrl = dj.profilePicURL {
            cell.profileImageView.loadImageWithChachfromUrl(urlString: profileUrl)
        }
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentCell = tableView.cellForRow(at: indexPath) as! DJCell
        currentCell.cellClicked()

        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
        let songTableController = SongTableViewController()
        songTableController.dj = users[indexPath.row]
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.pushViewController(songTableController, animated: true)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5 , execute: {
            currentCell.cellEndedClick()
        })
        
    }
    

    func setupNavBar() {
        navigationItem.title = "DJ List"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(handleLogout))
        navigationItem.leftBarButtonItem?.tintColor = UIColor(red: 214/255, green: 29/255, blue: 1, alpha:1.0)
    }

    func handleLogout() {
        dismiss(animated: true, completion: nil)
    }

   
}

class DJCell: UITableViewCell {
    
    let profileImageView: UIImageView = {
       let iv = UIImageView()
        iv.image = UIImage(named: "usernameIcon")
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.masksToBounds = true
        iv.layer.cornerRadius = 30
        iv.layer.borderColor = UIColor.black.cgColor
        iv.layer.borderWidth = 1
        return iv
    }()
    
    let darkView: UIView = {
       let dk = UIView()
        dk.backgroundColor = UIColor.darkGray
        return dk
    }()
    
    let separator: UIView = {
        let s = UIView()
        s.translatesAutoresizingMaskIntoConstraints = false
        s.backgroundColor = UIColor.white
        return s
    }()
    
    lazy var gradientLayer: CAGradientLayer = {
       let gl = CAGradientLayer()
        let firstColor: CGColor = UIColor(red: 0, green: 0.832, blue: 0.557, alpha: 1.0).cgColor
        let secondColor: CGColor = UIColor(red: 0, green: 0.635, blue: 0.923, alpha: 1.0).cgColor
        gl.colors = [firstColor, secondColor]
        gl.locations = [0, 0.5]
        gl.startPoint = CGPoint(x: 0, y: 0)
        gl.endPoint = CGPoint(x: 0, y: 1)
        return gl
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //10 for left and right, 50 for size of image
        textLabel?.frame = CGRect(x: 80, y: textLabel!.frame.origin.y - 3, width: textLabel!.frame.width, height: textLabel!.frame.height)
        textLabel?.backgroundColor = UIColor.clear
        detailTextLabel?.frame = CGRect(x: 80, y: detailTextLabel!.frame.origin.y + 1
            , width: detailTextLabel!.frame.width, height: textLabel!.frame.height)
        detailTextLabel?.backgroundColor = UIColor.clear
        //contentView.layer.insertSublayer(gradientLayer, at: 0)
        //contentView.backgroundColor = UIColor(red: 214/255, green: 29/255, blue: 1, alpha:1.0)
        //gradientLayer.frame = contentView.frame
        darkView.frame = contentView.frame

    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    
    func cellClicked() {
        contentView.addSubview(darkView)
    }
    
    func cellEndedClick() {
            darkView.removeFromSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        contentView.addSubview(profileImageView)
        contentView.addSubview(separator)
        
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
       
        separator.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        separator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
        separator.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
    }
}



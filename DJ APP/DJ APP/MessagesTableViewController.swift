//
//  MessagesTableViewController.swift
//  DJ APP
//
//  Created by Marquel Hendricks on 1/22/18.
//  Copyright © 2018 Marquel and Micajuine App Team. All rights reserved.
//

import UIKit
import Firebase

class MessagesTableViewController: UITableViewController {

    var dj: UserDJ?
    var ref: DatabaseReference!
    var messages = [Message]()
    
    @IBOutlet weak var theNavItem: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupViews()
    }
    
    func setupNavBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        
        //Bar text
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "BebasNeue-Regular", size : 30) as Any, NSAttributedStringKey.foregroundColor: UIColor.white]
        theNavItem.title = "Shout outs"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(dj)
        if let uid = dj?.uid {
            print("SETTING THE REF")
            ref = Database.database().reference().child("messages").child(uid)
            getMessages()
        } else {
            print("Chat will appear guestID or Dj not passed in")
        }
    }
    
    func setupViews(){
        self.tableView.register(MessageTableViewCell.self, forCellReuseIdentifier: "messagCellId")
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = UIColor.black
        self.tableView.refreshControl = refreshController
    }
    
    lazy var refreshController: UIRefreshControl = {
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(self.getMessages), for: UIControlEvents.valueChanged)
        rc.tintColor = UIColor.blue.withAlphaComponent(0.75)
        return rc
    }()

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return messages.count
    }
    
    @objc func getMessages() {
        if (ref != nil) {
            ref.observeSingleEvent(of: .value, with: {(snapshot) in
                
                self.messages.removeAll()
                
                
                if !snapshot.exists() {
                    print("Snapshot does not exist")
                    return
                }
                
                for snap in snapshot.children.allObjects as! [DataSnapshot] {
                    
                    if let value = snap.value as? [String: AnyObject], let message = value["message"] as? String, let guestID = value["guestID"] as? String,  let timeStamp = value["timeStamp"] as? NSNumber, let djUID = value["djUID"] as? String, let nameOfGuest = value["guestName"] as? String, let guestPhone = value["Guest Phone"] as? String {
                        
                        
                        let newMessage = Message(message: message, timeStamp: timeStamp, djUID: djUID, guestID: guestID, guestName: nameOfGuest, guestPhone: guestPhone)
                        
                        
                        self.messages.append(newMessage)
                        
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                    else {
                        print("Unable to convert snapshot children into [String:AnyObjects]")
                    }
                }
                
                
            }) { (error) in
                print("Error getting snapshot: \(error.localizedDescription)")
            }
        }
        self.refreshController.endRefreshing()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let msg = messages[indexPath.row]
        let theMessage = msg.message
        let theNumber = msg.guestPhone
        let theName = msg.guestName
        
        if theNumber != "No Number Given" {
            let alert = UIAlertController(title: theName, message: "Message: \(theMessage!)\n\n Phone: \(theNumber!)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in
            self.navigationController?.popViewController(animated: true)
        }))
            self.tabBarController?.present(alert, animated: true, completion: {() in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: {() in
                    self.tableView.deselectRow(at: indexPath, animated: false)
                })
            })
    }
        else{
            let alert = UIAlertController(title: theName, message: theMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in
                self.navigationController?.popViewController(animated: true)
            }))
            self.tabBarController?.present(alert, animated: true, completion: {() in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: {() in
                    self.tableView.deselectRow(at: indexPath, animated: false)
                })
            })
        }
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messagCellId", for: indexPath) as! MessageTableViewCell
        
        let msg = messages[indexPath.row]
        let theName = msg.guestName
        let theNumber = msg.guestPhone
        cell.textLabel?.text = "\(indexPath.row+1))  From: " + "\(theName!)"
        cell.detailTextLabel?.text = "\(theNumber!)"
        cell.backgroundColor = UIColor.black
        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

}

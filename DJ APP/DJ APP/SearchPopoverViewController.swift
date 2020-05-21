//
//  SearchPopoverViewController.swift
//  DJ APP
//
//  Created by Marquel Hendricks on 1/12/20.
//  Copyright © 2020 Marquel and Micajuine App Team. All rights reserved.
//

import UIKit
import CoreData

class SearchPopoverViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var djSearchLabel: UILabel!
    @IBOutlet weak var djTableView: UITableView!
    @IBOutlet weak var djSearchBar: UISearchBar!
    var guestID: String?
    var users = [DJs]()
    var filteredData = [String]()
    var originalData = [String]()
    let djProfileViewController = DJProfileViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        djTableView.delegate = self
        djTableView.dataSource = self
        djSearchBar.delegate = self
        djSearchLabel.font = UIFont(name: "BebasNeue-Regular", size: 40)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        for dj in users {
            if dj.djName != nil {
                originalData.append(dj.djName!)
            }
        }
        filteredData = originalData
        // Do any additional setup after loading the view.
    }
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        //
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //if (!(djSearchBar.searchBar.text?.isEmpty)!) {
        //}
        filteredData = searchText.isEmpty ? originalData : originalData.filter({(dataString: String) -> Bool in
            // If dataItem matches the searchText, return true to include it
            return dataString.range(of: searchText, options: .caseInsensitive) != nil
        })
        djTableView.reloadData()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        //
    }
    
    
    //override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    //}
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "djSearchTableViewCell", for: indexPath) as! djSearchTableViewCell
        //let dj = users[indexPath.row]
        cell.textLabel?.text = filteredData[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow //optional, to get from any UIButton for example
        let currentCell = tableView.cellForRow(at: indexPath!)
        let selectedDjName = currentCell!.textLabel!.text!
        for dj in users {
            if dj.djName! == selectedDjName {
                djProfileViewController.dj = dj
                djProfileViewController.guestID = guestID
                let djProfileNavController = UINavigationController()
                djProfileNavController.viewControllers = [djProfileViewController]
                tableView.deselectRow(at: indexPath!, animated: true)
                djProfileNavController.modalPresentationStyle = .fullScreen
                present(djProfileNavController, animated: true, completion: nil)
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

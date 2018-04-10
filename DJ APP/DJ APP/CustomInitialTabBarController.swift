//
//  CustomInitialTabBarController.swift
//  DJ APP
//
//  Created by Marquel Hendricks on 1/16/18.
//  Copyright © 2018 Marquel and Micajuine App Team. All rights reserved.
//

import UIKit
import Firebase
import GoogleMaps

class CustomInitialTabBarController: UITabBarController {

    var guestID:String?
    
    let mapController = MapViewController()
    let djTableView = DJTableViewController()
    var myConstant: CGFloat = 0
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let mapNavController = UINavigationController()
        mapController.tabBarItem.title = "Map of DJs"
        mapController.tabBarItem.image = UIImage(named: "pin-map-7")
        mapNavController.viewControllers = [mapController]
    
        let djNavController = UINavigationController()
        djTableView.tabBarItem.title = "Select a DJ"
        djTableView.tabBarItem.image = UIImage(named: "text-list-7")
        //djTableView.tabBarItem.badgeColor = UIColor(red: 214/255, green: 29/255, blue: 1, alpha:1.0)
        djNavController.viewControllers = [djTableView]
        
        tabBar.barTintColor = UIColor.black
        tabBar.tintColor = UIColor.white
        
        viewControllers = [mapNavController,djNavController]
        
        self.selectedIndex = 0
        UIApplication.shared.statusBarStyle = .default
        
        let numberOfItems = CGFloat((self.tabBar.items!.count))
        
        let tabBarItemSize = CGSize(width: (self.tabBar.frame.width) / numberOfItems,
                                    height: (self.tabBar.frame.height))
        
        self.tabBar.selectionIndicatorImage
            = UIImage.imageWithColor(color: UIColor(red: 214/255, green: 29/255, blue: 1, alpha:1.0),
                                     size: tabBarItemSize).resizableImage(withCapInsets: .zero)
        
        self.tabBar.frame.size.width = self.view.frame.width + 4
        self.tabBar.frame.origin.x = -2
        
    }
    
    func handleBack() {
        do {
            try Auth.auth().signOut()
        }
        catch let error as NSError {
            print("Error with signing out of firebase: \(error.localizedDescription)")
        }
        dismiss(animated: true, completion: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setGuestIDs(id: String) {
        mapController.guestID = id
        djTableView.guestID = id
        self.guestID = id
    }

}

extension UIImage
{
    class func imageWithColor(color: UIColor, size: CGSize) -> UIImage
    {
        let rect: CGRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}

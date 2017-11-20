//
//  ViewController.swift
//  TabBarTest
//
//  Created by arturo ho on 11/19/17.
//  Copyright © 2017 Marquel and Micajuine App Team. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let textlabel: UIButton = {
       let tl = UIButton(type: .system)
        tl.setTitle("Press Me", for: .normal)
        tl.translatesAutoresizingMaskIntoConstraints = false
        tl.addTarget(self, action: #selector(handlePressed), for: .touchUpInside)
        return tl
    }()
    
   @objc func handlePressed () {
        print("pressed")
        let djController = DJController()
    
        present(djController, animated: true, completion: nil)
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.blue
        
        setupViews()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    func setupViews() {
        view.addSubview(textlabel)
        
        textlabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        textlabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        textlabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        textlabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

class DJController: UIViewController {
    
    let textlabel: UIButton = {
        let tl = UIButton(type: .system)
        tl.setTitle("Press Me2", for: .normal)
        tl.translatesAutoresizingMaskIntoConstraints = false
        tl.addTarget(self, action: #selector(handlePressed), for: .touchUpInside)
        return tl
    }()
    
    @objc func handlePressed () {
        print("pressed")
        let customTabBarController = CustomTabBarController()
            
        self.present(customTabBarController, animated: true, completion: {() in
//            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//            appDelegate.window?.rootViewController = customTabBarController
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.brown
        
        setupViews()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func setupViews() {
        view.addSubview(textlabel)
        
        textlabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        textlabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        textlabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        textlabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

class CustomTabBarController: UITabBarController {
    
//    let barbutton: UIBarButtonItem = {
//        let bb = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleBack))
//        return bb
//    }()
//    
//    @objc func handleBack() {
//        //dismiss
//        print("back")
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let songController = TableViewController()
        
        let songNavController = UINavigationController()
        songNavController.tabBarItem.title = "song"
        songNavController.viewControllers = [songController]
        
        let searchTrackController = ViewController2()
        searchTrackController.tabBarItem.title = "Search"


        viewControllers = [songNavController,searchTrackController]
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

class ViewController2: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.red
          
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


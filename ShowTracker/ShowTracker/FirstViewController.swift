//
//  FirstViewController.swift
//  ShowTracker
//
//  Created by Louis Harris on 8/3/17.
//  Copyright © 2017 Louis Harris. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {


    @IBOutlet weak var detailButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var followedShowsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = UIColor.purple
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.yellow]
        
        self.tabBarController?.tabBar.barTintColor = UIColor.purple
        self.tabBarController?.tabBar.isTranslucent = false
        self.tabBarController?.tabBar.tintColor = UIColor.yellow
        
        deleteButton.layer.cornerRadius = 5
        deleteButton.layer.borderWidth = 2.5
        deleteButton.layer.borderColor = UIColor.purple.cgColor
        deleteButton.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        
        detailButton.layer.cornerRadius = 5
        detailButton.layer.borderWidth = 2.5
        detailButton.layer.borderColor = UIColor.purple.cgColor
        detailButton.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
    }
    
    @IBAction func deleteShow(_ sender: Any) {
    }
    
    @IBAction func showDetails(_ sender: Any) {
    }
  


}


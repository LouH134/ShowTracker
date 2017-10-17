//
//  FirstViewController.swift
//  ShowTracker
//
//  Created by Louis Harris on 8/3/17.
//  Copyright © 2017 Louis Harris. All rights reserved.
//

//////////////////////////////////////////////////////////////////////////////////////////////
//                                  TO DO                                                   //
//1. Can't acess detailVC and EditVC unless show is selected from followingTableView        //
//2. Delete a show button deletes a show                                                    //
//3. Create array that puts ranking in order, might have to convert ranking from string to int
//4. Take ranking array use it to order followedshows array                                 //
//5 .UI for tableview                                                                       //
/////////////////////////////////////////////////////////////////////////////////////////////

import UIKit
import CoreData

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {


    @IBOutlet weak var detailButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var followedShowsTableView: UITableView!
    var followedShows:[Show] = []
    var allShows:[Show] = []
    var selectedShow:Show?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        followedShowsTableView.allowsMultipleSelection = false
        //Tab bar and nav controler UI
        self.navigationController?.navigationBar.barTintColor = UIColor.purple
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.yellow]
        if(self.navigationController?.navigationBar.backItem != nil){
            self.navigationItem.hidesBackButton = true
        }
        
        self.tabBarController?.tabBar.barTintColor = UIColor.purple
        self.tabBarController?.tabBar.isTranslucent = false
        self.tabBarController?.tabBar.tintColor = UIColor.yellow
        
        //UI for buttons
        designForUI()
        
        //Disable buttons when nothing is selected
        self.navigationItem.rightBarButtonItem?.tintColor = .gray
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        detailButton.isEnabled = false
        detailButton.setTitleColor(.gray, for: .normal)
        
        deleteButton.isEnabled = false
        deleteButton.setTitleColor(.gray, for: .normal)
        
        self.followedShowsTableView.delegate = self
        self.followedShowsTableView.dataSource = self
        followedShowsTableView.reloadData()
        
        //checkForFollowedShow()
        
        
    }
    
    func designForUI(){
        deleteButton.layer.cornerRadius = 5
        deleteButton.layer.borderWidth = 2.5
        deleteButton.layer.borderColor = UIColor.purple.cgColor
        deleteButton.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        
        detailButton.layer.cornerRadius = 5
        detailButton.layer.borderWidth = 2.5
        detailButton.layer.borderColor = UIColor.purple.cgColor
        detailButton.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Show>(entityName: "Show")
        
        
        do{
            allShows = try managedContext.fetch(fetchRequest)
            checkForFollowedShow()
            
        }catch let error as NSError{
            print("Could not fetch! \(error), \(error.userInfo)")
        }
    }
    
    func checkForFollowedShow(){
        followedShows.removeAll()
        
        for show in self.allShows{
            if show.followed != false{
                followedShows.append(show)
            }
        }
         followedShowsTableView.reloadData()
    }
    
    @IBAction func deleteShow(_ sender: Any) {
    }
    
    @IBAction func showDetails(_ sender: Any) {
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return followedShows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = followedShowsTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let followedShow = followedShows[indexPath.row]
        
        cell.textLabel?.text = followedShow.value(forKey: "showName") as? String
        
        return cell
    }
    
    
  


}


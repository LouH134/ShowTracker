//
//  FirstViewController.swift
//  ShowTracker
//
//  Created by Louis Harris on 8/3/17.
//  Copyright © 2017 Louis Harris. All rights reserved.
//

//////////////////////////////////////////////////////////////////////////////////////////////
//                                  TO DO                                                   //
//1. UI for tableview                                                                       //
//2. Detail button goes to detailsVC on selected show                                       //
//3. Tableview should reflect changed rankings if user wants I.E change 1 to 2 or 2 to 1    //
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
        
        let sectionSortDescriptor = NSSortDescriptor(key: "rank", ascending: true)
        let fetchRequest = NSFetchRequest<Show>(entityName: "Show")
        fetchRequest.sortDescriptors = [sectionSortDescriptor]
        
        
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
        
        //Handle nil rank, Takes nils at beinning of array and append them to the end of the array so nil rank appears at bottom of tableview
        var tempArray = [Show]()
        for nilRank in self.followedShows {
            if nilRank.rank == nil {
                tempArray.append(nilRank)
                self.followedShows.removeFirst()
            }
        }
        self.followedShows.append(contentsOf: tempArray)
        
        followedShowsTableView.reloadData()
    }
    
    @IBAction func deleteShow(_ sender: Any) {
        let customAlert = CustomDeleteShowAlertViewController()
        customAlert.firstVC = self
        customAlert.modalPresentationStyle = .overCurrentContext
        customAlert.modalTransitionStyle = .crossDissolve
        present(customAlert, animated: true)
    }
    
    func deleteSelectedRow(){
        let indexPath = followedShowsTableView.indexPathForSelectedRow
        //guard statement because it is possible that the indexPath is nil
        guard let index = indexPath else {
            return
        }
        deleteShow(atIndexPath: index)
    }
    
    func deleteShow(atIndexPath indexPath: IndexPath)
    {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //currently selected show or highlighted show in tableview
        let thisShow = followedShows[indexPath.row]
        
        for show in followedShows{
            if (show.showName == thisShow.showName){
                managedContext.delete(show)
            }
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Error While Fetching Data From DB: \(error.userInfo)")
            
        }
        
        self.followedShows.remove(at: indexPath.row)
        self.followedShowsTableView.deleteRows(at: [indexPath], with: .fade)
        
        if followedShows.count == 0 {
            self.navigationItem.rightBarButtonItem?.tintColor = .gray
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            
            detailButton.isEnabled = false
            detailButton.setTitleColor(.gray, for: .normal)
            
            deleteButton.isEnabled = false
            deleteButton.setTitleColor(.gray, for: .normal)
            
        }
    }
   
    @IBAction func goToEditVC(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let editShowVC = storyboard.instantiateViewController(withIdentifier: "editShowViewController") as! EditShowViewController
        
        let indexPath = followedShowsTableView.indexPathForSelectedRow
        guard let index = indexPath else{
            return
        }
        
        let currentShow = followedShows[index.row]
        
        editShowVC.currentlySelectedShow = currentShow
        editShowVC.allEditedShows = followedShows
        
        self.navigationController?.pushViewController(editShowVC, animated: true)
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            deleteShow(atIndexPath: indexPath)
            //delete the cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.indexPathForSelectedRow != nil {
            self.navigationItem.rightBarButtonItem?.tintColor = .yellow
            self.navigationItem.rightBarButtonItem?.isEnabled = true

            detailButton.isEnabled = true
            detailButton.setTitleColor(.yellow, for: .normal)

            deleteButton.isEnabled = true
            deleteButton.setTitleColor(.yellow, for: .normal)
        } else {
            self.navigationItem.rightBarButtonItem?.tintColor = .gray
            self.navigationItem.rightBarButtonItem?.isEnabled = false

            detailButton.isEnabled = false
            detailButton.tintColor = .gray

            deleteButton.isEnabled = false
            deleteButton.tintColor = .gray
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        if tableView.indexPathForSelectedRow != nil {
            self.navigationItem.rightBarButtonItem?.tintColor = .yellow
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            
            detailButton.isEnabled = true
            detailButton.setTitleColor(.yellow, for: .normal)
            
            deleteButton.isEnabled = true
            deleteButton.setTitleColor(.yellow, for: .normal)
        } else {
            self.navigationItem.rightBarButtonItem?.tintColor = .gray
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            
            detailButton.isEnabled = false
            detailButton.tintColor = .gray
            
            deleteButton.isEnabled = false
            deleteButton.tintColor = .gray
        }
    }}


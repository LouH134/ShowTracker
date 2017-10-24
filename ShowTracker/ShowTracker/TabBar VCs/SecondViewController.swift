//
//  SecondViewController.swift
//  ShowTracker
//
//  Created by Louis Harris on 8/3/17.
//  Copyright © 2017 Louis Harris. All rights reserved.
//

/////////////////////////////////////////////////////////////////////////////////////////////
//                              TO DO                                                      //
//1. When tableview is empty show image. When not empty hide image                         //
/////////////////////////////////////////////////////////////////////////////////////////////

import UIKit
import CoreData

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var addShowButton: UIButton!
    @IBOutlet weak var deleteShowButton: UIButton!
    @IBOutlet weak var possibleShowsTableView: UITableView!
    @IBOutlet weak var addPossibleShowButton: UIButton!
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    var possibleShows: [Show] = []
    var addShowString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        possibleShowsTableView.allowsMultipleSelection = false
       
        //UI for Navbar
        self.navigationController?.navigationBar.barTintColor = UIColor.purple
        self.navigationController?.tabBarController?.tabBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.yellow]
        if(self.navigationController?.navigationBar.backItem != nil){
            self.navigationItem.hidesBackButton = true
        }

        //UI for buttons
        designForUI()
        
        //Disable buttons when nothing is selected
        self.navigationItem.rightBarButtonItem?.tintColor = .gray
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        addShowButton.isEnabled = false
        deleteShowButton.isEnabled = false
        
        //Setting up tableview
        self.possibleShowsTableView.delegate = self
        self.possibleShowsTableView.dataSource = self
        possibleShowsTableView.backgroundColor = UIColor.black
        possibleShowsTableView.tableFooterView = UIView()
        }
    
    func designForUI(){
        addShowButton.layer.cornerRadius = 5
        addShowButton.layer.borderWidth = 2.5
        addShowButton.layer.borderColor = UIColor.purple.cgColor
        addShowButton.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        
        deleteShowButton.layer.cornerRadius = 5
        deleteShowButton.layer.borderWidth = 2.5
        deleteShowButton.layer.borderColor = UIColor.purple.cgColor
        deleteShowButton.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        
        addPossibleShowButton.layer.cornerRadius = 5
        addPossibleShowButton.layer.borderWidth = 2.5
        addPossibleShowButton.layer.borderColor = UIColor.purple.cgColor
        addPossibleShowButton.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        possibleShowsTableView.reloadData()
        
        //look at core data for saved shows only shows that aren't followed
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Show>(entityName: "Show")
        fetchRequest.predicate = NSPredicate(format: "followed == false")
        
        do{
            possibleShows = try managedContext.fetch(fetchRequest)
            self.possibleShowsTableView.reloadData()
            
        }catch let error as NSError{
            print("Could not fetch! \(error), \(error.userInfo)")
        }
        
        if possibleShows.count == 0{
            self.navigationItem.rightBarButtonItem?.tintColor = .gray
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            addShowButton.isEnabled = false
            addShowButton.setTitleColor(.gray, for: .normal)
            deleteShowButton.isEnabled = false
            deleteShowButton.setTitleColor(.gray, for: .normal)
        }
    }
    
    @IBAction func goToEditVC(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let editShowVC = storyboard.instantiateViewController(withIdentifier: "editShowViewController") as! EditShowViewController
        
        let indexPath = possibleShowsTableView.indexPathForSelectedRow
        guard let index = indexPath else{
            return
        }
        
        let currentShow = possibleShows[possibleShows.count - index.row-1]
        
        editShowVC.currentlySelectedShow = currentShow
        editShowVC.allEditedShows = possibleShows
        
        self.navigationController?.pushViewController(editShowVC, animated: true)
    }
    
    @IBAction func addShow(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let firstVC = storyboard.instantiateViewController(withIdentifier: "firstViewController") as! FirstViewController
        
        let indexPath = possibleShowsTableView.indexPathForSelectedRow
        guard let index = indexPath else{
            return
        }
        let currentShow = possibleShows[possibleShows.count - index.row-1]
        currentShow.followed = true
        
        firstVC.selectedShow = currentShow
        firstVC.allShows = possibleShows
        
        self.possibleShows.remove(at: possibleShows.count - index.row - 1)
        self.possibleShowsTableView.deleteRows(at: [index], with: .fade)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        do{
            try managedContext.save()
            
        }catch let error as NSError{
            print("Could not Save! \(error), \(error.userInfo)")
        }
        
        self.tabBarController?.selectedIndex = 0
    }

    @IBAction func deleteShow(_ sender: Any) {
        let customAlert = CustomDeleteAlertViewController()
        customAlert.secondVC = self
        customAlert.modalPresentationStyle = .overCurrentContext
        customAlert.modalTransitionStyle = .crossDissolve
        present(customAlert, animated: true)
    }
    
    @IBAction func addPossibleShow(_ sender: Any) {
        let customAlert = CustomAlertViewController()
        customAlert.secondVC = self
        customAlert.modalPresentationStyle = .overCurrentContext
        customAlert.modalTransitionStyle = .crossDissolve
        present(customAlert, animated: true)
    }
    
    func save(name:String)
    {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName:"Show", in: managedContext)
        let possibleShow = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        possibleShow.setValue(name, forKey: "showName")
        possibleShow.setValue(false, forKey: "followed")
        
        do{
            try managedContext.save()
            possibleShows.append(possibleShow as! Show)
            possibleShowsTableView.reloadData()
        }catch let error as NSError{
            print("Could not Save! \(error), \(error.userInfo)")
        }
    }
    
    func deleteSelectedRow(){
        let indexPath = possibleShowsTableView.indexPathForSelectedRow
        //guard statement because it is possible that the indexPath is nil
        guard let index = indexPath else {
            return
        }
        deletePossibleShow(atIndexPath: index)
    }
    
    func deletePossibleShow(atIndexPath indexPath: IndexPath)
    {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //currently selected show or highlighted show in tableview
        let thisPossibleShow = possibleShows[possibleShows.count - indexPath.row-1]
        
            for show in possibleShows{
                if (show.showName == thisPossibleShow.showName){
                    managedContext.delete(show)
                }
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Error While Fetching Data From DB: \(error.userInfo)")
            
        }
    
        self.possibleShows.remove(at: possibleShows.count - indexPath.row-1)
        self.possibleShowsTableView.deleteRows(at: [indexPath], with: .fade)
        
        if possibleShows.count == 0 {
            self.navigationItem.rightBarButtonItem?.tintColor = .gray
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            
            addShowButton.isEnabled = false
            addShowButton.setTitleColor(.gray, for: .normal)
            
            deleteShowButton.isEnabled = false
            deleteShowButton.setTitleColor(.gray, for: .normal)
            
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return possibleShows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = possibleShowsTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell2
        
        let possibleShow = possibleShows[possibleShows.count - indexPath.row-1]
        
        cell.mainLabel.text = possibleShow.value(forKey: "showName") as? String
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.purple.cgColor
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.purple
        cell.selectedBackgroundView = backgroundView
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.indexPathForSelectedRow != nil {
            self.navigationItem.rightBarButtonItem?.tintColor = .yellow
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            
            addShowButton.isEnabled = true
            addShowButton.setTitleColor(.yellow, for: .normal)
            
            deleteShowButton.isEnabled = true
            deleteShowButton.setTitleColor(.yellow, for: .normal)
        } else {
            self.navigationItem.rightBarButtonItem?.tintColor = .gray
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        
            addShowButton.isEnabled = false
            addShowButton.tintColor = .gray
            
            deleteShowButton.isEnabled = false
            deleteShowButton.tintColor = .gray
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            deletePossibleShow(atIndexPath: indexPath)
            //delete the cell
        }
    }
    
    //if all entries in tableview are deleted buttons are still active, need to change to deactive and grayed out
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    
        if tableView.indexPathForSelectedRow != nil {
            self.navigationItem.rightBarButtonItem?.tintColor = .yellow
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            
            addShowButton.isEnabled = true
            addShowButton.setTitleColor(.yellow, for: .normal)
            
            deleteShowButton.isEnabled = true
            deleteShowButton.setTitleColor(.yellow, for: .normal)
        } else {
            self.navigationItem.rightBarButtonItem?.tintColor = .gray
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            
            addShowButton.isEnabled = false
            addShowButton.tintColor = .gray
            
            deleteShowButton.isEnabled = false
            deleteShowButton.tintColor = .gray
       }
    }
}

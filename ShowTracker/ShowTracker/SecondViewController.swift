//
//  SecondViewController.swift
//  ShowTracker
//
//  Created by Louis Harris on 8/3/17.
//  Copyright © 2017 Louis Harris. All rights reserved.
//


///////////////////////////////////////////////////////////////////////////////////
//                              TO DO                                            //
//1. follow show button sends show from possibleshow tableview to followed show //
//tableview in firstVC                                                          //
//2. change UI of tableview                                                     //
//3. fix bug. New shows to table view aren't appearing in order                 //
//4. fix bug. Can't navigate from secondVC back to FirstVC                      //
/////////////////////////////////////////////////////////////////////////////////

import UIKit
import CoreData

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var addShowButton: UIButton!
    @IBOutlet weak var deleteShowButton: UIButton!
    @IBOutlet weak var possibleShowsTableView: UITableView!
    @IBOutlet weak var addPossibleShowButton: UIButton!
    var possibleShows: [Show] = []
    var addShowString: String?
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        possibleShowsTableView.allowsMultipleSelection = false
        self.possibleShowsTableView.reloadData()
        
        //UI for Navbar
        self.navigationController?.navigationBar.barTintColor = UIColor.purple
        self.navigationController?.tabBarController?.tabBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.yellow]
        
        
        //UI for buttons
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
        
        //Disable buttons when nothing is selected
        self.navigationItem.rightBarButtonItem?.tintColor = .gray
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        addShowButton.isEnabled = false
        deleteShowButton.isEnabled = false
        
        
        //Setting up tableview
        self.possibleShowsTableView.delegate = self
        self.possibleShowsTableView.dataSource = self
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //look at core data for saved shows
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Show>(entityName: "Show")
        
        
        do{
            possibleShows = try managedContext.fetch(fetchRequest)
        }catch let error as NSError{
            print("Could not fetch! \(error), \(error.userInfo)")
        }
    }
    
    
    @IBAction func goToEditVC(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let editShowVC = storyboard.instantiateViewController(withIdentifier: "editShowViewController") as! EditShowViewController
        self.navigationController?.pushViewController(editShowVC, animated: true)
        
        
        let indexPath = possibleShowsTableView.indexPathForSelectedRow
        guard let index = indexPath else{
            return
        }
        
        let currentShow = possibleShows[index.row]
        
        editShowVC.currentlySelectedShow = currentShow
    }
    
    @IBAction func addShow(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let firstVC = storyboard.instantiateViewController(withIdentifier: "firstViewController") as! FirstViewController
        self.navigationController?.pushViewController(firstVC, animated: true)
        
        
        let indexPath = possibleShowsTableView.indexPathForSelectedRow
        guard let index = indexPath else{
            return
        }
        
        let currentShow = possibleShows[index.row]
        
        firstVC.selectedShow = currentShow
        
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
        
        self.tabBarController?.tabBar.isUserInteractionEnabled = false
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
        let thisPossibleShow = possibleShows[indexPath.row]
        
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
    
        self.possibleShows.remove(at: indexPath.row)
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
        let cell = possibleShowsTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let possibleShow = possibleShows[indexPath.row]
        
        cell.textLabel?.text = possibleShow.value(forKey: "showName") as? String
        
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




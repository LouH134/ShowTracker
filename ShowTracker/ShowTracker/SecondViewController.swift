//
//  SecondViewController.swift
//  ShowTracker
//
//  Created by Louis Harris on 8/3/17.
//  Copyright © 2017 Louis Harris. All rights reserved.
//


///////////////////////////////////////////////////////////////////////////////////
//                              TO DO                                            //
//1.delete button deletes show in tableview when highlighted and in coredata    //
//2. follow show button sends show from possibleshow tableview to followed show //
//tableview in firstVC                                                          //
//3. change UI of tableview                                                     //
/////////////////////////////////////////////////////////////////////////////////

import UIKit
import CoreData

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var addShowButton: UIButton!
    @IBOutlet weak var deleteShowButton: UIButton!
    @IBOutlet weak var possibleShowsTableView: UITableView!
    @IBOutlet weak var addPossibleShowButton: UIButton!
    var possibleShows: [NSManagedObject] = []
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
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Show")
        
        do{
            possibleShows = try managedContext.fetch(fetchRequest)
        }catch let error as NSError{
            print("Could not fetch! \(error), \(error.userInfo)")
        }
    }
    
    @IBAction func addShow(_ sender: Any) {
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
            possibleShows.append(possibleShow)
            possibleShowsTableView.reloadData()
        }catch let error as NSError{
            print("Could not Save! \(error), \(error.userInfo)")
        }
    }
    
    func deletePossibleShow()
    {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Show")
        
        possibleShows = try! managedContext.fetch(fetchRequest)
        
        for show in possibleShows{
            managedContext.delete(show)
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
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    
        if tableView.indexPathForSelectedRow != nil {
            self.navigationItem.rightBarButtonItem?.tintColor = .yellow
        } else {
          self.navigationItem.rightBarButtonItem?.tintColor = .gray
       }
    }
    
}




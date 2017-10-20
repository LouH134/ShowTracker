//
//  CustomRankAlertViewController.swift
//  ShowTracker
//
//  Created by Louis Harris on 10/13/17.
//  Copyright © 2017 Louis Harris. All rights reserved.
//

/////////////////////////////////////////////////////////////////////////////
//                              TO DO:                                     //
//1.After pushing yes button and changing the rank, won't go to either VC  //
////////////////////////////////////////////////////////////////////////////

import UIKit
import CoreData

class CustomRankAlertViewController: UIViewController {
    
    @IBOutlet weak var rankCustomAlertView: UIView!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    var everyShow:[Show] = []
    var newRankForShow:String?
    var currentlySelectedShow:Show!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        rankCustomAlertView.layer.cornerRadius = 5
        rankCustomAlertView.layer.borderWidth = 2.5
        rankCustomAlertView.layer.borderColor = UIColor.purple.cgColor
        
        okButton.layer.cornerRadius = 5
        okButton.layer.borderWidth = 2.5
        okButton.layer.borderColor = UIColor.purple.cgColor
        
        noButton.layer.cornerRadius = 5
        noButton.layer.borderWidth = 2.5
        noButton.layer.borderColor = UIColor.purple.cgColor
    }

    @IBAction func okPressed(_ sender: Any) {
        changeRank()
        
        //push to a viewcontroller depending on followed bool
        if currentlySelectedShow.followed == true{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let firstVC = storyboard.instantiateViewController(withIdentifier: "firstViewController") as! FirstViewController
            self.navigationController?.pushViewController(firstVC, animated: true)
        }else{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let secondVC = storyboard.instantiateViewController(withIdentifier: "secondViewController") as! SecondViewController
            self.navigationController?.pushViewController(secondVC, animated: true)
        }
    }
    
    func changeRank(){
        //loop through every coredata object in array if an objects rank is equal to the current shows rank, then the objects rank becomes nil and the current shows rank is maintained
        for show in self.everyShow{
            if show.rank == newRankForShow{
                show.rank = nil
                currentlySelectedShow.rank = newRankForShow
            }
        }
    
        //save changes to coredata
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        do{
            try managedContext.save()
            
        }catch let error as NSError{
            print("Could not Save! \(error), \(error.userInfo)")
        }
    }
    
    @IBAction func noButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

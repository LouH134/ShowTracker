//
//  CustomDeleteAlertViewController.swift
//  ShowTracker
//
//  Created by Louis Harris on 8/23/17.
//  Copyright © 2017 Louis Harris. All rights reserved.
//

import UIKit

class CustomDeleteAlertViewController: UIViewController {
    
    
    @IBOutlet weak var deleteCustomAlertView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    var secondVC: SecondViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        deleteCustomAlertView.layer.cornerRadius = 5
        deleteCustomAlertView.layer.borderWidth = 2.5
        deleteCustomAlertView.layer.borderColor = UIColor.purple.cgColor
        
        deleteButton.layer.cornerRadius = 5
        deleteButton.layer.borderWidth = 2.5
        deleteButton.layer.borderColor = UIColor.purple.cgColor
        
        cancelButton.layer.cornerRadius = 5
        cancelButton.layer.borderWidth = 2.5
        cancelButton.layer.borderColor = UIColor.purple.cgColor
    }

    @IBAction func deletePressed(_ sender: Any) {
    }

    @IBAction func cancel(_ sender: Any) {
        self.presentingViewController?.tabBarController?.tabBar.isUserInteractionEnabled = true
        self.dismiss(animated: true, completion: nil)
    }
    
}

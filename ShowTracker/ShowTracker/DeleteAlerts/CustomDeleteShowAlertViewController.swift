//
//  CustomDeleteShowAlertViewController.swift
//  ShowTracker
//
//  Created by Louis Harris on 10/18/17.
//  Copyright © 2017 Louis Harris. All rights reserved.
//

import UIKit

class CustomDeleteShowAlertViewController: UIViewController {
    
    @IBOutlet weak var deleteShowView: UIView!
    @IBOutlet weak var deleteShowButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    var firstVC:FirstViewController!
    

    

    override func viewDidLoad() {
        super.viewDidLoad()

        deleteShowView.layer.cornerRadius = 5
        deleteShowView.layer.borderWidth = 2.5
        deleteShowView.layer.borderColor = UIColor.purple.cgColor
        
        deleteShowButton.layer.cornerRadius = 5
        deleteShowButton.layer.borderWidth = 2.5
        deleteShowButton.layer.borderColor = UIColor.purple.cgColor
        
        cancelButton.layer.cornerRadius = 5
        cancelButton.layer.borderWidth = 2.5
        cancelButton.layer.borderColor = UIColor.purple.cgColor
    }

    @IBAction func deleteShow(_ sender: Any) {
        self.firstVC.deleteSelectedRow()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.presentingViewController?.tabBarController?.tabBar.isUserInteractionEnabled = true
        self.dismiss(animated: true, completion: nil)
    }
    
}

//
//  CustomRankAlertViewController.swift
//  ShowTracker
//
//  Created by Louis Harris on 10/13/17.
//  Copyright © 2017 Louis Harris. All rights reserved.
//

import UIKit

class CustomRankAlertViewController: UIViewController {
    
    @IBOutlet weak var rankCustomAlertView: UIView!
    @IBOutlet weak var okButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        rankCustomAlertView.layer.cornerRadius = 5
        rankCustomAlertView.layer.borderWidth = 2.5
        rankCustomAlertView.layer.borderColor = UIColor.purple.cgColor
        
        okButton.layer.cornerRadius = 5
        okButton.layer.borderWidth = 2.5
        okButton.layer.borderColor = UIColor.purple.cgColor
    }

    @IBAction func okPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

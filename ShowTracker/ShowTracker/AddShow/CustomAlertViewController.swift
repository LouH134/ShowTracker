//
//  CustomAlertViewController.swift
//  ShowTracker
//
//  Created by Louis Harris on 8/18/17.
//  Copyright © 2017 Louis Harris. All rights reserved.
//

import UIKit

class CustomAlertViewController: UIViewController {
    
    @IBOutlet weak var customAlertView: UIView!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    var secondVC: SecondViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customAlertView.layer.cornerRadius = 5
        customAlertView.layer.borderWidth = 2.5
        customAlertView.layer.borderColor = UIColor.purple.cgColor
        
        inputTextField.layer.cornerRadius = 5
        inputTextField.layer.borderWidth = 2.5
        inputTextField.layer.borderColor = UIColor.purple.cgColor
        
        saveButton.layer.cornerRadius = 5
        saveButton.layer.borderWidth = 2.5
        saveButton.layer.borderColor = UIColor.purple.cgColor
        saveButton.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        
        cancelButton.layer.cornerRadius = 5
        cancelButton.layer.borderWidth = 2.5
        cancelButton.layer.borderColor = UIColor.purple.cgColor
        cancelButton.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        
        
        
    }
    
    @IBAction func save(_ sender: Any) {
        
        self.secondVC.save(name: inputTextField.text!)
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.presentingViewController?.tabBarController?.tabBar.isUserInteractionEnabled = true
        self.dismiss(animated: true, completion: nil)
        
    }
}

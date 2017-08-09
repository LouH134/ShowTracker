//
//  EditShowViewController.swift
//  ShowTracker
//
//  Created by Louis Harris on 8/7/17.
//  Copyright © 2017 Louis Harris. All rights reserved.
//

///////////////////////////////////////////////////////////////////////////
//                          TO DO                                        //
//1. Label is title of show                                              //
//2. Once info is entered save button saves to core data                //
//3. Button highlight is changed when pressed                           //
//4. Create Array to rank shows                                         //
/////////////////////////////////////////////////////////////////////////

import UIKit

class EditShowViewController: UIViewController, UITextViewDelegate{
    
    @IBOutlet weak var rankTxtField: UITextField!
    @IBOutlet weak var currentSeasonTxtField: UITextField!
    @IBOutlet weak var currentEpisodeTxtField: UITextField!
    @IBOutlet weak var summaryTextView: UITextView!
    @IBOutlet weak var showTitleLabel: UILabel!
    @IBOutlet weak var totalEpisodesTxtField: UITextField!
    @IBOutlet weak var totalSeasonTxtField: UITextField!
    @IBOutlet weak var saveShowButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.yellow]
        self.title = "Edit Show"
        let barButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(goBack))
        self.navigationItem.leftBarButtonItem = barButtonItem
        barButtonItem.tintColor = UIColor.yellow
        
        saveShowButton.layer.cornerRadius = 5
        saveShowButton.layer.borderWidth = 2.5
        saveShowButton.layer.borderColor = UIColor.purple.cgColor
        saveShowButton.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        
        currentEpisodeTxtField.layer.cornerRadius = 5
        currentEpisodeTxtField.layer.borderWidth = 2.5
        currentEpisodeTxtField.layer.borderColor = UIColor.purple.cgColor
        
        currentSeasonTxtField.layer.cornerRadius = 5
        currentSeasonTxtField.layer.borderWidth = 2.5
        currentSeasonTxtField.layer.borderColor = UIColor.purple.cgColor
        
        totalEpisodesTxtField.layer.cornerRadius = 5
        totalEpisodesTxtField.layer.borderWidth = 2.5
        totalEpisodesTxtField.layer.borderColor = UIColor.purple.cgColor
        
        totalSeasonTxtField.layer.cornerRadius = 5
        totalSeasonTxtField.layer.borderWidth = 2.5
        totalSeasonTxtField.layer.borderColor = UIColor.purple.cgColor
        
        rankTxtField.layer.cornerRadius = 5
        rankTxtField.layer.borderWidth = 2.5
        rankTxtField.layer.borderColor = UIColor.purple.cgColor
        
        summaryTextView.delegate = self
        
        summaryTextView.text = "Enter Summary..."
        summaryTextView.textColor = UIColor.yellow
        summaryTextView.layer.borderWidth = 2.5
        summaryTextView.layer.borderColor = UIColor.purple.cgColor
        
    }
    
    func goBack()
    {
        //print("Back button pressed")
        self.navigationController?.popViewController(animated: true)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.yellow {
            textView.text = nil
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter Summary..."
        }
    }
    
    
    @IBAction func saveShow(_ sender: Any) {
    }

}

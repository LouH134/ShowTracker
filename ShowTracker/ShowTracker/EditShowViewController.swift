//
//  EditShowViewController.swift
//  ShowTracker
//
//  Created by Louis Harris on 8/7/17.
//  Copyright © 2017 Louis Harris. All rights reserved.
//

///////////////////////////////////////////////////////////////////////////
//                          TO DO                                        //
//1. Once some info is entered save button saves to core data            //
//2. Create Array to rank shows                                          //
//3. bool for coredata is connected to bool from switch                 //
/////////////////////////////////////////////////////////////////////////

import UIKit
import CoreData

class EditShowViewController: UIViewController, UITextViewDelegate{
    
    @IBOutlet weak var rankTxtField: UITextField!
    @IBOutlet weak var currentSeasonTxtField: UITextField!
    @IBOutlet weak var currentEpisodeTxtField: UITextField!
    @IBOutlet weak var summaryTextView: UITextView!
    @IBOutlet weak var showTitleLabel: UILabel!
    @IBOutlet weak var totalEpisodesTxtField: UITextField!
    @IBOutlet weak var totalSeasonTxtField: UITextField!
    @IBOutlet weak var saveShowButton: UIButton!
    @IBOutlet weak var airingSwitch: UISwitch!
    @IBOutlet weak var airingLabel: UILabel!
    var currentlySelectedShow:Show!
    var keyboardHeight:CGRect!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //UI for NavController and action to go back
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.yellow]
        self.title = "Edit Show"
        let barButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(goBack))
        self.navigationItem.leftBarButtonItem = barButtonItem
        barButtonItem.tintColor = UIColor.yellow
        
        //UI for button and textfields
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
        
        showTitleLabel.text = currentlySelectedShow.showName
        
        //simple actions
        
        self.keyboardHeight = self.view.frame
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        saveShowButton.isEnabled = false
        saveShowButton.setTitleColor(.gray, for: .normal)
        
        handleTextField()

    }
    
    func keyboardWillShow(notification:NSNotification)
    {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue{
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: keyboardHeight.height - keyboardSize.height - 1)
        }
    }
        
    func keyboardWillHide(notification:NSNotification)
    {
        if((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil{
                self.view.frame = keyboardHeight
        }
    }
    
    func dismissKeyboard()
    {
        view.endEditing(true)
    }
    
    func goBack()
    {
        //print("Back button pressed")
        self.navigationController?.popViewController(animated: true)
    }
    //Functions for textView
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
    
    //Fuction to enable save button
    func textFieldChanged()
    {
        guard let showEpisodeString = currentEpisodeTxtField.text,  !showEpisodeString.isEmpty, let seasonEpisodeString = currentSeasonTxtField.text, !seasonEpisodeString.isEmpty, let rankString = rankTxtField.text, !rankString.isEmpty else{
            saveShowButton.setTitleColor(UIColor.gray, for: UIControlState.normal)
            saveShowButton.isEnabled = false
            
            return
        }
        saveShowButton.setTitleColor(UIColor.yellow, for: UIControlState.normal)
        saveShowButton.isEnabled = true
    }
    
    func handleTextField()
    {
        currentEpisodeTxtField.addTarget(self, action: #selector(EditShowViewController.textFieldChanged), for: UIControlEvents.editingChanged)
        currentSeasonTxtField.addTarget(self, action: #selector(EditShowViewController.textFieldChanged), for: UIControlEvents.editingChanged)
        rankTxtField.addTarget(self, action: #selector(EditShowViewController.textFieldChanged), for: UIControlEvents.editingChanged)
    }
    
    
    
    @IBAction func airing(_ sender: UISwitch) {
        if airingSwitch.isOn == true
        {
            airingLabel.isHidden = false
            currentlySelectedShow.airing = true
        }else{
            airingLabel.isHidden = true
            currentlySelectedShow.airing = false
        }
    }
    
    @IBAction func saveShow(_ sender: Any) {
    }
    
    //func to save to coredata
    func updateShow()
    {
        currentlySelectedShow.currentEpisode = currentEpisodeTxtField.text
        currentlySelectedShow.totalEpisodes = totalEpisodesTxtField.text
        currentlySelectedShow.currentSeason = currentSeasonTxtField.text
        currentlySelectedShow.totalSeasons = totalSeasonTxtField.text
        currentlySelectedShow.summary = summaryTextView.text
        currentlySelectedShow.rank = rankTxtField.text
        //currentlySelectedShow.airing =
        
    }
}

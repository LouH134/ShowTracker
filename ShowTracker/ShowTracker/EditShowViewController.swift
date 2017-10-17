//
//  EditShowViewController.swift
//  ShowTracker
//
//  Created by Louis Harris on 8/7/17.
//  Copyright © 2017 Louis Harris. All rights reserved.
//

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
    var allEditedShows:[Show] = []
    var keyboardHeight:CGRect!
    var summaryString:String?
    var editedSummaryString:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //UI for NavController and action to go back
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.yellow]
        self.title = "Edit Show"
        let barButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(goBack))
        self.navigationItem.leftBarButtonItem = barButtonItem
        barButtonItem.tintColor = UIColor.yellow
        
        //UI for button and textfields
        designForUI()
        
        //behavoir for diplaying or not displaying attributes of show
        showAttributes()
        
        //simple actions
        
        self.keyboardHeight = self.view.frame
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        saveShowButton.isEnabled = false
        saveShowButton.setTitleColor(.gray, for: .normal)
        
        textFieldChanged()
        handleTextField()

    }
    
    func showAttributes(){
        showTitleLabel.text = currentlySelectedShow.showName
        
        if currentlySelectedShow.summary != nil{
            summaryString = currentlySelectedShow.summary
            summaryTextView.text = summaryString
        }
        
        if currentEpisodeTxtField.text == nil{
            currentEpisodeTxtField.placeholder = "Enter Current Episode..."
        }else{
            currentEpisodeTxtField.text = currentlySelectedShow.currentEpisode
        }
        
        if totalEpisodesTxtField.text == nil{
            totalEpisodesTxtField.placeholder = "Enter Total # of Episodes..."
        }else{
            totalEpisodesTxtField.text = currentlySelectedShow.totalEpisodes
        }
        
        if currentSeasonTxtField.text == nil{
            currentSeasonTxtField.placeholder = "Enter Current Season..."
        }else{
            currentSeasonTxtField.text = currentlySelectedShow.currentSeason
        }
        
        if totalSeasonTxtField.text == nil{
            totalSeasonTxtField.placeholder = "Enter Total # of Seasons..."
        }else{
            totalSeasonTxtField.text = currentlySelectedShow.totalSeasons
        }
        
        if rankTxtField.text == nil{
            rankTxtField.placeholder = "Enter Rank..."
        }else{
            rankTxtField.text = currentlySelectedShow.rank
        }
        
        if currentlySelectedShow.airing == false{
            airingSwitch.isOn = false
            airingLabel.text = "No"
        }else{
            airingSwitch.isOn = true
            airingLabel.text = "Yes"
        }
    }
    
    func designForUI(){
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
        if summaryString != nil{
            textView.text = summaryString
        }else{
            if textView.textColor == UIColor.yellow {
                textView.text = nil
            }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty && summaryString == nil {
            textView.text = "Enter Summary..."
        }else{
            editedSummaryString = textView.text
            summaryString = editedSummaryString
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
            airingLabel.text = "Yes"
            currentlySelectedShow.airing = true
        }else{
            airingLabel.text = "No"
            currentlySelectedShow.airing = false
        }
    }
    
    @IBAction func saveShow(_ sender: Any) {
        var flag = true
        for show in self.allEditedShows {
            if show.rank != nil  {
                if show.rank == rankTxtField.text {
                    // we can't save
                    flag = false
                    break
                }
            }
        }
        if flag{
            updateShow()
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let secondVC = storyboard.instantiateViewController(withIdentifier: "secondViewController") as! SecondViewController
            self.navigationController?.pushViewController(secondVC, animated: true)
        }else{
            // throw a error
            let customAlert = CustomRankAlertViewController()
            customAlert.modalPresentationStyle = .overCurrentContext
            customAlert.modalTransitionStyle = .crossDissolve
            present(customAlert, animated: true)
        }
    }
    
    func updateShow()
    {
        currentlySelectedShow.currentEpisode = currentEpisodeTxtField.text
        currentlySelectedShow.totalEpisodes = totalEpisodesTxtField.text
        currentlySelectedShow.currentSeason = currentSeasonTxtField.text
        currentlySelectedShow.totalSeasons = totalSeasonTxtField.text
        currentlySelectedShow.summary = summaryTextView.text
        currentlySelectedShow.rank = rankTxtField.text
        
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
}

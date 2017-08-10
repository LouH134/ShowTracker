//
//  SecondViewController.swift
//  ShowTracker
//
//  Created by Louis Harris on 8/3/17.
//  Copyright © 2017 Louis Harris. All rights reserved.
//


///////////////////////////////////////////////////////////////////////////////////
//                              TO DO                                            //
//1. addshow textfield populates possibleshows tableview, saves show to coredata//
//2. delete button deletes show in tableview when highlighted                   //
//3. follow show button sends show from possibleshow tableview to followed show//
// tableview in the firstviewcontroller and saves to coredata                  //
//4. Buttons are highlighted when pressed                                      //
/////////////////////////////////////////////////////////////////////////////////

import UIKit

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var addShowButton: UIButton!
    @IBOutlet weak var deleteShowButton: UIButton!
    @IBOutlet weak var addShowTextField: UITextField!
    @IBOutlet weak var possibleShowsTableView: UITableView!
    var keyboardHeight: CGRect!
    var possibleShows = [String]()
    var addShowString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = UIColor.purple
        self.navigationController?.tabBarController?.tabBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.yellow]
        
        addShowButton.layer.cornerRadius = 5
        addShowButton.layer.borderWidth = 2.5
        addShowButton.layer.borderColor = UIColor.purple.cgColor
        addShowButton.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        
        deleteShowButton.layer.cornerRadius = 5
        deleteShowButton.layer.borderWidth = 2.5
        deleteShowButton.layer.borderColor = UIColor.purple.cgColor
        deleteShowButton.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        
        addShowTextField.layer.cornerRadius = 5
        addShowTextField.layer.borderWidth = 2.5
        addShowTextField.layer.borderColor = UIColor.purple.cgColor
        
        self.possibleShowsTableView.delegate = self
        self.possibleShowsTableView.dataSource = self
        
        self.keyboardHeight = self.view.frame
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func keyboardWillShow(notification:NSNotification)
    {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue{
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: keyboardHeight.height - keyboardSize.height - 1)
        }
    }
    
    func keyboardWillHide(notification:NSNotification)
    {
        if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil{
            self.view.frame = keyboardHeight
        }
    }
    
    func dismissKeyboard()
    {
        self.view.endEditing(true)
    }
    
    
    @IBAction func addShowTxtFieldPressed(_ sender: Any) {
        
    }

    @IBAction func addShow(_ sender: Any) {
    }

    @IBAction func deleteShow(_ sender: Any) {
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = possibleShowsTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        return cell
    }
    
    
}


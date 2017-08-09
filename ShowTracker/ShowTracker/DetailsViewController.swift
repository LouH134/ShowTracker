//
//  DetailsViewController.swift
//  ShowTracker
//
//  Created by Louis Harris on 8/9/17.
//  Copyright © 2017 Louis Harris. All rights reserved.
//

//////////////////////////////////////////////////////////////////////////
//                              TO DO                                   //
//1. Nav Controller title is name of show selected from followingVC     //
//2. Labels display info from core data that was sent there by editVC   //
//////////////////////////////////////////////////////////////////////////

import UIKit

class DetailsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.yellow]
        let barButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(goBack))
        self.navigationItem.leftBarButtonItem = barButtonItem
        barButtonItem.tintColor = UIColor.yellow
        
    }
    
    func goBack()
    {
        self.navigationController?.popViewController(animated: true)
    }

}

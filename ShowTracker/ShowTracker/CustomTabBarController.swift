//
//  CustomTabBarController.swift
//  ShowTracker
//
//  Created by Louis Harris on 10/26/17.
//  Copyright © 2017 Louis Harris. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
       // print("log \(item.title)")
        
        let selectedIndex = self.selectedIndex
        var nav = UINavigationController()
        nav = self.viewControllers![selectedIndex] as! UINavigationController
        
        nav.popToRootViewController(animated: false)
  
    }
 
}

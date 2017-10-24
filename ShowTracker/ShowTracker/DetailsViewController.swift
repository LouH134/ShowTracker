//
//  DetailsViewController.swift
//  ShowTracker
//
//  Created by Louis Harris on 8/9/17.
//  Copyright © 2017 Louis Harris. All rights reserved.
//

//////////////////////////////////////////////////////////////////////////////////////
//                              TO DO                                               //
//1. Going from detailsvc to second vc to first vc brings you back to deatilsvc     //
//2. Make summary label scrollable by adding a scroll view to put the label in     //
/////////////////////////////////////////////////////////////////////////////////////

import UIKit

class DetailsViewController: UIViewController {
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var rankingLabel: UILabel!
    @IBOutlet weak var currentSeasonLabel: UILabel!
    @IBOutlet weak var totalSeasonsLabel: UILabel!
    @IBOutlet weak var airingLabel: UILabel!
    @IBOutlet weak var currentEpisodeLabel: UILabel!
    @IBOutlet weak var totalEpisodesLabel: UILabel!
    var currentlySelectedShow:Show!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = currentlySelectedShow.showName
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.yellow]
        let barButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(goBack))
        self.navigationItem.leftBarButtonItem = barButtonItem
        barButtonItem.tintColor = UIColor.yellow
        
        displayShowDetails()
        
        if currentlySelectedShow.summary == "Enter Summary..."{
            summaryLabel.isHidden = true
        }
    }
    
    func displayShowDetails(){
        summaryLabel.text = currentlySelectedShow.summary
        rankingLabel.text = currentlySelectedShow.rank
        
        currentEpisodeLabel.text = currentlySelectedShow.currentEpisode
        currentEpisodeLabel.sizeToFit()
        currentEpisodeLabel.adjustsFontSizeToFitWidth = true
        currentEpisodeLabel.adjustsFontForContentSizeCategory = true
        
        totalEpisodesLabel.text = currentlySelectedShow.totalEpisodes
        totalEpisodesLabel.sizeToFit()
        totalEpisodesLabel.adjustsFontSizeToFitWidth = true
        totalEpisodesLabel.adjustsFontForContentSizeCategory = true
        
        currentSeasonLabel.text = currentlySelectedShow.currentSeason
        currentSeasonLabel.sizeToFit()
        currentSeasonLabel.adjustsFontSizeToFitWidth = true
        currentSeasonLabel.adjustsFontForContentSizeCategory = true
        
        totalSeasonsLabel.text = currentlySelectedShow.totalSeasons
        totalSeasonsLabel.sizeToFit()
        totalSeasonsLabel.adjustsFontSizeToFitWidth = true
        totalSeasonsLabel.adjustsFontForContentSizeCategory = true
        
        if currentlySelectedShow.airing == true{
            airingLabel.text = "YES"
        }else{
            airingLabel.text = "NO"
        }
    }
    
    func goBack()
    {
        self.navigationController?.popViewController(animated: true)
    }

}

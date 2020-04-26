//
//  TeamDetailViewController.swift
//  MLBTeamStats
//
//  Created by Thomas Wade on 4/26/20.
//  Copyright © 2020 Thomas Wade. All rights reserved.
//

import UIKit

class TeamDetailViewController: UIViewController {
    
    @IBOutlet weak var firstSeasonLabel: UILabel!
    @IBOutlet weak var teamNameLabel: UILabel!
    var teamData: TeamData!
    var urlAddition: String = ""
    //var urlAddition: String
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUserInterface()
        
        
    }
    @IBAction func viewRosterButtonPressed(_ sender: Any) {
        urlAddition = teamData.link
        print(urlAddition)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowRosterDetail"{
            let destination = segue.destination as! RosterViewController
            //let selectedIndexPath = teamsTableView.indexPathForSelectedRow!
            destination.urlRoster = teamData.link
        }
    }
    func updateUserInterface(){
        teamNameLabel.text = teamData.name
        firstSeasonLabel.text = teamData.firstYearOfPlay
        
        print("updated interface:",urlAddition)
        
    }
}

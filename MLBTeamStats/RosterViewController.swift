//
//  RosterViewController.swift
//  MLBTeamStats
//
//  Created by Thomas Wade on 4/26/20.
//  Copyright © 2020 Thomas Wade. All rights reserved.
//

import UIKit

class RosterViewController: UIViewController {
    
    
    @IBOutlet weak var rosterTableView: UITableView!
    
    var urlRoster: String!
    //var rosterArray = ["Tommy Wade","Maddie Gatto","Mike Wade"]
    var roster = Rosters()
    var urlRosterAddition: String = ""
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        urlRosterAddition = urlRoster
        print(urlRosterAddition)
        rosterTableView.delegate = self
        rosterTableView.dataSource = self
        
        roster.getData {
            self.urlRosterAddition = self.urlRoster
            DispatchQueue.main.async {
                self.rosterTableView.reloadData()
            }
        }
    }
    
    
}

extension RosterViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return roster.rosterArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = rosterTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = roster.rosterArray[indexPath.row].jerseyNumber
        return cell
    }
    
    
}

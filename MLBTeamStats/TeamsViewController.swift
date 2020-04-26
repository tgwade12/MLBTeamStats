//
//  ViewController.swift
//  MLBTeamStats
//
//  Created by Thomas Wade on 4/26/20.
//  Copyright © 2020 Thomas Wade. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var teamsTableView: UITableView!
    
    // var teams = ["Cubs","Angels","White Sox"]
    var teams = Teams()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        teamsTableView.delegate = self
        teamsTableView.dataSource = self
        
        teams.getData {
            DispatchQueue.main.async {
                self.teamsTableView.reloadData()
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowTeamDetail"{
            let destination = segue.destination as! TeamDetailViewController
            let selectedIndexPath = teamsTableView.indexPathForSelectedRow!
            destination.teamData = teams.teamArray[selectedIndexPath.row]
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teams.teamArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = teamsTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = teams.teamArray[indexPath.row].name
        return cell
    }
    
    
}

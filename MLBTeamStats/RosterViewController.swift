//
//  RosterViewController.swift
//  MLBTeamStats
//
//  Created by Thomas Wade on 4/26/20.
//  Copyright © 2020 Thomas Wade. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class RosterViewController: UIViewController {
    
    
    @IBOutlet weak var rosterTableView: UITableView!
    

    var urlRoster: String!
    var roster = Rosters()
    var urlRosterAddition: String = ""
    var rosterArray: Array<String> = []
    var positionArray: Array<String> = []
    var linkArray: Array<String> = []
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        urlRosterAddition = urlRoster
        print(urlRosterAddition)
        
        
        AF.request("https://statsapi.mlb.com/\(urlRosterAddition)/roster").responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                //print (json)
                
                for i in 0...json["roster"].count{
                    if let fullName = json["roster"][i]["person"]["fullName"].string {
                        self.rosterArray.append(fullName)
                    }
                }
                for i in 0...json["roster"].count{
                    if let position = json["roster"][i]["position"]["abbreviation"].string {
                        self.positionArray.append(position)
                    }
                }
                
                for i in 0...json["roster"].count{
                    if let link = json["roster"][i]["person"]["link"].string {
                        self.linkArray.append(link)
                    }
                }
                
            case .failure(let error):
                print (error)
            }
            print("here is the array inside of JSON:",self.rosterArray)
            print ("link array:",self.linkArray)
            self.updateUserInterface()
            //print (self.rosterArray.count)
        }
        rosterTableView.delegate = self
        rosterTableView.dataSource = self
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowStatDetail"{
            let destination = segue.destination as! StatisticsViewController
            let selectedIndexPath = rosterTableView.indexPathForSelectedRow!
            destination.profileURL = linkArray[selectedIndexPath.row]
        }
    }
}




extension RosterViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rosterArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = rosterTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = "\(rosterArray[indexPath.row]),  \(positionArray[indexPath.row])"
        return cell
    }
    func updateUserInterface(){
        rosterTableView.reloadData()
    }
    
    
}

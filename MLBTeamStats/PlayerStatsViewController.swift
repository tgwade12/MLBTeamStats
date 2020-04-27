//
//  PlayerStatsViewController.swift
//  MLBTeamStats
//
//  Created by Thomas Wade on 4/27/20.
//  Copyright © 2020 Thomas Wade. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class PlayerStatsViewController: UIViewController {
    
    @IBOutlet weak var seasonLabel: UILabel!
    @IBOutlet weak var gameCountLabel: UILabel!
    @IBOutlet weak var inningsPitchedHitsLabel: UILabel!
    @IBOutlet weak var inningsPitchedHitsCountLabel: UILabel!
    
    @IBOutlet weak var runsSOLabel: UILabel!
    @IBOutlet weak var runsSOCountLabel: UILabel!
    @IBOutlet weak var kHRCountLabel: UILabel!
    @IBOutlet weak var kHRLabel: UILabel!
    @IBOutlet weak var whipOPSCountLabel: UILabel!
    @IBOutlet weak var whipOPSLabel: UILabel!
    @IBOutlet weak var eraAvgCountLabel: UILabel!
    @IBOutlet weak var eraAvgLabel: UILabel!
    
    
    var profilePosition: String!
    var profileURL: String!
    var season: Int!
    var seasonNumber: String!
    var position: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        seasonLabel.text = "\(seasonNumber!)"
        print (profileURL!)
        print (season!)
        print (position!)
        
        
        
        
        
        if position == "Pitcher" {
            inningsPitchedHitsLabel.text = "Innings Pitched:"
            runsSOLabel.text = "Runs:"
            kHRLabel.text = "Strikeouts:"
            whipOPSLabel.text = "WHIP:"
            eraAvgLabel.text = "ERA:"
            AF.request("https://statsapi.mlb.com\(profileURL!)?hydrate=stats(group=[pitching],type=[yearByYear])").responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    
                    let games = json["people"][0]["stats"][0]["splits"].count
                    print (games)
                    
                    
                case .failure(let error):
                    print (error)
                }
            }
        } else {
            inningsPitchedHitsLabel.text = "Hits:"
            runsSOLabel.text = "Strikeouts:"
            kHRLabel.text = "Home Runs:"
            whipOPSLabel.text = "OPS:"
            eraAvgLabel.text = "Avg:"
            AF.request("https://statsapi.mlb.com\(profileURL!)?hydrate=stats(group=[hitting],type=[yearByYear])").responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    
                    let games = json["people"][0]["stats"][0]["splits"][self.season]["stat"]["gamesPlayed"].int
                    print (games)
                    let hits = json["people"][0]["stats"][0]["splits"][self.season]["stat"]["hits"].int
                    let strikeouts = json["people"][0]["stats"][0]["splits"][self.season]["stat"]["strikeOuts"].int
                    let homeRuns = json["people"][0]["stats"][0]["splits"][self.season]["stat"]["homeRuns"].int
                    let ops = json["people"][0]["stats"][0]["splits"][self.season]["stat"]["ops"].string
                    let avg = json["people"][0]["stats"][0]["splits"][self.season]["stat"]["avg"].string
                    
                    self.gameCountLabel.text = "\(games!)"
                    self.inningsPitchedHitsCountLabel.text = "\(hits!)"
                    self.runsSOCountLabel.text = "\(strikeouts!)"
                    self.kHRCountLabel.text = "\(homeRuns!)"
                    self.whipOPSCountLabel.text = ops
                    self.eraAvgCountLabel.text = avg
                    
                    
                case .failure(let error):
                    print (error)
                }
            }
        }
    }
    
}


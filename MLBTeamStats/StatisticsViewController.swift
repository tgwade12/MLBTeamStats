//
//  StatisticsViewController.swift
//  MLBTeamStats
//
//  Created by Thomas Wade on 4/26/20.
//  Copyright © 2020 Thomas Wade. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class StatisticsViewController: UIViewController {


    @IBOutlet weak var statYearTable: UITableView!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var batsLabel: UILabel!
    @IBOutlet weak var throwsLabel: UILabel!
    @IBOutlet weak var bornLabel: UILabel!
    @IBOutlet weak var debutLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    
    
    @IBOutlet weak var gamesLabel: UILabel!
    @IBOutlet weak var hitsIPLabel: UILabel!
    @IBOutlet weak var hitsIPCountLabel: UILabel!
    @IBOutlet weak var averageKsLabel: UILabel!
    @IBOutlet weak var averageKsCountLabel: UILabel!
    @IBOutlet weak var opsERALabel: UILabel!
    @IBOutlet weak var opsERACountLabel: UILabel!
    
    var profilePosition: String!
    var profileURL: String!
    var profileURLReceived: String = ""
    var yearsPlayed: Array<String> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileURLReceived = profileURL
        getData(URL: profileURL)
        statYearTable.delegate = self
        statYearTable.dataSource = self
        
        updateUserInterface()
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowSeasonDetail"{
            let destination = segue.destination as! PlayerStatsViewController
            let selectedIndexPath = statYearTable.indexPathForSelectedRow!
            destination.profileURL = profileURL
            destination.season = statYearTable.indexPathForSelectedRow?.row ?? 0
            destination.position = self.positionLabel.text
            destination.seasonNumber = yearsPlayed[statYearTable.indexPathForSelectedRow?.row ?? 0]
            
        }
    }
    func getData(URL: String){
        AF.request("https://statsapi.mlb.com\(profileURLReceived)").responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                //print (json)
                
                var returnedData: Array<String> = []
                
                let fullName = json["people"][0]["fullName"].string
                returnedData.append(fullName ?? "")
                let bats = json["people"][0]["batSide"]["code"].string
                returnedData.append(bats ?? "")
                let throwHand = json["people"][0]["pitchHand"]["code"].string
                returnedData.append(throwHand ?? "")
                let born = json["people"][0]["birthDate"].string
                returnedData.append(born ?? "")
                let debut = json["people"][0]["mlbDebutDate"].string
                returnedData.append(debut ?? "")
                let number = json["people"][0]["primaryNumber"].string
                returnedData.append("#\(number ?? "")" )
                let position = json["people"][0]["primaryPosition"]["name"].string
                returnedData.append(position ?? "")
                print(returnedData)
                
                if position == "Pitcher"{
                    self.getPitcherCareerData(URL: self.profileURLReceived)
                } else {
                    self.getHitterCareerData(URL: self.profileURLReceived)
                }
                
                self.nameLabel.text = returnedData[0]
                self.batsLabel.text = returnedData[1]
                self.throwsLabel.text = returnedData[2]
                self.bornLabel.text = returnedData[3]
                self.debutLabel.text = returnedData[4]
                self.numberLabel.text = returnedData[5]
                self.positionLabel.text = returnedData[6]
            case .failure(let error):
                print (error)
            }
        }
    }
    func getPitcherCareerData(URL: String){
        print("pitcher")
        print (URL)
        self.hitsIPLabel.text = "IP:"
        self.averageKsLabel.text = "Ks:"
        self.opsERALabel.text = "ERA:"
        
        yearByYearPitchingData(URL: profileURL)
        
        AF.request("https://statsapi.mlb.com\(profileURLReceived)?hydrate=stats(group=[pitching],type=[career])").responseJSON { response in
            switch response.result {
            case .success(let value):
                print ("inside JSON")
                let json = JSON(value)
                
                let games = json["people"][0]["stats"][0]["splits"][0]["stat"]["gamesPlayed"].int
                self.gamesLabel.text = "\(games ?? 0)"
                let inningsPitched = json["people"][0]["stats"][0]["splits"][0]["stat"]["inningsPitched"].string
                self.hitsIPCountLabel.text = inningsPitched
                let strikeouts = json["people"][0]["stats"][0]["splits"][0]["stat"]["strikeOuts"].int
                self.averageKsCountLabel.text = "\(strikeouts ?? 0)"
                let earnedRunAverage = json["people"][0]["stats"][0]["splits"][0]["stat"]["era"].string
                self.opsERACountLabel.text = earnedRunAverage
                
            case .failure(let error):
                print (error)
            }
        }
    }
    func getHitterCareerData(URL: String){
        print (URL)
        print("not a pitcher")
        self.hitsIPLabel.text = "Hits:"
        self.averageKsLabel.text = "Avg:"
        self.opsERALabel.text = "OPS:"
        yearByYearHittingData(URL: profileURL)
        
        AF.request("https://statsapi.mlb.com\(profileURLReceived)?hydrate=stats(group=[hitting],type=[career])").responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                let games = json["people"][0]["stats"][0]["splits"][0]["stat"]["gamesPlayed"].int
                self.gamesLabel.text = "\(games ?? 0)"
                let hits = json["people"][0]["stats"][0]["splits"][0]["stat"]["hits"].int
                self.hitsIPCountLabel.text = " \(hits ?? 0)"
                let average = json["people"][0]["stats"][0]["splits"][0]["stat"]["avg"].string
                self.averageKsCountLabel.text = " \(average ?? "")"
                let ops = json["people"][0]["stats"][0]["splits"][0]["stat"]["ops"].string
                self.opsERACountLabel.text = " \(ops ?? "")"
                
            case .failure(let error):
                print (error)
            }
        }
    }
    
    func yearByYearHittingData(URL: String){
        AF.request("https://statsapi.mlb.com\(profileURLReceived)?hydrate=stats(group=[hitting],type=[yearByYear])").responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                let games = json["people"][0]["stats"][0]["splits"].count
                for i in 0...games-1{
                    self.yearsPlayed.append(json["people"][0]["stats"][0]["splits"][i]["season"].string ?? "")
                    print(self.yearsPlayed)
                    self.updateUserInterface()
                }
                
                
            case .failure(let error):
                print (error)
            }
        }
    }
    func yearByYearPitchingData(URL: String){
        AF.request("https://statsapi.mlb.com\(profileURLReceived)?hydrate=stats(group=[pitching],type=[yearByYear])").responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                let games = json["people"][0]["stats"][0]["splits"].count
                print (games)
                for i in 0...games-1{
                    self.yearsPlayed.append(json["people"][0]["stats"][0]["splits"][i]["season"].string ?? "")
                    print(self.yearsPlayed)
                    self.updateUserInterface()
                }
                
                
            case .failure(let error):
                print (error)
            }
        }
    }
}

extension StatisticsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return yearsPlayed.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = statYearTable.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "\(yearsPlayed[indexPath.row])"
        return cell
    }
    func updateUserInterface(){
        statYearTable.reloadData()
    }
}

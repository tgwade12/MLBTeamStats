//
//  Rosters.swift
//  MLBTeamStats
//
//  Created by Thomas Wade on 4/26/20.
//  Copyright © 2020 Thomas Wade. All rights reserved.
//

import Foundation
import SwiftyJSON

class Rosters {
    
    
    
    private struct Returned: Codable {
        var roster: [RosterData] = []
    }
    
    var rosterArray: [RosterData] = []
    var url = urlBase + rosterAddition + "/roster"
    
    func getData(completed: @escaping ()->()) {
        let urlString = url
         print ("we are accessing the URL \(urlString)")
        
        //Create a URL
        
        guard let url = URL(string: urlString) else {
            print("Error: could not create a URL from \(urlString)")
            completed()
            return
        }
        
        // create session
        
        let session = URLSession.shared
        
        print ("creating session\(session)")
        
        //Get data with .dataTask method
        
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print ("Error: \(error.localizedDescription)")
            }
            
            do {
                let returned = try JSONDecoder().decode(Returned.self, from: data!)
                self.rosterArray = returned.roster
                
            } catch {
                print ("JSON Error: \(error)")
            }
            completed()
        }
        task.resume()
    }
}

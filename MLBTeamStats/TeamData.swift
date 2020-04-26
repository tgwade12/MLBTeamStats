//
//  TeamData.swift
//  MLBTeamStats
//
//  Created by Thomas Wade on 4/26/20.
//  Copyright © 2020 Thomas Wade. All rights reserved.
//

import Foundation

struct TeamData: Codable {
    var name: String
    var id: Int
    var link: String
    var firstYearOfPlay: String
}

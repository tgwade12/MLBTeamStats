//
//  URLConstants.swift
//  MLBTeamStats
//
//  Created by Thomas Wade on 4/26/20.
//  Copyright © 2020 Thomas Wade. All rights reserved.
//

import Foundation


var urlBase = "https://statsapi.mlb.com"
var teamsAddition = "//api/v1/teams?sportId=1"
var rosterAddition = "/api/v1/teams/140" //140 changes for each team, need ID array to iterate through to get data
var playerProfileAddition = "/api/v1/people/" //after last slash comes a profile ID #
var playerStatsAddition = "?hydrate=stats(group=[hitting,pitching,fielding],type=[yearByYear])" // stats addition gets added onto the profile URL to get to the statistics

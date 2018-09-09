//
//  DiveSite.swift
//  Final Dive App
//
//  Created by Thomas Simko on 2/28/18.
//  Copyright © 2018 Thomas Simko. All rights reserved.
//

import Foundation

class DiveSiteWrapper: Codable {
   var sites: [Site]
}

class Site: Codable {
   var currents: String?
   var distance: String
   var hazards: String?
   var lat: String?
   var name: String
   var water: String?
   var marinelife: String?
   var description: String?
   var maxdepth: String?
   var mindepth: String?
   var predive: String?
   var id: String
   var equipment: String?
   var lng: String?
}

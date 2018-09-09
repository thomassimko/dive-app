//
//  DiveSiteDetail.swift
//  Final Dive App
//
//  Created by Thomas Simko on 2/28/18.
//  Copyright © 2018 Thomas Simko. All rights reserved.
//

import Foundation

class DiveSiteDetailWrapper: Codable {
   var site: SiteDetail
}

class SiteDetail:Codable {
   var rating: String?
   var created_on: String?
   var votes: String?
   var created_by: String?
}

class ExternalUrls: Codable {
   var urls: ExternalUrlData?
}

class ExternalUrlData: Codable {
   var name: String?
   var url: String?
}

//
//  Dive.swift
//  Final Dive App
//
//  Created by Thomas Simko on 2/23/18.
//  Copyright © 2018 Thomas Simko. All rights reserved.
//

import Foundation
import MapKit

class Dive: NSObject, Codable, MKAnnotation {
   
   static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
   static let ArchiveURL = DocumentsDirectory.appendingPathComponent("dives")
   
   var newDive:Dive?;
   var name:String?
   var location:String?
   var rating:String?
   var maxDepth: Int?
   var maxDepthUnits: String?
   var airTemp: Int?
   var surfaceTemp: Int?
   var bottomTemp: Int?
   var tempUnits: String?
   var exposureProtection: [String]?
   var conditions: [String]?
   var comments: String?
   var startBar: Int?
   var endBar: Int?
   var timeIn: Date?
   var timeOut: Date?
   var date: Date?
   var visibility: Int?
   var visibilityUnits: String?
   var weight: Int?
   var weightUnits: String?
   var diveNumber: Int?
   var latitude: Double?
   var longitude: Double?
   var timestamp: Date?
   
   init(name:String?, location:String?, rating:String?, maxDepth: Int?, maxDepthUnits: String?, airTemp: Int?, surfaceTemp: Int?, bottomTemp: Int?, tempUnits: String?, exposureProtection: [String]?, conditions: [String]?, comments: String?, startBar: Int?, endBar: Int?, timeIn: Date?, timeOut: Date?, date: Date?, visibility: Int?, visibilityUnits: String?, weight: Int?, weightUnits: String?, diveNumber: Int?, latitude: Double?, longitude: Double?, timestamp: Date?) {
      
      
      self.name = name;
      self.location = location;
      self.rating = rating;
      self.maxDepth = maxDepth;
      self.maxDepthUnits = maxDepthUnits;
      self.airTemp = airTemp;
      self.surfaceTemp = surfaceTemp;
      self.bottomTemp = bottomTemp;
      self.tempUnits = tempUnits;
      self.exposureProtection = exposureProtection;
      self.conditions = conditions;
      self.comments = comments;
      self.startBar = startBar;
      self.endBar = endBar;
      self.timeIn = timeIn;
      self.timeOut = timeOut;
      self.date = date;
      self.visibility = visibility;
      self.visibilityUnits = visibilityUnits;
      self.weight = weight;
      self.weightUnits = weightUnits;
      self.diveNumber = diveNumber;
      self.latitude = latitude;
      self.longitude = longitude;
      self.timestamp = timestamp;
   }
   
   init (dict: [String: Any?]) {
      
      func convertTimeIntervalToDate(timestamp: Any?) -> Date? {
         if let interval = timestamp as? TimeInterval {
            return Date.init(timeIntervalSinceReferenceDate: interval)
         }
         return nil;
      }
      
      self.name = dict["name"] as? String;
      self.location = dict["location"] as? String;
      self.rating = dict["rating"] as? String;
      self.maxDepth = dict["maxDepth"] as? Int;
      self.maxDepthUnits = dict["maxDepthUnits"] as? String;
      self.airTemp = dict["airTemp"] as? Int;
      self.surfaceTemp = dict["surfaceTemp"] as? Int;
      self.bottomTemp = dict["bottomTemp"] as? Int;
      self.tempUnits = dict["tempUnits"] as? String;
      self.exposureProtection = dict["exposureProtection"] as? [String];
      self.conditions = dict["conditions"] as? [String];
      self.comments = dict["comments"] as? String;
      self.startBar = dict["startBar"] as? Int;
      self.endBar = dict["endBar"] as? Int;
      self.timeIn = convertTimeIntervalToDate(timestamp: dict["timeIn"] ?? nil);
      self.timeOut = convertTimeIntervalToDate(timestamp: dict["timeOut"] ?? nil);
      self.date = convertTimeIntervalToDate(timestamp: dict["date"] ?? nil);
      self.visibility = dict["visibility"] as? Int;
      self.visibilityUnits = dict["visibilityUnits"] as? String;
      self.weight = dict["weight"] as? Int;
      self.weightUnits = dict["weightUnits"] as? String;
      self.diveNumber = dict["diveNumber"] as? Int;
      self.latitude = dict["latitude"] as? Double;
      self.longitude = dict["longitude"] as? Double;
      self.timestamp = convertTimeIntervalToDate(timestamp: dict["timestamp"] ?? nil);
      print(self.timestamp as Any)
   }
   
   func toString() -> String {
      var commentString = ""
      if let name = self.name {
         commentString.append("I just logged a dive at " + name);
      }
      if let location = self.location {
         commentString.append(" in " + location);
      }
      commentString.append(" using Thomas's Dive Logger.")
      return commentString;
   }
   
   var coordinate: CLLocationCoordinate2D {
      return CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
   }
   
   var title: String? {
      return name
   }
   
   var subtitle: String? {
      return rating
   }
   
}
extension Encodable {
   var dictionary: [String: Any]? {
      guard let data = try? JSONEncoder().encode(self) else { return nil }
      return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
   }
}

//
//  LocalDiveLoader.swift
//  Final Dive App
//
//  Created by Thomas Simko on 3/5/18.
//  Copyright © 2018 Thomas Simko. All rights reserved.
//

import Foundation
import os

class LocalDiveLoader {

   static func saveToLocal(_ myDives: [Dive]) {
      do {
         let data = try PropertyListEncoder().encode(myDives);
         let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(data, toFile: Dive.ArchiveURL.path)
         if isSuccessfulSave {
            os_log("Dives successfully saved.", log: OSLog.default, type: .debug)
         } else {
            os_log("Failed to save dives...", log: OSLog.default, type: .error)
         }
      } catch {
         print("Error formatting data")
      }
   }

   static func loadDives() -> [Dive]? {
      if let unarchived = NSKeyedUnarchiver.unarchiveObject(withFile: Dive.ArchiveURL.path) as? Data {
         do {
            let dives = try PropertyListDecoder().decode([Dive].self, from: unarchived)
            return dives
         } catch {
            print("Retrieve Failed")
            return nil
         }
      }
      return []
   }
}

//
//  ResolveDives.swift
//  Final Dive App
//
//  Created by Thomas Simko on 3/9/18.
//  Copyright © 2018 Thomas Simko. All rights reserved.
//

import Foundation

class ResolveDives {
   
//   static func getDives() -> (fromCloud: Bool, dives: [Dive]) {
//      let cloudDives = CloudDiveLoader.fetchFromCloud();
//      let localDives = LocalDiveLoader.loadDives();
//      if(cloudDives.count != 0 && isCloudMoreRecent(cloudDives: cloudDives, localDives: localDives!)) {
//         return (fromCloud: true, dives: cloudDives)
//      }
//      return (fromCloud: false, dives: localDives ?? [])
//   }
   
   static func isCloudMoreRecent(cloudDives: [Dive], localDives: [Dive]) -> Bool {
      print(cloudDives.count)
      print(localDives.count)
      if (cloudDives.count == 0) {
         return false
      } else if (localDives.count == 0) {
         return true
      }
      let mostRecentCloudDive = getDiveWithMostRecentChange(dives: cloudDives);
      let mostRecentLocalDive = getDiveWithMostRecentChange(dives: localDives);
      print(mostRecentCloudDive.timestamp)
      print(mostRecentLocalDive.timestamp)

      return mostRecentCloudDive.timestamp!.compare(mostRecentLocalDive.timestamp!) == .orderedDescending;
   }
   
   private static func getDiveWithMostRecentChange(dives: [Dive]) -> Dive {
      return dives.sorted(by: { $0.timestamp!.compare($1.timestamp!) == .orderedDescending})[0]
   }
}

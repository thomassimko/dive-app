//
//  CloudDiveLoader.swift
//  Final Dive App
//
//  Created by Thomas Simko on 3/9/18.
//  Copyright © 2018 Thomas Simko. All rights reserved.
//

import Foundation
import CloudKit

class CloudDiveLoader {
   
   
   static func saveToCloud(newDive:Dive) {
      let database = CKContainer.default().privateCloudDatabase
      let dive = CKRecord(recordType: "Dive");
      newDive.dictionary?.forEach({ (key, value) in
         if let stringArray = value as? [String] {
            guard stringArray == [] else {
               dive.setValue(value, forKey: key)
               return
            }
         }
         else {
            dive.setValue(value, forKey: key)
         }
      });
      
      database.save(dive) { (record, err) in
         guard record != nil else {
            print(err ?? "no err1")
            return
         }
         print("saved record")
      }
   }
   
   
   static func overwriteCloudData(dive:Dive) {
      let database = CKContainer.default().privateCloudDatabase

      if let diveNum = dive.diveNumber {
         let predicate = NSPredicate(format: "diveNumber == %@", NSNumber(value: diveNum))
         let query = CKQuery(recordType: "Dive", predicate: predicate);
         database.perform(query, inZoneWith: nil) { (recordArr, err) in
            if let records = recordArr {
               if (records.count == 1) {
                  print("here")
                  database.delete(withRecordID: records[0].recordID, completionHandler: { (id, err) in
                     guard id != nil else {
                        print(err ?? "no err2")
                        return
                     }
                  });
               }
               else {
                  print("record not found")
               }
               self.saveToCloud(newDive: dive)
            }
            else {
               print("error")
               print(err ?? "no err3")
               return
            }
         }
      }
   }
   
   static func updateField(dive: Dive, value: CKRecordValue, key: String) {
      let database = CKContainer.default().privateCloudDatabase
      
      if let diveNum = dive.diveNumber {
         let predicate = NSPredicate(format: "diveNumber == %@", NSNumber(value: diveNum))
         let query = CKQuery(recordType: "Dive", predicate: predicate);
         database.perform(query, inZoneWith: nil) { (recordArr, err) in
            if let records = recordArr {
               if (records.count == 1) {
                  records[0].setObject(value, forKey: key)
                  database.save(records[0], completionHandler: { (id, err) in
                     guard id != nil else {
                        print(err ?? "no err5")
                        return
                     }
                  })
               }
            }
            else {
               print(err ?? "no err6")
               return
            }
         }
      }
   }
   
   static func fetchFromCloud(completion: @escaping (_ dives: [Dive], _ fromCloud: Bool) -> Void) {
      let database = CKContainer.default().privateCloudDatabase

      let predicate = NSPredicate(value: true)
      let query = CKQuery(recordType: "Dive", predicate: predicate);
      var cloudDives = [Dive]();

      
      database.perform(query, inZoneWith: nil) { (recordArr, err) in
         var fromCloud = false;
         var dives = [Dive]();
         if let records = recordArr {
            for record in records {
               let keys = record.allKeys()
               var dict = [String: Any?]();
               for key in keys {
                  dict[key] = record.value(forKey: key)
               }
               cloudDives.append(Dive(dict: dict));
            }
            let localDives = LocalDiveLoader.loadDives();
            if(cloudDives.count != 0 && ResolveDives.isCloudMoreRecent(cloudDives: cloudDives, localDives: localDives!)) {
               fromCloud = true;
               dives = cloudDives;
               print("from cloud")
               LocalDiveLoader.saveToLocal(dives)
            }
            else {
               dives = localDives ?? []
               print("from local")
               for dive in dives {
                  CloudDiveLoader.overwriteCloudData(dive: dive)
               }
               print("sycned with cloud")
            }
            print(dives)
            completion(dives, fromCloud);
         }
         else {
            completion(LocalDiveLoader.loadDives() ?? [], false)
            print(err ?? "no err4")
            return
         }
      }
   }
   
   static func deleteDiveFromCloudData(dive:Dive) {
      let database = CKContainer.default().privateCloudDatabase

      if let diveNum = dive.diveNumber {
         let predicate = NSPredicate(format: "diveNumber == %@", NSNumber(value: diveNum))
         let query = CKQuery(recordType: "Dive", predicate: predicate);
         database.perform(query, inZoneWith: nil) { (recordArr, err) in
            if let records = recordArr {
               if (records.count == 1) {
                  database.delete(withRecordID: records[0].recordID, completionHandler: { (id, err) in
                     guard id != nil else {
                        print(err ?? "no err5")
                        return
                     }
                  })
               }
            }
            else {
               print(err ?? "no err6")
               return
            }
         }
      }
   }
}

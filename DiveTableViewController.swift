//
//  DiveTableViewController.swift
//  Final Dive App
//
//  Created by Thomas Simko on 2/23/18.
//  Copyright © 2018 Thomas Simko. All rights reserved.
//

import UIKit
import CloudKit
import os

class DiveTableViewController: UITableViewController {
      
   @IBOutlet var table: UITableView!
   var myDives = [Dive]();
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
      
      let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
      loadingIndicator.hidesWhenStopped = true
      loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
      loadingIndicator.startAnimating();
      
      alert.view.addSubview(loadingIndicator)
      present(alert, animated: true, completion: nil)
      
      CloudDiveLoader.fetchFromCloud { (dives, fromCloud) in
         self.myDives += dives.sorted(by: {$0.diveNumber! < $1.diveNumber!})
         
         self.dismiss(animated: true, completion: nil)
         
         if(fromCloud) {
            let alert = UIAlertController(title: "Data Loaded from Cloud", message: "Changes from iCloud have been downloaded.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
            
            self.present(alert, animated: true)
         }
            
         DispatchQueue.main.async {
            self.table.reloadData()
         }
      }
   }
   
   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
   }
   
   // MARK: - Table view data source
   
   override func numberOfSections(in tableView: UITableView) -> Int {
      return 1
   }
   
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      // #warning Incomplete implementation, return the number of rows
      return myDives.count;
   }
   
   override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
      return true
   }
   
   override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
      if editingStyle == .delete {
         CloudDiveLoader.deleteDiveFromCloudData(dive: myDives[indexPath.row])
         myDives.remove(at: indexPath.row)
         table.deleteRows(at: [indexPath], with: .fade)
         
         for i in indexPath.row..<myDives.count {
            CloudDiveLoader.updateField(dive: myDives[i], value: i + 1 as CKRecordValue, key: "diveNumber")
            myDives[i].diveNumber = i + 1;
         }
         LocalDiveLoader.saveToLocal(myDives);
      }
   }
   
   
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as? DiveLogTableViewCell
      
      // Configure the cell...
      let thisDive = myDives[indexPath.row]
      cell?.name.text = thisDive.name
      cell?.location.text = thisDive.location
      cell?.rating.text = thisDive.rating
      
      return cell!
   }
   
   @IBAction func unwindToDiveLog(sender: UIStoryboardSegue) {
      if let sourceViewController = sender.source as? NewDiveViewController, let dive = sourceViewController.newDive
      {
         dive.timestamp = Date();
         if let selectedIndexPath = tableView.indexPathForSelectedRow {
            myDives[selectedIndexPath.row] = dive
            tableView.reloadRows(at: [selectedIndexPath], with: .none)
            
            CloudDiveLoader.overwriteCloudData(dive: dive)
            
         } else {
            let newIndexPath = IndexPath(row: myDives.count, section: 0)
            
            myDives.append(dive)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
            
            CloudDiveLoader.saveToCloud(newDive: dive)
         }
         LocalDiveLoader.saveToLocal(myDives)
      }
   }
   
   
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      // Get the new view controller using segue.destinationViewController.
      // Pass the selected object to the new view controller.
      if segue.identifier == "diveDetailSegue" {
         let destVC = segue.destination as? NewDiveViewController
         let selectedIndexPath = table.indexPathForSelectedRow
         destVC?.newDive = myDives[(selectedIndexPath?.row)!]
         destVC?.diveNumber = (selectedIndexPath?.row)! + 1
      }
      else if segue.identifier == "addDiveSegue" {
         let navVC = segue.destination as? UINavigationController
         let destVC = navVC?.viewControllers.first as! NewDiveViewController
         destVC.diveNumber = myDives.count + 1
      }
   }
   
   
}

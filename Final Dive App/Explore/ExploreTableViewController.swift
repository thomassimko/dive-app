//
//  ExploreTableViewController.swift
//  Final Dive App
//
//  Created by Thomas Simko on 2/27/18.
//  Copyright © 2018 Thomas Simko. All rights reserved.
//

import UIKit
import MapKit

class ExploreTableViewController: UITableViewController, CLLocationManagerDelegate {
   
   @IBOutlet var table: UITableView!
   let locationManager = CLLocationManager()
   let diveAPI = "http://api.divesites.com"
   
   var diveSites = [Site]()
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      locationManager.requestWhenInUseAuthorization()
      
      if CLLocationManager.locationServicesEnabled() {
         locationManager.delegate = self
         locationManager.desiredAccuracy = kCLLocationAccuracyBest
         locationManager.startUpdatingLocation()
      }
      
      let session = URLSession(configuration: URLSessionConfiguration.default)
      
      let request = URLRequest(url: URL(string: diveAPI)!)
      
      let task: URLSessionDataTask = session.dataTask(with: request) { (receivedData, response, error) -> Void in
         
         if let data = receivedData {
            
            var diveSiteObj : DiveSiteWrapper?;
            
            do {
               diveSiteObj = try JSONDecoder().decode(DiveSiteWrapper.self, from: data)
               self.diveSites = diveSiteObj!.sites
            }
            catch {
               print("Caught exception \(error)")
            }
            DispatchQueue.main.async {
               self.tableView.reloadData();
            }
         }
      }
      task.resume();
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
      return diveSites.count
   }
   
   func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
      if(status == CLAuthorizationStatus.denied) {
         showLocationDisabledPopUp()
      }
   }
   
   func showLocationDisabledPopUp() {
      let alertController = UIAlertController(title: "Background Location Access Disabled",
                                              message: "In order to find nearby dives we need your location.",
                                              preferredStyle: .alert)
      
      let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
      alertController.addAction(cancelAction)
      
      let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
         if let url = URL(string: UIApplicationOpenSettingsURLString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
         }
      }
      alertController.addAction(openAction)
      
      self.present(alertController, animated: true, completion: nil)
   }
   
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "ExploreCell", for: indexPath) as? ExploreTableViewCell
      
      // Configure the cell...
      let thisDive = diveSites[indexPath.row]
      cell?.diveName.text = thisDive.name
      cell?.distance.text = String(format: "%.0f", (Double(thisDive.distance)!.rounded())) + " km"
      
      return cell!
   }
   
   @IBAction func unwindtoExploreTable(sender: UIStoryboardSegue) {
   }
   
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if segue.identifier == "exploreDiveSegue" {
         let destVC = segue.destination as? ExploreDiveViewController
         let selectedIndexPath = table.indexPathForSelectedRow
         destVC?.diveSite = diveSites[(selectedIndexPath?.row)!]
      }
   }
}

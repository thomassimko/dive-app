//
//  NewDiveViewController.swift
//  Final Dive App
//
//  Created by Thomas Simko on 2/26/18.
//  Copyright © 2018 Thomas Simko. All rights reserved.
//

import UIKit
import Eureka
import MapKit
import FacebookShare

class NewDiveViewController: FormViewController, CLLocationManagerDelegate {
   
   @IBOutlet weak var saveButton: UIBarButtonItem!
   var newDive:Dive?;
   var diveNumber:Int?;
   var editable:Bool = true;
   
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
   var clLocation: CLLocationCoordinate2D?
   
   let locationManager = CLLocationManager()
   
   override func viewDidLoad() {
      super.viewDidLoad()
      self.exposureProtection = [];
      self.conditions = []
      self.updateSaveButtonState()
      self.updateShareButtonState()
      
      locationManager.requestWhenInUseAuthorization()
      
      if CLLocationManager.locationServicesEnabled() {
         locationManager.delegate = self
         locationManager.desiredAccuracy = kCLLocationAccuracyBest
         locationManager.startUpdatingLocation()
      }
      
      if let dive = newDive {
         self.name = dive.name
         self.location = dive.location
         self.rating = dive.rating
         self.maxDepth = dive.maxDepth
         self.maxDepthUnits = dive.maxDepthUnits
         self.airTemp = dive.airTemp
         self.surfaceTemp = dive.surfaceTemp
         self.bottomTemp = dive.bottomTemp
         self.tempUnits = dive.tempUnits
         self.exposureProtection = dive.exposureProtection ?? []
         self.conditions = dive.conditions ?? []
         self.comments = dive.comments
         self.startBar = dive.startBar
         self.endBar = dive.endBar
         self.timeIn = dive.timeIn
         self.timeOut = dive.timeOut
         self.date = dive.date
         self.visibility = dive.visibility
         self.visibilityUnits = dive.visibilityUnits
         self.weight = dive.weight
         self.weightUnits = dive.weightUnits
         self.diveNumber = dive.diveNumber
         if let latitude = dive.latitude {
            self.clLocation = CLLocationCoordinate2DMake(latitude, dive.longitude!)
         }
         self.updateSaveButtonState()
      }
      
      form
         +++ Section()
         <<< IntRow() {
            $0.title = "Dive Number"
            $0.value = self.diveNumber
            $0.disabled = true
         }
         
         +++ Section()
         <<< TextRow() {
            $0.title = "Dive Site*"
            $0.value = self.name
            }.onChange({ row in
               self.name = row.value
               self.updateSaveButtonState()
               self.updateShareButtonState()
            })
         
         <<< TextRow() {
            $0.title = "Location*"
            $0.value = self.location
            }.onChange({ row in
               self.location = row.value
               self.updateSaveButtonState();
               self.updateShareButtonState()
            })
         <<< DateRow() {
            $0.title = "Date"
            $0.baseValue = Date()
            if let dt = self.date {
               $0.value = dt
            }
            }.onChange({ row in
               self.date = row.value
            })
         <<< SegmentedRow<String>(){
            $0.options = ["⭐","⭐⭐","⭐⭐⭐"]
            $0.value = self.rating
            }.onChange({ row in
               self.rating = row.value
               self.updateSaveButtonState()
            })
         
         +++ Section("Visibility")
         <<< IntRow() {
            $0.placeholder = "Distance"
            $0.value = self.visibility
            }.onChange({ row in
               self.visibility = row.value
            })
         <<< SegmentedRow<String>() {
            $0.options = ["m","ft"]
            $0.baseValue = "m"
            if let vu = self.visibilityUnits {
               $0.value = vu
            }
            }.onChange({ row in
               self.visibilityUnits = row.value
            })
         
         +++ Section("Max Depth")
         <<< IntRow() {
            $0.placeholder = "Distance"
            $0.value = self.maxDepth
            }.onChange({ row in
               self.maxDepth = row.value
            })
         <<< SegmentedRow<String>() {
            $0.options = ["m","ft"]
            $0.baseValue = "m"
            if let du = self.maxDepthUnits {
               $0.value = du
            }
            }.onChange({ row in
               self.maxDepthUnits = row.value
            })
         
         +++ Section("Duration")
         <<< TimeRow() {
            $0.title = "Time In"
            $0.value = self.timeIn
            }.onChange({ row in
               self.timeIn = row.value
            })
         <<< TimeRow() {
            $0.title = "Time Out"
            $0.value = self.timeOut
            }.onChange({ row in
               self.timeOut = row.value
            })
         
         +++ Section("Tank Info")
         <<< IntRow() {
            $0.title = "Start PSI/Bar"
            $0.value = self.startBar
            }.onChange({ row in
               self.startBar = row.value
            })
         <<< IntRow() {
            $0.title = "End PSI/Bar"
            $0.value = self.endBar
            }.onChange({ row in
               self.endBar = row.value
            })
         
         +++ Section("Weight")
         <<< IntRow() {
            $0.title = ""
            $0.placeholder = "Amount"
            $0.value = self.weight
            }.onChange({ row in
               self.weight = row.value
            })
         <<< SegmentedRow<String>() {
            $0.options = ["kg","lbs"]
            $0.baseValue = "kg"
            if let wu = self.weightUnits {
               $0.value = wu
            }
            }.onChange({ row in
               self.weightUnits = row.value
            })
         
         +++ Section("Temperature")
         <<< IntRow() {
            $0.title = "Air"
            $0.placeholder = "Air Temp"
            $0.value = self.airTemp
            }.onChange({ row in
               self.airTemp = row.value
            })
         <<< IntRow() {
            $0.title = "Surface"
            $0.placeholder = "Surface Temp"
            $0.value = self.surfaceTemp
            }.onChange({ row in
               self.surfaceTemp = row.value
            })
         <<< IntRow() {
            $0.title = "Bottom"
            $0.placeholder = "Bottom Temp"
            $0.value = self.bottomTemp
            }.onChange({ row in
               self.bottomTemp = row.value
            })
         <<< SegmentedRow<String>() {
            $0.options = ["Celsius", "Fahrenheit"]
            $0.baseValue = "Celsius"
            if let tu = self.tempUnits {
               $0.value = tu
            }
            }.onChange({ row in
               self.tempUnits = row.value
            })
         
         +++ SelectableSection<ListCheckRow<String>>("Exposure Protection", selectionType: .multipleSelection)
      
      let protection = ["Wetsuit", "Hood", "Gloves", "Boots"]
      for option in protection {
         form.last! <<< ListCheckRow<String>(option){ listRow in
            listRow.title = option
            listRow.selectableValue = option
            listRow.value = ((self.exposureProtection ?? []).contains(option)) ? option : nil
            }.onChange({ row in
               if (row.value == nil) {
                  self.exposureProtection = self.exposureProtection!.filter({ (protection) -> Bool in
                     return protection != option
                  })
               } else {
                  self.exposureProtection!.append(row.value!)
               }
            })
      }
      
      form +++ SelectableSection<ListCheckRow<String>>("Exposure Protection", selectionType: .multipleSelection)
      
      let conditions = ["Fresh", "Salt", "Boat", "Shore", "Pool", "Confined Open Water"]
      for option in conditions {
         form.last! <<< ListCheckRow<String>(option){ listRow in
            listRow.title = option
            listRow.selectableValue = option
            listRow.value = (self.conditions ?? []).contains(option) ? option : nil
            }.onChange({ row in
               if (row.value == nil) {
                  self.conditions = self.conditions!.filter({ (condition) -> Bool in
                     return condition != option
                  })
               } else {
                  self.conditions!.append(row.value!)
               }
            })
      }
      
      form
         +++ Section()
         <<< ButtonRow("setLocationTag") {
            $0.title = "Set Dive Coordinates as Current Location"
            $0.onCellSelection({ (cell, row) in
               self.clLocation = self.locationManager.location?.coordinate
               self.evaluateHiddenCoordsRows()
            })
            $0.hidden = Condition.function(["setLocationTag"], { form in
               return self.clLocation != nil
            })
         }
         <<< TextRow("latitudeRow") {
            $0.title = "Latitude"
            if let lat = self.clLocation?.latitude {
               $0.value = String(describing: lat)
            }
            $0.disabled = true
            $0.hidden = Condition.function(["setLocationTag"], { form in
               return self.clLocation == nil
            })
         }
         <<< TextRow("longitudeRow") {
            $0.title = "Longitude"
            if let long = self.clLocation?.longitude {
               $0.value = String(describing: long)
            }
            $0.disabled = true
            $0.hidden = Condition.function(["setLocationTag"], { form in
               return self.clLocation == nil
            })
         }
         
         <<< ButtonRow("deleteRow") {
            $0.title = "Delete Coordinates"
            $0.hidden = Condition.function(["setLocationTag"], { form in
               return self.clLocation == nil || !self.editable
            })
            $0.onCellSelection({ (cell, row) in
               if(!row.isDisabled) {
                  self.clLocation = nil
                  self.evaluateHiddenCoordsRows()
               }
            })
            }.cellUpdate { cell, row in
               cell.textLabel?.textColor = .red
         }
         
         +++ Section("Comments")
         <<< TextAreaRow() {
            $0.value = self.comments
            }.onChange({ row in
               self.comments = row.value
            })
      
         +++ Section()
         <<< ButtonRow("ShareTag") {
            $0.title = "Share to Facebook"
            $0.disabled = Condition.function(["ShareTag"], { form in
               return (self.name ?? "").isEmpty || (self.location ?? "").isEmpty
            })
            }.onCellSelection({ (cell, row) in
               if (!row.isDisabled) {
                  self.updateDiveObj()
                  let myContent = LinkShareContent(url: URL(string: "http://dive-bohol.com/wp-content/uploads/2015/03/reef2.jpg")!, quote: self.newDive!.toString())
                  let shareDialog = ShareDialog(content: myContent)
                  shareDialog.failsOnInvalidData = true
                  shareDialog.completion = { result in
                     // Handle share results
                  }
                  do {
                     try shareDialog.show()
                  } catch {
                     print("facebook error")
                  }
               }
            })
      
      if !self.editable {
         form.rows.forEach({ (row) in
            if (row.tag != "ShareTag") {
               row.cellStyle = .default
               row.disabled = true;
               row.evaluateDisabled();
               row.reload()
            }
         })
         for row in form.rows {
            if (row.tag != "ShareTag") {
               row.disabled = true;
               row.evaluateDisabled();
            }
         }
      }
   }
   
   private func evaluateHiddenCoordsRows() {
      self.form.rowBy(tag: "latitudeRow")?.value = String(format: "%.3f", (self.clLocation?.latitude) ?? "")
      self.form.rowBy(tag: "longitudeRow")?.value = String(format: "%.3f", (self.clLocation?.longitude) ?? "")
      self.form.rowBy(tag: "latitudeRow")?.evaluateHidden()
      self.form.rowBy(tag: "longitudeRow")?.evaluateHidden()
      self.form.rowBy(tag: "setLocationTag")?.evaluateHidden()
      self.form.rowBy(tag: "deleteRow")?.evaluateHidden()
   }
   
   private func updateSaveButtonState() {
      // Disable the Save button if the text field is empty.
      let defaultedName = self.name ?? ""
      let defaultedLocation = self.location ?? ""
      let defaultedRating = self.rating ?? ""
      if self.editable {
         saveButton.isEnabled = !defaultedName.isEmpty && !defaultedRating.isEmpty && !defaultedLocation.isEmpty
      }
   }
   
   private func updateShareButtonState() {
      self.form.rowBy(tag: "ShareTag")?.evaluateDisabled()
   }
   
   func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
      if(status == CLAuthorizationStatus.denied) {
         showLocationDisabledPopUp()
      }
   }
   
   func showLocationDisabledPopUp() {
      let alertController = UIAlertController(title: "Background Location Access Disabled",
                                              message: "In order to mark your dives on the map we need your location.",
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
   
   
   
   // MARK: - Navigation
   
   @IBAction func cancel(_ sender: UIBarButtonItem) {
      dismiss(animated: true, completion: nil)
      if let owningNavigationController = navigationController {
         owningNavigationController.popViewController(animated: true)
      }
   }
   
   private func updateDiveObj() {
      self.newDive = Dive(name: self.name, location: self.location, rating: self.rating, maxDepth: self.maxDepth, maxDepthUnits: self.maxDepthUnits, airTemp: self.airTemp, surfaceTemp: self.surfaceTemp, bottomTemp: self.bottomTemp, tempUnits: self.tempUnits, exposureProtection: self.exposureProtection, conditions: self.conditions, comments: self.comments, startBar: self.startBar, endBar: self.endBar, timeIn: self.timeIn, timeOut: self.timeOut, date: self.date, visibility: self.visibility, visibilityUnits: self.visibilityUnits, weight: self.weight, weightUnits: self.weightUnits, diveNumber: self.diveNumber, latitude: self.clLocation?.latitude, longitude: self.clLocation?.longitude, timestamp: newDive?.timestamp)
   }
   
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if let button = sender as? UIBarButtonItem, button === saveButton {
         self.updateDiveObj()
      }
   }
   
   
}

//
//  DiveMapViewController.swift
//  Final Dive App
//
//  Created by Thomas Simko on 3/5/18.
//  Copyright © 2018 Thomas Simko. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class DiveMapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
   
   @IBOutlet weak var mapView: MKMapView!
   let locationManager = CLLocationManager()
   var myDives = [Dive]()
   
   override func viewDidLoad() {
      locationManager.requestWhenInUseAuthorization()
      
      if CLLocationManager.locationServicesEnabled() {
         print("enabled")
         locationManager.delegate = self
         locationManager.desiredAccuracy = kCLLocationAccuracyBest
         locationManager.startUpdatingLocation()
      }
      let centerCoord = (locationManager.location?.coordinate) ?? CLLocationCoordinate2D(latitude: 120.6596, longitude: 35.2828)
      let span = MKCoordinateSpan(latitudeDelta: 0.65, longitudeDelta: 0.65)
      let newRegion = MKCoordinateRegion(center: centerCoord, span: span)
      mapView.setRegion(newRegion, animated: true)
   }
   
   override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
      
      if let loadedDives = LocalDiveLoader.loadDives() {
         myDives += loadedDives;
      }
      
      myDives.forEach { (dive) in
         if dive.latitude != nil {
            self.mapView.addAnnotation(dive)
         }
      }
   }
   
   override func viewDidDisappear(_ animated: Bool) {
      self.mapView.removeAnnotations(self.mapView.annotations)
   }
   

   func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
      
      if annotation is Dive {
         let annotationView = MKPinAnnotationView()
         annotationView.pinTintColor = .red
         annotationView.annotation = annotation
         annotationView.canShowCallout = true
         annotationView.animatesDrop = true

         let btn = UIButton(type: .detailDisclosure)
         annotationView.rightCalloutAccessoryView = btn
         return annotationView
      }

      return nil
   }
   
   func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
      if control == view.rightCalloutAccessoryView {
         performSegue(withIdentifier: "diveMapDetailSegue", sender: view)
      }
   }
   
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      
      // Get the new view controller using segue.destinationViewController.
      // Pass the selected object to the new view controller.
      if segue.identifier == "diveMapDetailSegue" {
         let destVC = segue.destination as! NewDiveViewController
         let dive = (sender as! MKAnnotationView).annotation as! Dive
         destVC.newDive = dive
         destVC.editable = false
      }
      
      
   }

   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
   }

}

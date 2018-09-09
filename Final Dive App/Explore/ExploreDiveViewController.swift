//
//  ExploreDiveViewController.swift
//  Final Dive App
//
//  Created by Thomas Simko on 2/28/18.
//  Copyright © 2018 Thomas Simko. All rights reserved.
//

import UIKit

class ExploreDiveViewController: UIViewController {
   
   var diveSite: Site?
   var diveDetailed:DiveSiteDetailWrapper?
   var conditions:WeatherDataWrapper?

   @IBOutlet weak var diveSiteNameLabel: UILabel!
   @IBOutlet weak var ratingLabel: UILabel!
   @IBOutlet weak var minDepthLabel: UILabel!
   @IBOutlet weak var maxDepthLabel: UILabel!
   @IBOutlet weak var descriptionLabel: UILabel!
   @IBOutlet weak var date1Label: UILabel!
   @IBOutlet weak var date2Label: UILabel!
   @IBOutlet weak var date3Label: UILabel!
   @IBOutlet weak var date1Image: UIImageView!
   @IBOutlet weak var date2Image: UIImageView!
   @IBOutlet weak var date3Image: UIImageView!
   @IBOutlet weak var hiLoLabel1: UILabel!
   @IBOutlet weak var hiLoLabel2: UILabel!
   @IBOutlet weak var hiLoLabel3: UILabel!
   @IBOutlet weak var waterTempLabel1: UILabel!
   @IBOutlet weak var waterTempLabel2: UILabel!
   @IBOutlet weak var waterTempLabel3: UILabel!
   @IBOutlet weak var swellLabel1: UILabel!
   @IBOutlet weak var swellLabel2: UILabel!
   @IBOutlet weak var swellLabel3: UILabel!
   
   override func viewDidLoad() {
      super.viewDidLoad()
      self.setLabelsToNil()
      self.diveSiteNameLabel.text = self.diveSite?.name
      let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
      
      let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
      loadingIndicator.hidesWhenStopped = true
      loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
      loadingIndicator.startAnimating();
      
      alert.view.addSubview(loadingIndicator)
      present(alert, animated: true, completion: nil)
      
      
      if let maxDepth = self.diveSite?.maxdepth {
         self.maxDepthLabel.text = "Max Depth: " + maxDepth + " ft"
      } else {
         self.maxDepthLabel.text = "";
      }
      if let minDepth = self.diveSite?.mindepth {
         self.minDepthLabel.text = "Min Depth: " + minDepth + " ft"
      } else {
         self.minDepthLabel.text = "";
      }
      
      if let desc = self.diveSite?.description {
         self.descriptionLabel.text = desc;
      } else {
         self.descriptionLabel.text = "Currently no information to display."
      }
      self.loadDiveDetails()
      self.loadConditions()
   }
   
   private func loadDiveDetails() {
      let diveAPI = "http://api.divesites.com/?mode=detail&siteid="
      let session = URLSession(configuration: URLSessionConfiguration.default)
      let request = URLRequest(url: URL(string: diveAPI + (diveSite?.id)!)!)
      
      let task: URLSessionDataTask = session.dataTask(with: request) { (receivedData, response, error) -> Void in
         
         if let data = receivedData {
            
            do {
               self.diveDetailed = try JSONDecoder().decode(DiveSiteDetailWrapper.self, from: data)
            }
            catch {
               print("Dive Details Exc")
               print("Caught exception \(error)")
               print(diveAPI + (self.diveSite!.id))
               print(data)
            }
            DispatchQueue.main.async {
               self.ratingLabel.text = self.diveDetailed?.site.rating
            }
         }
      }
      task.resume();
   }
   
   private func loadConditions() {
      let latLongString = (self.diveSite?.lat)! + "," + (self.diveSite?.lng)!;
      let conditionsAPI = "http://api.worldweatheronline.com/premium/v1/marine.ashx?key=98ef2bc70d90403f884224907182802&q=" + latLongString + "&format=json&includelocation=yes&tp=24"
      let session = URLSession(configuration: URLSessionConfiguration.default)
      let request = URLRequest(url: URL(string: conditionsAPI)!)
      
      let task: URLSessionDataTask = session.dataTask(with: request) { (receivedData, response, error) -> Void in
         
         if let data = receivedData {
            
            do {
               self.conditions = try JSONDecoder().decode(WeatherDataWrapper.self, from: data)
               DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                  let dateLabels = [self.date1Label, self.date2Label, self.date3Label];
                  let hiLoLabels = [self.hiLoLabel1, self.hiLoLabel2, self.hiLoLabel3];
                  let waterTempLabels = [self.waterTempLabel1, self.waterTempLabel2, self.waterTempLabel3];
                  let swellLabels = [self.swellLabel1, self.swellLabel2, self.swellLabel3];
                  let imageLabels = [self.date1Image, self.date2Image, self.date3Image];
                  for i in 0..<3 {
                     if let day1Weather = self.conditions?.data.weather[i] {
                        dateLabels[i]!.text = String(describing: day1Weather.date.dropFirst(5))
                        hiLoLabels[i]!.text = (day1Weather.maxtempF)! + "/" + (day1Weather.mintempF)!
                        waterTempLabels[i]!.text = (day1Weather.hourly[0].waterTemp_F) + " F"
                        swellLabels[i]!.text = (day1Weather.hourly[0].swellHeight_ft) + " ft " + (day1Weather.hourly[0].swellDir16Point)
                        self.loadImage(url: (day1Weather.hourly[0].weatherIconUrl[0].value), imageLoc: imageLabels[i]!)
                     }
                     
                  }
                  self.dismiss(animated: true, completion: nil)
               }
            }
            catch {
               print("Conditions Exc")
               print("Caught exception \(error)")
               DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                  self.dismiss(animated: true, completion: nil)

                  let alert = UIAlertController(title: "Error", message: "Error loading data from endpoint.", preferredStyle: .alert)
                  
                  alert.addAction(UIAlertAction(title: "Reload", style: .default, handler: {_ in
                     self.viewDidLoad()
                  }))
                  alert.addAction(UIAlertAction(title: "Back", style: .cancel, handler: {_ in
                     self.performSegue(withIdentifier: "unwindToExplore", sender: self)
                  }))
                  
                  self.present(alert, animated: true)
               }
            }
         }
      }
      task.resume();
   }
   
   private func loadImage(url:String, imageLoc:UIImageView) {
      let session = URLSession(configuration: URLSessionConfiguration.default)
      
      let request = URLRequest(url: URL(string: url)!)
      
      let task: URLSessionDataTask = session.dataTask(with: request) { (receivedData, response, error) -> Void in
         
         if let data = receivedData {
            
            let downloadedImage = UIImage(data: data);
            
           DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
               imageLoc.image = downloadedImage;
            }
         }
      }
      task.resume();
   }
   
   private func setLabelsToNil() {
      self.diveSiteNameLabel.text = nil
      self.ratingLabel.text = nil
      self.minDepthLabel.text = nil
      self.maxDepthLabel.text = nil
      self.descriptionLabel.text = nil
      self.date1Label.text = nil
      self.date2Label.text = nil
      self.date3Label.text = nil
      self.hiLoLabel1.text = nil
      self.hiLoLabel2.text = nil
      self.hiLoLabel3.text = nil
      self.waterTempLabel1.text = nil
      self.waterTempLabel2.text = nil
      self.waterTempLabel3.text = nil
      self.swellLabel1.text = nil
      self.swellLabel2.text = nil
      self.swellLabel3.text = nil
   }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

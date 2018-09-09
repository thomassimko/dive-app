//
//  WeatherData.swift
//  Final Dive App
//
//  Created by Thomas Simko on 2/28/18.
//  Copyright © 2018 Thomas Simko. All rights reserved.
//

import Foundation

class WeatherDataWrapper: Codable {
   var data:WeatherData
}
class WeatherData: Codable {
   var weather: [Weather]
}
class Weather: Codable {
   var date: String
   var maxtempF: String?
   var mintempF: String?
   var hourly: [HourlyWeather]
}

class WeatherIcon:Codable {
   var value: String
}

class HourlyWeather: Codable {
   var swellHeight_ft: String
   var swellDir16Point: String
   var waterTemp_F: String
   var weatherIconUrl: [WeatherIcon]
}

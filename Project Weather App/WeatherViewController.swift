//
//  ViewController.swift
//  Project Weather App
//
//  Created by Deyson Bencosme Abreu on 7/30/19.
//  Copyright © 2019 Deyson Bencosme Abreu. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class WeatherViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource, ChangeLocationDelegate {
    
    @IBOutlet weak var currentDateLabel: UILabel!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var currentIconImage: UIImageView!
    @IBOutlet weak var currentCityLabel: UILabel!
    @IBOutlet weak var currentSummaryLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    
    @IBOutlet weak var weatherTableView: UITableView!
    
    let APP_ID = "2541443502b11ba6ded9ea1401533fb5"
    let weatherURL = "https://api.darksky.net/forecast/2541443502b11ba6ded9ea1401533fb5/"

    let locationManager = CLLocationManager()
    let currentData = CurrentWeatherDataModel()
    var hourlyData : [HourlyWeatherDataModel] = [HourlyWeatherDataModel]()
    var dailyData : [DailyWeatherDataModel] = [DailyWeatherDataModel]()
    
    var summary : String = ""
    var lat : String = ""
    var lon : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherTableView.register(UINib(nibName: "CurrentTableCell", bundle: nil), forCellReuseIdentifier: "customCurrentTableCell")
        weatherTableView.register(UINib(nibName: "DailyTableCell", bundle: nil), forCellReuseIdentifier: "customDailyTableCell")
        weatherTableView.register(UINib(nibName: "HourlyTableViewCell", bundle: nil), forCellReuseIdentifier: "customHourlyTableViewCell")

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        configureTableView()
    }
    
    
    //MARK - LOCATION DELEGATES
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            getWeatherData(lat: latitude, lon: longitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    //MARK - WEATHER JSON DATA
    func getWeatherData(lat: String, lon: String) {
        
        var url : String = ""
    
        if UserDefaults.standard.bool(forKey: "FvsC") {
            url = weatherURL + "\(lat),\(lon)"
        } else {
            url = weatherURL + "\(lat),\(lon)?units=ca"
        }
        
        Alamofire.request(url, method: .get, parameters: nil).responseJSON {
            response in
            if response.result.isSuccess {
                print("Succes! Got the weather data")
                let weatherJSON : JSON = JSON(response.result.value!)
                self.updateWeatherData(json: weatherJSON)
            } else {
                print("Error \(response.result.error)")
                print("Connection Issues")
            }
        }
    }
    
    func updateWeatherData(json : JSON) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.long
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "EEEE, MMMM dd, YYYY"
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"
        let hourFormatter = DateFormatter()
        hourFormatter.dateFormat = "ha"
        
        hourlyData.removeAll()
        dailyData.removeAll()
        
        lat = json["latitude"].stringValue
        lon = json["longitude"].stringValue
        summary = json["daily"]["summary"].stringValue
        
        //CURRENT WEATHER JSON
        let currentTimeResult = Date(timeIntervalSince1970: json["currently"]["time"].doubleValue)
        currentData.localDate = dateFormatter.string(from: currentTimeResult)
        currentData.localTime = timeFormatter.string(from: currentTimeResult)
        currentData.temperature = json["currently"]["temperature"].intValue
        currentData.icon = getIconName(icon: json["currently"]["icon"].stringValue)
        currentData.summary = json["currently"]["summary"].stringValue
        currentData.apparentTemperature = json["currently"]["apparentTemperature"].intValue
        currentData.windSpeed = json["currently"]["windSpeed"].intValue
        currentData.humidity = json["currently"]["humidity"].doubleValue
        currentData.pressure = json["currently"]["pressure"].doubleValue
        currentData.uvIndex = json["currently"]["uvIndex"].intValue
        currentData.visibility = json["currently"]["visibility"].intValue
        
        //HOURLY WEATHER JSON
        for item in json["hourly"]["data"].arrayValue {
            let hourlyWeather = HourlyWeatherDataModel()
            
            let hourlyTimeResult = Date(timeIntervalSince1970: item["time"].doubleValue)
            hourlyWeather.time = hourFormatter.string(from: hourlyTimeResult)
            hourlyWeather.icon = getIconName(icon: item["icon"].stringValue)
            hourlyWeather.temperature = item["temperature"].intValue
            
            hourlyData.append(hourlyWeather)
        }
        
        //DAILY WEATHER JSON
        for item in json["daily"]["data"].arrayValue {
            let dailyWeather = DailyWeatherDataModel()
            
            let dailyTimeResult = Date(timeIntervalSince1970: item["time"].doubleValue)
            let sunriseTimeResult = Date(timeIntervalSince1970: item["sunriseTime"].doubleValue)
            let sunsetTimeResult = Date(timeIntervalSince1970: item["sunsetTime"].doubleValue)
            
            dailyWeather.weekday = dayFormatter.string(from: dailyTimeResult)
            dailyWeather.temperatureHigh = item["temperatureMax"].intValue
            dailyWeather.temperatureLow = item["temperatureMin"].intValue
            dailyWeather.sunrise = timeFormatter.string(from: sunriseTimeResult)
            dailyWeather.sunset = timeFormatter.string(from: sunsetTimeResult)
            dailyWeather.summary = item["summary"].stringValue
            dailyWeather.icon = getIconName(icon: item["icon"].stringValue)
            
            dailyData.append(dailyWeather)
        }
        
        let location = CLLocation(latitude: json["latitude"].doubleValue, longitude: json["longitude"].doubleValue)
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
            guard let placem = placemarks?.first else { return }
            self.currentData.city = placem.locality!
            self.currentCityLabel.text = placem.locality
        }
        
        updateUIWithWeatherData()
    }
    
    func updateUIWithWeatherData() {
        currentCityLabel.text = currentData.city
        currentDateLabel.text = currentData.localDate
        currentTimeLabel.text = currentData.localTime
        currentIconImage.image = currentData.icon
        currentSummaryLabel.text = currentData.summary
        currentTempLabel.text = String(currentData.temperature)+"°"
        
        weatherTableView.reloadData()
    }
    
    func getIconName(icon: String) -> UIImage? {
        var image : UIImage? = nil
        switch icon {
        case "clear-day":
            image = UIImage(named: "ClearDay")
        case "clear-night":
            image = UIImage(named: "ClearNight")
        case "rain":
            image = UIImage(named: "Rain")
        case "snow":
            image = UIImage(named: "Snow")
        case "sleet":
            image = UIImage(named: "Sleet")
        case "wind":
            image = UIImage(named: "Wind")
        case "fog":
            image = UIImage(named: "Fog")
        case "cloudy":
            image = UIImage(named: "Cloudy")
        case "partly-cloudy-day":
            image = UIImage(named: "PartlyCloudyDay")
        case "partly-cloudy-night":
            image = UIImage(named: "PartlyCloudyNight")
        default:
            break
        }
        return image
    }
    
    //MARK - TABLE VIEW DELEGATES
    func configureTableView() {
        weatherTableView.rowHeight = UITableView.automaticDimension
        weatherTableView.estimatedRowHeight = 120.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "customCurrentTableCell", for: indexPath) as! CurrentTableCell
            
            if dailyData.isEmpty == false {
                cell.sunriseLabel.text = dailyData[0].sunrise
                cell.sunsetLabel.text = dailyData[0].sunset
            }
            
            if UserDefaults.standard.bool(forKey: "FvsC") {
                cell.windLabel.text = "\(currentData.windSpeed) MPH"
                cell.pressureLabel.text = "\(currentData.pressure) mb"
                cell.visibilityLabel.text = "\(currentData.visibility) mi"
            } else {
                cell.windLabel.text = "\(currentData.windSpeed) km/h"
                cell.pressureLabel.text = "\(currentData.pressure) hPa"
                cell.visibilityLabel.text = "\(currentData.visibility) km"
            }
            
            cell.feelsLikeLabel.text = "\(currentData.apparentTemperature)°"
            cell.humidityLabel.text = "\(Int(currentData.humidity * 100))%"
            cell.uvIndexLabel.text = String(currentData.uvIndex)

            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "customHourlyTableViewCell", for: indexPath) as! HourlyTableViewCell
            cell.data = hourlyData
            cell.hourlyCollectionView.reloadData()
            return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WeekSummaryCell", for: indexPath) as! WeekSummaryCell
            cell.summaryLabel.text = summary
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "customDailyTableCell", for: indexPath) as! DailyTableCell
            if dailyData.count > 0 {
                cell.weekdayLabel.text = dailyData[indexPath.row - 2].weekday
                cell.iconImage.image = dailyData[indexPath.row - 2].icon
                cell.tempHighLabel.text  = "\(dailyData[indexPath.row - 2].temperatureHigh)°"
                cell.tempLowLabel.text  = "\(dailyData[indexPath.row - 2].temperatureLow)°"
                cell.sunriseLabel.text = dailyData[indexPath.row - 2].sunrise
                cell.sunsetLabel.text = dailyData[indexPath.row - 2].sunset
                cell.summaryLabel.text = dailyData[indexPath.row - 2].summary
            }
            return cell
        }
    }
    

    @IBAction func CelsiusOrFahrenheitPressed(_ sender: UIBarButtonItem) {
        if UserDefaults.standard.bool(forKey: "FvsC") == true {
            UserDefaults.standard.set(false, forKey: "FvsC")
        } else {
            UserDefaults.standard.set(true, forKey: "FvsC")
        }
        getWeatherData(lat: lat, lon: lon)
    }
    

    @IBAction func changeLocationPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "goToChangeLocation", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToChangeLocation" {
            let destinationVC = segue.destination as! SearchViewController
            destinationVC.delegate = self
        }
    }
    
    func location(latitude: String, longitude: String) {
        getWeatherData(lat: latitude, lon: longitude)
    }
    
}



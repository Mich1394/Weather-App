//
//  CurrentWeatherDataModel.swift
//  Project Weather App
//
//  Created by Deyson Bencosme Abreu on 7/30/19.
//  Copyright © 2019 Deyson Bencosme Abreu. All rights reserved.
//

import UIKit

class CurrentWeatherDataModel {
    var city : String = ""
    var localDate : String = ""
    var localTime : String = ""
    var icon : UIImage? = nil
    var temperature : Int = 0
    var summary : String = ""
    
    var apparentTemperature : Int = 0
    var windSpeed : Int = 0
    var pressure : Double = 0
    var humidity : Double = 0
    var uvIndex : Int = 0
    var visibility : Int = 0
}

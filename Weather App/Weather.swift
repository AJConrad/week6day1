//
//  Weather.swift
//  Weather App
//
//  Created by Andrew Conrad on 5/16/16.
//  Copyright © 2016 AndrewConrad. All rights reserved.
//

import UIKit

class Weather: NSObject {
    
    var locationStreetAddress       :String!
    var locationCityAddress         :String!
    var locationStateAddress        :String!
    var locationLatitude            :String!
    var locationLongitude           :String!
    var coords                      :String!
    
    var currentTemperature          :Double!
    var currentCondition            :String!
    var currentIcon                 :String!
    //TO ADD: Humidity, Wind Speed, precip intensity (which is measured in inches/hour)

}

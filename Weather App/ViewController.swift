//
//  ViewController.swift
//  Weather App
//
//  Created by Andrew Conrad on 5/16/16.
//  Copyright © 2016 AndrewConrad. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    let dataManager = DataManager.sharedInstance
    let networkManager = NetworkManager.sharedInstance
    
    @IBOutlet private weak var      searchTextField     :UITextField!
    @IBOutlet private weak var      summaryLabel        :UILabel!
    @IBOutlet private weak var      tempLabel           :UILabel!
    @IBOutlet private weak var      locationLabel       :UILabel!
    @IBOutlet private weak var      iconImageView       :UIImageView!
    
    @IBAction func goButtonPressed(button: UIButton) {
        
        if networkManager.serverAvailable {
            dataManager.currentWeather = Weather()
            dataManager.currentWeather.locationStreetAddress = searchTextField.text
            //            dataManager.currentWeather.locationCityAddress = cityTextField.text
            //            dataManager.currentWeather.locationStateAddress = stateTextField.text
            if let address = searchTextField.text {
                dataManager.geoCoder(address)
            } else {
                print("Search Empty")
            }
        }
    }
    
    func fillDataOut() {
        summaryLabel.text = dataManager.currentWeather.currentCondition
        tempLabel.text = String(dataManager.currentWeather.currentTemperature)
        locationLabel.text = dataManager.currentWeather.coords
//        switch dataManager.currentWeather.currentIcon {
//        case "clear-day":
//            iconImageView.image = clear-day
//        case "cloudy":
//            iconImageView.image = cloudy
//        case  "partly-cloudy-day":
//            iconImageView.image = partly-cloudy-day
//        case "rain":
//            iconImageView.image = rain
//        default:
//            iconImageView.image = question
//        }
        
    }
    
    func newDataRecv() {
        fillDataOut()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(newDataRecv), name: "recvNewDataFromServer", object: nil)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }


}


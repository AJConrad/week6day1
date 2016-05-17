//
//  DataManager.swift
//  Weather App
//
//  Created by Andrew Conrad on 5/16/16.
//  Copyright © 2016 AndrewConrad. All rights reserved.
//

import UIKit
import CoreLocation

class DataManager: NSObject {
    
    static let sharedInstance = DataManager()
    
    var baseURL = "api.forecast.io"
    var locationURL = "42,-83"
//    var weatherArray = [Weather]()
    var currentWeather = Weather()
    
    func geoCoder(addressString: String) {
        let geocoder = CLGeocoder()
        geocoder .geocodeAddressString("\(addressString)") { (placemarks, error) in
            if let placemark = placemarks?[0] {
                guard let addressDict = placemark.addressDictionary else {
                    return
                }
                guard let city = addressDict["City"] else {
                    return
                }
                guard let street = addressDict["Street"] else {
                    return
                }
                guard let state =  addressDict["State"] else {
                    return
                }
                guard let loc = placemark.location else {
                    return
                }
                self.currentWeather = Weather()
                print("Street: \(street) City: \(city) State: \(state) Lat:\(loc.coordinate.latitude) \(loc.coordinate.longitude)")
                self.currentWeather.locationLatitude = String(loc.coordinate.latitude)
                self.currentWeather.locationLongitude = String(loc.coordinate.longitude)
                //Maybe i have to store these as doubles
                
                let coordinates = "\(self.currentWeather.locationLatitude),\(self.currentWeather.locationLongitude)"
                self.currentWeather.coords = coordinates
                print("\(coordinates)")
                
                self.getDataFromServer(coordinates)
            }
        }
    }
    
    func getDataFromServer(coordinates: String) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        defer {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
        let url = NSURL(string: "https://\(baseURL)/forecast/98301be5028900452f8dfd2b5be861e1/\(coordinates)")
        print("\(url)")
        let urlRequest = NSURLRequest(URL: url!, cachePolicy: .ReloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 30.0)
        let urlSession = NSURLSession.sharedSession()
        let task = urlSession.dataTaskWithRequest(urlRequest) { (data, response, error) in
            guard let unwrappedData = data else {
                print ("No Data Error")
                return
            }
            do {
                let jsonResult = try NSJSONSerialization.JSONObjectWithData(unwrappedData, options: .MutableContainers)
               // print("JSON: \(jsonResult)")
                let tempWeatherDict = jsonResult.objectForKey("currently") as! NSDictionary
//                self.weatherArray.removeAll()

                self.currentWeather.currentCondition = tempWeatherDict.objectForKey("summary") as! String
                self.currentWeather.currentTemperature = tempWeatherDict.objectForKey("temperature") as! Double
                self.currentWeather.currentIcon = tempWeatherDict.objectForKey("icon") as! String
//                self.weatherArray.append(newWeather)
                dispatch_async(dispatch_get_main_queue(), {
                    NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "recvNewDataFromServer", object: nil))
                })
//                print("Got \(self.weatherArray.count)")
                
                //
                //
                //THESE 4 COMMENTS ARE FOR IF I NEED TO RE-INPUT THE ARRAY
                //
                //
                
            } catch {
                print("JSON Parsing Error")
            }
        }
        task.resume()
    }
    
//    func fileIsInDocuments(filename: String) -> Bool {
//        let fileManager = NSFileManager.defaultManager()
//        return fileManager.fileExistsAtPath(getDocumentPathForFile(filename))
//        
//    }
//    
//    func getDocumentPathForFile(filename: String) -> String {
//        let documentPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
//        return documentPath.stringByAppendingPathComponent(filename)
//    }
//    
//    private func getImageFromServer(localFilename: String, remoteFilename: String) {
//        let remoteURL = NSURL(string: remoteFilename)
//        let imageData = NSData(contentsOfURL: remoteURL!)
//        let imageTemp = UIImage(data: imageData!)
//        if let _ = imageTemp {
//            imageData!.writeToFile(getDocumentPathForFile(localFilename), atomically: false)
//        }
//    }
    
}

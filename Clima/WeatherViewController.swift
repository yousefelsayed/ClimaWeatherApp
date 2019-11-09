//
//  ViewController.swift
//  WeatherApp
//
//  Created by Angela Yu on 23/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON
class WeatherViewController: UIViewController , CLLocationManagerDelegate , changeCityDelegate{
    
    //Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "27a31d09a42fa87bb0d6cfe4321c4833"
    let locationManager = CLLocationManager()

    //TODO: Declare instance variables here
    var weatherDataModel = WeatherDataModel()

    
    //Pre-linked IBOutlets
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //TODO:Set up the location manager here.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
       
        
    }
    
    
    
    //MARK: - Networking
    /***************************************************************/
    
    //Write the getWeatherData method here:
    

    func getWeatherData(url:String , paramters:[String:String])
    {
        Alamofire.request(url, method: .get, parameters: paramters).responseJSON { (response) in
            if response.result.isSuccess
            {
                print("Success! Got the weather data")
                let weatherData : JSON = JSON(response.result.value!)
                self.updateWeatherData(json: weatherData)
                
            }
            else
            {
                print("error \(String(describing: response.result.error))");
                self.cityLabel.text = "connection faliure"
            }
        }
        
    }
    
    
    
    
    //MARK: - JSON Parsing
    /***************************************************************/
   
    
    //Write the updateWeatherData method here:
    func  updateWeatherData(json : JSON)
   {
  if  let tempResult = json["main"]["temp"].double
  { weatherDataModel.temperature = Int(tempResult - 273.15)
    weatherDataModel.cityName = json["name"].stringValue
    weatherDataModel.condtion = json["weather"][0]["id"].intValue
weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condtion)
    cityLabel.text = weatherDataModel.cityName
updateUIWithWeatherData()
    }

    else
  {
    cityLabel.text = "Weather Unavailable!"
    }
    }
    
    //MARK: - UI Updates
    /***************************************************************/
    
    
    //Write the updateUIWithWeatherData method here:
    
    func updateUIWithWeatherData()
    {
        cityLabel.text = weatherDataModel.cityName
        temperatureLabel.text = "\(weatherDataModel.temperature)°"
        weatherIcon.image = UIImage(named: weatherDataModel.weatherIconName)
    }
    
    
    
    
    //MARK: - Location Manager Delegate Methods
    /***************************************************************/
    
    
    //Write the didUpdateLocations method here:
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if(location.horizontalAccuracy > 0)
        {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            // print("lognitude= \(location.coordinate.longitude) latitude= \(location.coordinate.latitude)")
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            let params : [String : String] = [ "lat" :latitude ,"lon" : longitude , "appid" :APP_ID]
           getWeatherData(url: WEATHER_URL, paramters: params)
        }
       
        
    }
    
    
    //Write the didFailWithError method here:
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print (error)
        cityLabel.text = "location is not available"
    }
    

    
    //MARK: - Change City Delegate methods
    /***************************************************************/
    
    func userEnteredANewCityName(city: String) {
        print(city)
        let parms : [String : String ] = ["q" : city ,"appid" : APP_ID ]
        getWeatherData(url: WEATHER_URL, paramters : parms)
    }
    //Write the userEnteredANewCityName Delegate method here:
    

    
    //Write the PrepareForSegue Method here
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "changeCityName"
        {
            let destinationVc = segue.destination as! ChangeCityViewController
            destinationVc.delegate = self
            
            
        }
        
    
    
    
    
    
}

}

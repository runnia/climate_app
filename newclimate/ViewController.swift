//
//  ViewController.swift
//  newclimate
//
//  Created by Ксения on 08.05.2020.
//  Copyright © 2020 Амельченкова Ксения. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON
import Weekday


class ViewController: UIViewController, CLLocationManagerDelegate, ChangeCityDelegate {

    @IBOutlet weak var weatherImage: UIImageView!
    @IBAction func changeCityButton(_ sender: Any) {
    }
    @IBOutlet weak var thirdDayImage: UIImageView!
    @IBOutlet weak var secondDayImage: UIImageView!
    @IBOutlet weak var firstDayImage: UIImageView!
    @IBOutlet weak var thirdDayTempLabel: UILabel!
    @IBOutlet weak var secondDayTempLabel: UILabel!
    @IBOutlet weak var firstDayTempLabel: UILabel!
    @IBOutlet weak var thirdDayLabel: UILabel!
    @IBOutlet weak var secondDayLabel: UILabel!
    @IBOutlet weak var firstDayLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    
    let WEATHER_URL1 = "http://api.openweathermap.org/data/2.5/weather"
    let WEATHER_URL2 = "http://api.openweathermap.org/data/2.5/forecast"
    let APP_ID = "f2fc2a72103f429036af523a6fe6408b"
    
    let locationManager = CLLocationManager()
    let weatherDataModel = WeatherDataModel()
    
    let today = Weekday.current
    let date = Date()
//    let myCalendar = Calendar(identifier: .gregorian)


   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dayOfWeek()
        locationManager.delegate = self
        // выбираем точность определения координат устройства
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        // запрашиваем разрешения пользователя на доступ к геолокации
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func hour() -> Int
    {
        //Get Hour
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.hour], from: Date())
        let hour = components.hour!

        //Return Hour
        return hour
    }
    
    func dayOfWeek(){
        print(today.next.next)
        firstDayLabel.text = today.next.localizedName
        secondDayLabel.text = today.next.next.localizedName
        thirdDayLabel.text = today.next.next.next.localizedName
        
        let format = DateFormatter()
        format.dateFormat = "HH"
        let hour = Int(format.string(from: date))
        print(hour!)
        if ((hour! > 19) || (hour! < 5)) {
            backgroundImageView.image = UIImage(named:"nightbackground")
        }
    }
    // получение данных о текущей погоде с помощью api
        func getWeatherData(url : String, parameters : [String : String]){
            Alamofire.request(url, method: .get, parameters: parameters).responseJSON{
                response in
                if response.result.isSuccess{
                    print("Success")
                    let weatherJSON : JSON = JSON(response.result.value!)
                    print (weatherJSON)
                    self.updateCurrentWeatherData(json: weatherJSON)
                }
                else{
                    print("Error \(response.result.error)")
                    self.cityLabel.text = "Connection issues"
                    self.tempLabel.text = " "
                }
        }
    }
    // получение данных о будущей погоде с помощью api
        func getFutureWeatherData(url : String, parameters : [String : String]){
            Alamofire.request(url, method: .get, parameters: parameters).responseJSON{
                response in
                if response.result.isSuccess{
                    print("Success")
                    let weatherJSON : JSON = JSON(response.result.value!)
                    print (weatherJSON)
                    self.updateFutureWeatherData(json: weatherJSON)
                }
                else{
                    print("Error \(response.result.error)")
                    self.cityLabel.text = "Connection issues"
                    self.tempLabel.text = " "
                }
        }
    }
        
          func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
                let location = locations[locations.count - 1] // последнее значение массива координат самое точное
            // проверка валидности значений геолокации
                if location.horizontalAccuracy > 0 {
                    locationManager.stopUpdatingLocation()
                    locationManager.delegate = nil
                    let latitude = String(location.coordinate.latitude)
                    let longitude = String(location.coordinate.longitude)
                    // параметры для работы с api
                    let params : [String : String] = ["lat" : latitude, "lon" : longitude, "appid" : APP_ID, "units" : "metric"]
                    
                    getWeatherData(url : WEATHER_URL1, parameters : params)
                    getFutureWeatherData(url : WEATHER_URL2, parameters : params)
                }
            }
            
            
            func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
                print(error)
                cityLabel.text = "Location unavailable"
                tempLabel.text = " "
            }
    
            func updateCurrentWeatherData(json : JSON){
                // условие проверяет то что возвращена правильная JSON строка
                if let tempResult = json["main"]["temp"].double {
                
                weatherDataModel.temperature = Int(tempResult)
                weatherDataModel.city = json["name"].stringValue
                weatherDataModel.condition = json["weather"][0]["id"].intValue
                weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
                updateCurrentUIWithWeatherData()
                
                }
                else {
                    cityLabel.text = "Weather unavailable"
                    tempLabel.text = " "
                    weatherImage.image = UIImage(named: "")
                }
            }
            
            func updateFutureWeatherData(json : JSON){
                weatherDataModel.firstTemp = json["list"][6]["main"]["temp"].intValue
                weatherDataModel.secondTemp = json["list"][14]["main"]["temp"].intValue
                weatherDataModel.thirdTemp = json["list"][22]["main"]["temp"].intValue
                weatherDataModel.firstCondition = json["list"][6]["weather"][0]["id"].intValue
                weatherDataModel.secondCondition = json["list"][14]["weather"][0]["id"].intValue
                weatherDataModel.thirdCondition = json["list"][22]["weather"][0]["id"].intValue
                print(weatherDataModel.firstCondition)
                print(weatherDataModel.secondCondition)
                print(weatherDataModel.thirdCondition)
                weatherDataModel.firstWeatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.firstCondition)
                weatherDataModel.secondWeatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.secondCondition)
                weatherDataModel.thirdWeatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.thirdCondition)
                print(weatherDataModel.firstWeatherIconName)
                print(weatherDataModel.secondWeatherIconName)
                print(weatherDataModel.thirdWeatherIconName)
                updateFutureUIWithWeatherData()
            }
            func updateCurrentUIWithWeatherData() {
                if weatherDataModel.city == "Novyye Mesta" {
                    cityLabel.text = "Peterhof"
                }
                else {
                    cityLabel.text = weatherDataModel.city
                }
                tempLabel.text = "\(weatherDataModel.temperature)°"
                weatherImage.image = UIImage(named: weatherDataModel.weatherIconName)
            }
            func updateFutureUIWithWeatherData() {
                firstDayTempLabel.text = "\(weatherDataModel.firstTemp)°"
                secondDayTempLabel.text = "\(weatherDataModel.secondTemp)°"
                thirdDayTempLabel.text = "\(weatherDataModel.thirdTemp)°"
                firstDayImage.image = UIImage(named: weatherDataModel.firstWeatherIconName)
                secondDayImage.image = UIImage(named: weatherDataModel.secondWeatherIconName)
                thirdDayImage.image = UIImage(named: weatherDataModel.thirdWeatherIconName)
            }
    
            func userEnteredNewCityName(city: String) {
                let params : [String:String] = ["q" : city, "appid" : APP_ID, "units" : "metric"]
                getWeatherData(url : WEATHER_URL1, parameters : params)
                getFutureWeatherData(url : WEATHER_URL2, parameters : params)
            }
    
            override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                   if segue.identifier == "changeCityName"{
                       let destinationVC = segue.destination as! SecondViewController
                       destinationVC.delegate = self
                    
                   }
               }

}


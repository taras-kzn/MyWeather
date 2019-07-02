//
//  WeatherService.swift
//  MyWeather
//
//  Created by admin on 01/07/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation
import Alamofire
import RealmSwift

class WeatherService{
    let baseUrl = "http://api.openweathermap.org"
    let apiKey = "92cabe9523da26194b02974bfcd50b7e"
    
    func loadWeatherData(city: String, completion: @escaping () -> Void ){
        
        let path = "/data/2.5/weather"
        
        let parametrs: Parameters = [
            "q" : city,
            "units" : "metric",
            "appid" : apiKey,
            "lang" : "ru"
        ]
        
        let url = baseUrl+path
        
        Alamofire.request(url, method: .get, parameters: parametrs).responseData { [weak self] response in
            guard let data = response.value else {return}

            let weather = try! JSONDecoder().decode(WeatherResponse.self,from: data)
            weather.nameCity = city
            self?.saveWeatherData([weather], idCity: weather.idCity, nameCity: weather.nameCity)
            completion()
        }
    }
    func saveWeatherData(_ weather: [WeatherResponse], idCity: Double, nameCity: String){
 
        do {
            let realm = try Realm()
            let oldWeayhers = realm.objects(WeatherResponse.self).filter("nameCity == %@", nameCity)
            realm.beginWrite()
            realm.delete(oldWeayhers)
            realm.add(weather)
            try realm.commitWrite()
            print(realm.configuration.fileURL)
            
            
            
        } catch  {
            print(error)
        }
        
        
    }
}
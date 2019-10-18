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

final class WeatherService{
    
    private let baseUrl = "http://api.openweathermap.org"
    private let apiKey = "92cabe9523da26194b02974bfcd50b7e"
    
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

            guard let weather = try? JSONDecoder().decode(WeatherResponse.self,from: data) else {return}
            
            self?.saveWeatherData([weather], idCity: weather.idCity, nameCity: weather.nameCity)
            completion()
        }
    }
    
    private func saveWeatherData(_ weather: [WeatherResponse], idCity: Double, nameCity: String){
 
        do {
            let realm = try Realm()
            let oldWeayhers = realm.objects(WeatherResponse.self).filter("idCity == %@", idCity)
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

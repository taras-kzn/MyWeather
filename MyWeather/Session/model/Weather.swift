//
//  Weather.swift
//  MyWeather
//
//  Created by admin on 01/07/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift


final class WeatherResponse: Object, Decodable {
    //MARK: - Properties
    @objc dynamic var nameCity = ""
    @objc dynamic var nameWeather = ""
    @objc dynamic var speed = 0.0
    @objc dynamic var temp = 0.0
    @objc dynamic var deg = 0.0
    @objc dynamic var idCity = 0.0
    //MARK: - Private enums
    private enum CodingKeys: String,CodingKey{
        case weather
        case main
        case wind
        case id
        case name
    }
    
    enum WetherKeys: String,CodingKey {
        case description
    }
    enum MainKeys: String,CodingKey {
        case temp
    }
    enum WindKeys: String, CodingKey {
        case speed
        case deg
    }
    //MARK: - Init
    convenience required init(from decoder: Decoder) throws {
        self.init()
        
        let values = try? decoder.container(keyedBy: CodingKeys.self)
        var weathervalues = try values?.nestedUnkeyedContainer(forKey: .weather)
        let firstWeather = try weathervalues?.nestedContainer(keyedBy: WetherKeys.self)
        self.nameWeather = try firstWeather?.decode(String.self, forKey: .description) ?? ""
        let mainsValue = try? values?.nestedContainer(keyedBy: MainKeys.self, forKey: .main)
        self.temp = try mainsValue?.decode(Double.self, forKey: .temp) ?? 0.0
        let windValues = try? values?.nestedContainer(keyedBy: WindKeys.self, forKey: .wind)
        self.speed = try windValues?.decode(Double.self, forKey: .speed) ?? 0.0
        self.deg = try windValues?.decode(Double.self, forKey: .deg) ?? 0.0
        self.idCity = try values?.decode(Double.self, forKey: .id) ?? 0.0
        self.nameCity = try values?.decode(String.self, forKey: .name) ?? ""
    }
}



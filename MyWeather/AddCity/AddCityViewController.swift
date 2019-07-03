//
//  AddCityViewController.swift
//  MyWeather
//
//  Created by admin on 01/07/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import RealmSwift



protocol AddCityProtocol {
    func cityAdd()
}

final class AddCityViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var cityLabel: UITextField!
    private let weatherService = WeatherService()
    
    var addCityDelegate: AddCityProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        cityLabel.delegate = self

        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil) { (nc) in
            self.view.frame.origin.y = -200
        }
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil) { (nc) in
            self.view.frame.origin.y = 0.0
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == cityLabel {
            cityLabel.resignFirstResponder()
        }
        return true
    }

    @IBAction func addCityBut(_ sender: UIButton) {
        
        guard let cityName = cityLabel.text, !cityName.isEmpty else {
            return
        }
        
        weatherService.loadWeatherData(city: cityName) { [weak self] in
            self?.addCityDelegate?.cityAdd()
        }
    }
    
}

//
//  WeatherCell.swift
//  MyWeather
//
//  Created by admin on 30/06/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class WeatherCell: UITableViewCell {
    
    
    @IBOutlet weak var cityLabel: UILabel!
    
    static let weatherCellId = "WeatherCell"

    @IBOutlet weak var directionLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

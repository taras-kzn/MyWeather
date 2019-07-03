//
//  WeatherCell.swift
//  MyWeather
//
//  Created by admin on 30/06/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

final class WeatherCell: UITableViewCell {
    
    static let weatherCellId = "WeatherCell"
    
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var directionLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

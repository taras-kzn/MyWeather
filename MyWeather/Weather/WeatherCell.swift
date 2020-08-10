//
//  WeatherCell.swift
//  MyWeather
//
//  Created by admin on 30/06/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

final class WeatherCell: UITableViewCell {
    //MARK: - IBOutlet
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var directionLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    //MARK: - lifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension WeatherCell {
    static var weatherCellId: String {
        return String(describing: "WeatherCell")
    }
}

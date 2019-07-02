//
//  WeatherViewController.swift
//  MyWeather
//
//  Created by admin on 30/06/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import RealmSwift

class WeatherViewController: UIViewController {
    


    
    let weatherService = WeatherService()
    var weather = [WeatherResponse]()
    var token: NotificationToken?

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "WeatherCell", bundle: nil), forCellReuseIdentifier: WeatherCell.weatherCellId )
        loadData()
        tableView.reloadData()

        
//        weatherService.loadWeatherData(city: "Москва") { [weak self] in
////            self?.weather = weathers
////            self?.tableView.reloadData()
//            self?.loadData()
//            self?.tableView.reloadData()
//        }



    }
   

    func loadData() {

        do {
            let realm = try Realm()
            
            let weathers = realm.objects(WeatherResponse.self)
            
            self.weather = Array(weathers)
            token = weathers.observe { [weak self] changes in
                switch changes {

                case .initial:
                    self?.tableView.reloadData()
                case .update(_, let deletions, let insertions, let modifications):
                    self?.tableView.beginUpdates()
                    self?.tableView.performBatchUpdates({self?.tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section:0 )}),with: .automatic)
                    self?.tableView.deleteRows(at: deletions.map({ IndexPath(row:$0, section: 0 )}),with: .automatic)
                    self?.tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0 )}),with: .automatic)
                        print(deletions,modifications,insertions)

                    }, completion: {_ in
                        print("update")
                    })
                    self?.tableView.endUpdates()
                case .error(let error):
                    print(error)
                }
                print("изминения прошли")

            }
            
        }catch{
            print("error")
            
        }

    }
}
extension WeatherViewController: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weather.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WeatherCell.weatherCellId, for: indexPath) as! WeatherCell
        let arr = weather[indexPath.row]
        cell.cityLabel.text = arr.nameCity
        cell.speedLabel.text = "\(arr.speed) M/C"
        windDir(wind: arr.deg, cell: cell.directionLabel)

        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350
        
    }
    func windDir(wind: Double,cell: UILabel){
        if wind > 337.5 && wind < 22.5{
            cell.text = "Север"
        }else if wind > 22.5 && wind < 75 {
            cell.text = "Север-Восток"
        }else if wind > 75 && wind < 112.5 {
            cell.text = "Восток"
        } else if wind > 112.5 && wind < 157 {
            cell.text = "Юго-Восток"
        } else if wind > 157 && wind < 202.5 {
            cell.text = "Юг"
        } else if wind > 202.5 && wind < 247.5 {
            cell.text = "Юго-Запад"
        } else if wind > 247.5 && wind < 292.5{
            cell.text = "Запад"
        } else if wind > 292.5 && wind < 337.5{
            cell.text = "Суверо-Запад"
        }
        
    }
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        let city = weather[indexPath.row]
//        if editingStyle == .delete {
//            do {
//                let realm = try Realm()
//                realm.beginWrite()
//               // realm.delete(city.idCity)
//                realm.delete(city)
//                try realm.commitWrite()
//            } catch {
//                print(error)
//                
//            }
//        }
//    }
    

    
}

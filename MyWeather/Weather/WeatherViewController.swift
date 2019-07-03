//
//  WeatherViewController.swift
//  MyWeather
//
//  Created by admin on 30/06/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import RealmSwift


final class WeatherViewController: UIViewController {
    
    private var weather = [WeatherResponse]() {
        willSet{
           tableView.reloadData()
        }
    }
    
    var token: NotificationToken?

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "WeatherCell", bundle: nil), forCellReuseIdentifier: WeatherCell.weatherCellId )
        loadData()
        tableView.reloadData()
    }

    private func loadData() {
        do {
            let realm = try Realm()
            let weathers = realm.objects(WeatherResponse.self).sorted(byKeyPath: "nameCity")
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
                case .error(let error):
                    print(error)
                }
                print("изминения прошли")
                
            }
        }catch{
            print("error")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addCity" {
            let destinViewController = segue.destination as? AddCityViewController
            destinViewController?.addCityDelegate = self
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

        func doubleToInteger(data:Double)-> Int {
            let doubleToString = "\(data)"
            let stringToInteger = (doubleToString as NSString).integerValue
            
            return stringToInteger
        }
        cell.cityLabel.text = arr.nameCity
        cell.speedLabel.text = String(arr.temp )
        cell.windLabel.text = arr.nameWeather
        cell.tempLabel.text = "\(doubleToInteger(data: arr.temp)) C"
        windDir(wind: arr.deg, cell: cell.directionLabel)

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350
    }
    
    private func windDir(wind: Double,cell: UILabel){
        
        switch wind {
        case 0..<22.5:
            cell.text = "Север"
        case 22.5..<75:
            cell.text = "Север-Восток"
        case 75..<112.5:
            cell.text = "Восток"
        case 112.5..<157:
            cell.text = "Юго-Восток"
        case 157..<202.5:
            cell.text = "Юг"
        case 202.5..<247.5:
            cell.text = "Юго-Запад"
        case 247.5..<292.5:
            cell.text = "Запад"
        case 292.5..<337.5:
            cell.text = "Северо-Запад"
        case 337.5..<360:
            cell.text = "Север"
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let city = weather[indexPath.row]
        let id = city.idCity
        if editingStyle == .delete {
            do {
                let realm = try Realm()
                let del = realm.objects(WeatherResponse.self).filter("idCity == %@", id)
                realm.beginWrite()
                realm.delete(del)
                try realm.commitWrite()
            } catch {
                print(error)
                
            }
            loadData()
            self.tableView.reloadData()
        }
    }
}

extension WeatherViewController: AddCityProtocol {
    
    func cityAdd() {
        loadData()
    }
}

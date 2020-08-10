//
//  WeatherViewController.swift
//  MyWeather
//
//  Created by admin on 30/06/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import RealmSwift


enum WindDirection: String {
    case north = "Север"
    case northeast = "Север-Восток"
    case east = "Восток"
    case southeast = "Юго-Восток"
    case south = "Юг"
    case southwest = "Юго-Запад"
    case west = "Запад"
    case northwest = "Северо-Запад"
}

final class WeatherViewController: UIViewController {
    //MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!
    //MARK: - Properties
    private let getService = WeatherService()
    var token: NotificationToken?
    private let tableNibName = "WeatherCell"
    private var weather = [WeatherResponse]() {
        willSet{
           tableView.reloadData()
        }
    }
    var myFreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(sender:index:)), for: .valueChanged)
        return refreshControl
    }()
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.refreshControl = myFreshControl
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: tableNibName, bundle: nil), forCellReuseIdentifier: WeatherCell.weatherCellId )
        loadData()
        tableView.reloadData()
    }
    //MARK: - Functions
    @objc func refresh(sender: UIRefreshControl,index: IndexPath){
        getService.loadWeatherData(city: "Москва") { [weak self] in
            self?.loadData()
            self?.tableView.reloadData()
        }
            sender.endRefreshing()
    }

    func loadData() {
        do {
            let realm = try Realm()
            let nameByKeyPath = "nameCity"
            let weathers = realm.objects(WeatherResponse.self).sorted(byKeyPath: nameByKeyPath)
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
                    print(error.localizedDescription)
                }
                print("изминения прошли")
            }
        }catch{
            print("error")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let identifier = "addCity"
        if segue.identifier == identifier {
            let destinViewController = segue.destination as? AddCityViewController
            destinViewController?.addCityDelegate = self
        }
    }
}
//MARK: - TableViewDataSource, TableViewDelegate
extension WeatherViewController: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weather.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCell(withIdentifier: WeatherCell.weatherCellId, for: indexPath) as? WeatherCell
        guard let cell = tableCell else {
            return UITableViewCell()
        }
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
            cell.text = WindDirection.north.rawValue
        case 22.5..<75:
            cell.text = WindDirection.northeast.rawValue
        case 75..<112.5:
            cell.text = WindDirection.east.rawValue
        case 112.5..<157:
            cell.text = WindDirection.southeast.rawValue
        case 157..<202.5:
            cell.text = WindDirection.south.rawValue
        case 202.5..<247.5:
            cell.text = WindDirection.southwest.rawValue
        case 247.5..<292.5:
            cell.text = WindDirection.west.rawValue
        case 292.5..<337.5:
            cell.text = WindDirection.northwest.rawValue
        case 337.5..<360:
            cell.text = WindDirection.north.rawValue
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
//MARK: - extension AddCityProtocol
extension WeatherViewController: AddCityProtocol {
    func cityAdd() {
        loadData()
    }
}

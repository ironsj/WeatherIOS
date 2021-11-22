//
//  ViewController.swift
//  Weather
//
//  Created by Jacob C. Irons on 9/18/21.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate{
    
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherDesciptionLabel: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    
    let key: String = valueForAPIKey(keyName: "USER_WEATHER_KEY")
    
    let locationManager = CLLocationManager()
    
    var coordinates: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setUpLocation()
    }
    
    //location
    func setUpLocation(){
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty && coordinates == nil{
            coordinates = locations.first
            locationManager.stopUpdatingLocation()
            requestWeatherForLocation()
        }
    }
    
    func requestWeatherForLocation(){
        guard let coordinates = coordinates else{
            return
        }
        let long = coordinates.coordinate.longitude
        let lat = coordinates.coordinate.latitude
        //let zipCode = coordinates.
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(long)&units=imperial&appid=" + key) else{return}
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data, error == nil{
                do{
                    guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any] else{return}
                    guard let weatherDetails = json["weather"] as? [[String:Any]], let weatherMain = json["main"] as? [String:Any] else {return}
                    let temp = Int(weatherMain["temp"] as? Double ?? 0)
                    let description = (weatherDetails.first?["description"] as? String)?.capitalizingFirstLetter()
                    let name = json["name"] as? String
                    DispatchQueue.main.async {
                        self.setWeather(weather: weatherDetails.first?["main"] as? String, description: description, temp: temp, name: name)
                    }
                }catch{
                    print("Error retreiving weather")
                }
                
            }
        }
        print("\(long) | \(lat)")
        task.resume()
    }
    
    
    func setWeather(weather: String?, description: String?, temp: Int?, name: String?){
        weatherDesciptionLabel.text = description ?? "..."
        tempLabel.text = "\(temp!)°"
        cityNameLabel.text = "\(name!)"
        switch weather{
        case "Sunny":
            weatherImageView.image = UIImage(named: "Sunny")
            background.backgroundColor = UIColor(red: 0.97, green: 0.78, blue: 0.35, alpha: 1.0)
        case "Clouds":
            weatherImageView.image = UIImage(named: "Cloudy")
            background.backgroundColor = UIColor(red: 0.42, green: 0.55, blue: 0.71, alpha: 1.0)
        default:
            weatherImageView.image = UIImage(named: "Rainy")
            background.backgroundColor = UIColor(red: 0, green: 0.4, blue: 0.6667, alpha: 1.0)
            
        }
        
        
        
    }
    


}

extension String{
    func capitalizingFirstLetter() -> String{
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}

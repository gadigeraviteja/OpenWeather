//
//  ViewController.swift
//  OpenWeatherApp
//
//  Created by G RaviTeja on 13/04/23.
//

import UIKit
import SDWebImage

class ViewController: UIViewController {
    
    var weather: WeatherModel?
    var locationName : String?
    var imgUrl = ""
    var manager : WeatherViewModel!
    var locationManager : LocationManagerViewModel!
    
    @IBOutlet weak var locationTextfield: UITextField!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var img_icon: UIImageView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var weatherDescLabel: UILabel!
    @IBOutlet weak var weatherHumidityLabel: UILabel!
    @IBOutlet weak var weatherTempLabel: UILabel!
    @IBOutlet weak var weatherFeelsLikeLabel: UILabel!
    
    override func viewDidLoad()   {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        locationTextfield.delegate = self
        manager = WeatherViewModel()
        locationManager = LocationManagerViewModel()
        
        if let savedValue = UserDefaults.standard.string(forKey: "selectedLocation") {
            locationTextfield.text = savedValue
            locationName = savedValue
            fetchWeatherData()
        } else {
            locationManager.retriveLocationDetails()
            locationManager.locationCompletionHandler = { [weak self] (currentLocation) in
                self?.manager.getCurrentWeather(latitude: currentLocation.latitude, longitude: currentLocation.longitude, completionHandler: { [weak self] (data) in
                    self?.populateDatainUI(data: data)
                })
            }
        }
    }
    
    @IBAction func getSelectedLocationDetails(_ sender: Any)
    {
        if locationTextfield.text == "" {
            UserDefaults.standard.removeObject(forKey: "selectedLocation")
            locationManager.retriveLocationDetails()
            locationManager.locationCompletionHandler = { [weak self] (currentLocation) in
                self?.manager.getCurrentWeather(latitude: currentLocation.latitude, longitude: currentLocation.longitude, completionHandler: { [weak self] (data) in
                    self?.populateDatainUI(data: data)
                })
            }
        } else {
            locationName = locationTextfield.text
            fetchWeatherData()
        }
    }
    
    func fetchWeatherData() {
        
        if let cityName = locationName {
            UserDefaults.standard.set(cityName, forKey: "selectedLocation")
            UserDefaults.standard.synchronize()
        } else {
            print("doesn't contain value")
        }
        
        manager.fetchWeatherData(city: locationName ?? "", completionHandler: { [weak self]
            (data) in
            self?.populateDatainUI(data: data)
        })
    }
    
    func populateDatainUI(data : WeatherModel) {
        DispatchQueue.main.async { [self] in
            self.cityNameLabel.text = data.name
            self.weatherDescLabel.text = data.weather[0].description
            self.weatherHumidityLabel.text = "\(data.main.humidity)"
            self.weatherTempLabel.text = "\(data.main.temp) ˚C"
            self.weatherFeelsLikeLabel.text = "\(data.main.feelsLike) ˚C"
            let icon = data.weather[0].icon
            self.imgUrl = "https://openweathermap.org/img/wn/\(icon).png"
            img_icon.sd_setImage(with: URL(string: self.imgUrl), placeholderImage:nil)
        }
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        locationTextfield.resignFirstResponder()
        return true
    }
}



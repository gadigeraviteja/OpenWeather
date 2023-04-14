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
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    
    @IBOutlet weak var img_icon: UIImageView!
    @IBOutlet weak var weatherDescLabel: UILabel!
    
    @IBOutlet weak var weatherTempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var windDegreeLabel: UILabel!
    
    @IBOutlet weak var weatherHumidityLabel: UILabel!
    @IBOutlet weak var weatherFeelsLikeLabel: UILabel!
    @IBOutlet weak var pressreLabel: UILabel!
    
    @IBOutlet weak var view1: UIView!
    
    @IBOutlet weak var view2: UIView!
    
    @IBOutlet weak var view3: UIView!
    
    @IBOutlet weak var view4: UIView!
    
    @IBOutlet weak var view5: UIView!
    
    
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
            
            self.weatherTempLabel.text = "\(data.main.temp) ˚C"
            self.maxTempLabel.text = "↑ \(data.main.tempMax) ˚C"
            self.minTempLabel.text = "↓ \(data.main.tempMin) ˚C"
            
            self.windSpeedLabel.text = "Speed : \(data.wind.speed)"
            self.windDegreeLabel.text = "Deg: \(data.wind.deg)"
            
            self.weatherFeelsLikeLabel.text = "\(data.main.feelsLike)"
            self.weatherHumidityLabel.text = "\(data.main.humidity)"
            self.pressreLabel.text = "\(data.main.pressure)"
            
            let icon = data.weather[0].icon
            self.imgUrl = "https://openweathermap.org/img/wn/\(icon).png"
            img_icon.sd_setImage(with: URL(string: self.imgUrl), placeholderImage:nil)
            
            view1.addViewBorder(borderColor: #colorLiteral(red: 0.1, green: 0.1, blue: 0.1, alpha: 1), borderWith: 1.0, borderCornerRadius: 20)
            view2.addViewBorder(borderColor: #colorLiteral(red: 0.1, green: 0.1, blue: 0.1, alpha: 1), borderWith: 1.0, borderCornerRadius: 20)
            view3.addViewBorder(borderColor: #colorLiteral(red: 0.1, green: 0.1, blue: 0.1, alpha: 1), borderWith: 1.0, borderCornerRadius: 20)
            view4.addViewBorder(borderColor: #colorLiteral(red: 0.1, green: 0.1, blue: 0.1, alpha: 1), borderWith: 1.0, borderCornerRadius: 20)
            view5.addViewBorder(borderColor: #colorLiteral(red: 0.1, green: 0.1, blue: 0.1, alpha: 1), borderWith: 1.0, borderCornerRadius: 20)
        }
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        locationTextfield.resignFirstResponder()
        return true
    }
}

extension UIView {
    public func addViewBorder(borderColor:CGColor,borderWith:CGFloat,borderCornerRadius:CGFloat){
        self.layer.borderWidth = borderWith
        self.layer.borderColor = borderColor
        self.layer.cornerRadius = borderCornerRadius
    }
}


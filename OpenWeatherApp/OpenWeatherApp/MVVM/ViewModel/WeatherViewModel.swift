//
//  WeatherViewModel.swift
//  OpenWeatherApp
//
//  Created by G RaviTeja on 13/04/23.
//

import Foundation
class WeatherViewModel {
    
    let apiKey = "8dc18688b9dbb856a04fc12247720d3f"
    
    func fetchWeatherData(city:String, completionHandler : @escaping (WeatherModel)->Void )  {
        
        let cityname = city.replacingOccurrences(of: " ", with: "%20")
        
        let url = URL(string: "http://api.openweathermap.org/data/2.5/weather?q=\(cityname)&appid=\(apiKey)&units=metric")!
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                print(error)
                return
            }
            
            // We want to ensure that we have a good HTTP response status
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200
    
            else {
                // Show the URL and response status code in the debug console
                if let httpResponse = response as? HTTPURLResponse {
                    print("URL: \(httpResponse.url!.path )\nStatus code: \(httpResponse.statusCode)")
                }
                return
            }
            
            if let data = data {
                
                // Create and configure a JSON decoder
                let decoder = JSONDecoder()
                
                do {
                    let result = try decoder.decode(WeatherModel.self, from: data)
                    completionHandler(result)
                }
                catch {
                    print("error exception in url session")
                    print(error)
                }
            }
        }
        
        task.resume()
        
    }
    
    func getCurrentWeather(latitude: Double, longitude: Double,  completionHandler : @escaping (WeatherModel)->Void) {
        

        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=metric") else { fatalError("Missing URL") }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                print("error in url session")
                print(error)
                return
            }
            
            // We want to ensure that we have a good HTTP response status
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200
    
            else {
                // Show the URL and response status code in the debug console
                if let httpResponse = response as? HTTPURLResponse {
                    print("URL: \(httpResponse.url!.path )\nStatus code: \(httpResponse.statusCode)")
                }
                return
            }
            
            if let data = data {
                
                // Create and configure a JSON decoder
                let decoder = JSONDecoder()
                
                do {
                    let result = try decoder.decode(WeatherModel.self, from: data)
                    completionHandler(result)
                }
                catch {
                    print("error exception in url session")
                    print(error)
                }
            }
        }
        
        task.resume()
        
    }
    
}

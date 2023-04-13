//
//  WeatherModel.swift
//  OpenWeatherApp
//
//  Created by G RaviTeja on 13/04/23.
//

import Foundation

struct WeatherModel: Codable {
    var coord: Coordinates
    var weather: [Weather]
    var main: Main
    var name: String
    var wind: Wind

    struct Coordinates: Codable {
        var lon: Double
        var lat: Double
    }

    struct Weather: Codable {
        var id: Double
        var main: String
        var description: String
        var icon: String
    }

    struct Main: Codable {
        var temp: Double
        var feels_like: Double
        var temp_min: Double
        var temp_max: Double
        var pressure: Double
        var humidity: Double
    }
    
    struct Wind: Codable {
        var speed: Double
        var deg: Double
    }
}

extension WeatherModel.Main {
    var feelsLike: Double { return feels_like }
    var tempMin: Double { return temp_min }
    var tempMax: Double { return temp_max }
}


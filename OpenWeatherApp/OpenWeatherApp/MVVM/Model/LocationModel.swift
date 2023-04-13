//
//  LocationModel.swift
//  OpenWeatherApp
//
//  Created by G RaviTeja on 14/04/23.
//

import Foundation

struct LocationModel {
    var latitude : Double
    var longitude : Double
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}

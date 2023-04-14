//
//  LocationManagerViewModel.swift
//  OpenWeatherApp
//
//  Created by G RaviTeja on 14/04/23.
//

import Foundation
import CoreLocation

class LocationManagerViewModel: NSObject {
    
    let locationManager = CLLocationManager()
    
    var locationCompletionHandler: ((LocationModel)-> Void)!
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }
    
    func retriveLocationDetails()
    {
        locationManager.requestLocation()
        let status = CLLocationManager.authorizationStatus()
        

        if(status == .denied || status == .restricted) {
            return
        }
        
        if(status == .notDetermined) {
            locationManager.requestWhenInUseAuthorization()
            return
        }
    }
}

extension LocationManagerViewModel : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        case .authorizedAlways:
            print("user allow app to get location data when app is active or in background")
        case .authorizedWhenInUse:
            print("user allow app to get location data only when app is active")
        case .denied:
            print("user tap 'disallow' on the permission dialog, cant get location data")
        case .restricted:
            print("parental control setting disallow location data")
        case .notDetermined:
            print("the location permission dialog haven't shown before, user haven't tap allow/disallow")
        default:
            print("the location permission dialog haven't shown before, user haven't tap allow/disallow")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])  {
        
        // the last element is the most recent location
        if let location = locations.last {
            let currentLocation = LocationModel(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            
            locationCompletionHandler(currentLocation)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error ",error)
        
    }
    
}

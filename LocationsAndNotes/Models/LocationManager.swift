//
//  LocationManager.swift
//  LocationsAndNotes
//
//  Created by Ekaterina on 27.04.21.
//

import UIKit
import CoreLocation

struct LocationCoordinate {
    var lat: Double
    var lon: Double
    
    static func create(location: CLLocation) -> LocationCoordinate {
        return LocationCoordinate(lat: location.coordinate.latitude, lon: location.coordinate.longitude)
    }
}

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    static let sharedInstance = LocationManager()
    
    var manager = CLLocationManager()
    var blockForSave: ((LocationCoordinate) -> Void )?
    
    func requestAutorization() {
        manager.requestWhenInUseAuthorization()
    }
    
    func getCurrentLocation(block: ((LocationCoordinate) -> Void )?) {
        
        if manager.authorizationStatus != .authorizedWhenInUse {
            return
        }
        blockForSave = block
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.activityType = .other
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let last = locations.last {
        let lc = LocationCoordinate.create(location: last)
            blockForSave?(lc)
        }
        manager.stopUpdatingLocation()
    }
    
}

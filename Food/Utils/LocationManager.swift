//
//  LocationManager.swift
//  Food
//
//  Created by Mathias da Rosa on 14/04/25.
//

import Foundation
import CoreLocation

protocol LocationManagerDelegate: AnyObject {
    func didUpdateLocation(_ location: CLLocation)
    func didChangeAuthorization(_ status: CLAuthorizationStatus)
}

protocol LocationManagerProtocol: AnyObject {
    var delegate: LocationManagerDelegate? { get set }
    func requestPermission()
    func requestLocation()
}

class LocationManager: NSObject, CLLocationManagerDelegate, LocationManagerProtocol {
    static let shared = LocationManager()
    
    private let manager = CLLocationManager()
    weak var delegate: LocationManagerDelegate?

    private override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func requestPermission() {
        manager.requestWhenInUseAuthorization()
    }

    func requestLocation() {
        manager.startUpdatingLocation()
    }

    // CLLocationManagerDelegate methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            delegate?.didUpdateLocation(location)
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        delegate?.didChangeAuthorization(status)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get location: \(error)")
    }
}

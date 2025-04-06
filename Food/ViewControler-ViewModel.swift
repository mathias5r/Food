//
//  ViewControler-ViewModel.swift
//  Food
//
//  Created by Mathias on 06/04/25.
//

import Foundation
import MapKit

extension ViewController {
    @Observable
    class ViewModel {
        private(set) var locations: [MKMapItem] = []
        
        public func setLocations(_ locations: [MKMapItem]) {
            self.locations = locations
        }
        
        public func getCoordsFromLocation(at index: Int) -> CLLocationCoordinate2D {
            let location = locations[index]
            let locationCoordinates = location.placemark.coordinate
            return CLLocationCoordinate2D(latitude:locationCoordinates.latitude, longitude: locationCoordinates.longitude)
        }
        
    }
}

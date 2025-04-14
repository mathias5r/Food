//
//  ViewControler-ViewModel.swift
//  Food
//
//  Created by Mathias on 06/04/25.
//

import Foundation
import MapKit

protocol ViewModalDelegate {
    func didSearchComplete(results: [MKMapItem])
}

extension ViewController {
    @Observable
    class ViewModel {
        
        var locationManager: CLLocationManager?
        
        var delegate: ViewModalDelegate?
        
        private(set) var locations: [MKMapItem] = []
        
        public func setLocations(_ locations: [MKMapItem]) {
            self.locations = locations
        }
        
        public func getCoordsFromLocation(at index: Int) -> CLLocationCoordinate2D {
            let location = locations[index]
            let locationCoordinates = location.placemark.coordinate
            return CLLocationCoordinate2D(latitude:locationCoordinates.latitude, longitude: locationCoordinates.longitude)
        }
        
        public func searchFood(_ searchString: String, _ region: MKCoordinateRegion) {
            let searchRequest = MKLocalSearch.Request()
            searchRequest.naturalLanguageQuery = searchString
            searchRequest.region = region
            searchRequest.pointOfInterestFilter = .init(including: [.foodMarket, .restaurant])
            
            let search = MKLocalSearch(request: searchRequest)
            search.start { response, error in
                guard let response = response else {
                    print("Error: \(error?.localizedDescription ?? "Unknown error").")
                    return
                }
                
                self.setLocations(response.mapItems)
                self.delegate?.didSearchComplete(results: response.mapItems)
            }
        }
    }
    
}

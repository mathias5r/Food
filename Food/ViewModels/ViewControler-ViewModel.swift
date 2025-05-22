//
//  ViewControler-ViewModel.swift
//  Food
//
//  Created by Mathias on 06/04/25.
//

import Foundation
import MapKit

protocol ViewModalDelegate: AnyObject {
    func didSearchComplete(results: [MKMapItem])
    func didUpdateLocation(_ location: CLLocation)
    func didChangeAuthorization(_ status: CLAuthorizationStatus)
}

protocol ViewModelProtocol: AnyObject {
    var locations: [MKMapItem] { get }
    var delegate: ViewModalDelegate? { get set }
    func searchFood(_ searchString: String, _ region: MKCoordinateRegion) -> Void
    func setLocations(_ locations: [MKMapItem]) -> Void
    func getCoordsFromLocation(at index: Int) -> CLLocationCoordinate2D
}

class ViewModel: ViewModelProtocol, LocationManagerDelegate {
    
    // This weak reference allow the ViewModal and ViewController to be deallocated when the screen is hidden
    weak var delegate: ViewModalDelegate?
    
    private let locationManager: LocationManagerProtocol
    
    init(locationManager: LocationManagerProtocol) {
        self.locationManager = locationManager
        self.locationManager.delegate = self
        self.locationManager.requestPermission()
        self.locationManager.requestLocation()
    }
    
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
        // weak self allow a weak refence between the closure of search.start and "self" itself
        search.start { [weak self] response, error in
            guard let response = response else {
                print("Error: \(error?.localizedDescription ?? "Unknown error").")
                return
            }
            
            guard let self = self else {
                return
            }
            
            self.setLocations(response.mapItems)
            self.didSearchComplete(results: response.mapItems)
            
        }
    }
    
    func didUpdateLocation(_ location: CLLocation) {
        delegate?.didUpdateLocation(location)
    }
    
    func didChangeAuthorization(_ status: CLAuthorizationStatus) {
        delegate?.didChangeAuthorization(status)
    }
    
    func didSearchComplete(results: [MKMapItem]) {
        delegate?.didSearchComplete(results: results)
    }
}

//
//  ViewControler-ViewModel.swift
//  Food
//
//  Created by Mathias on 06/04/25.
//

import Foundation
import MapKit
import Alamofire

protocol ViewModalDelegate: AnyObject {
    func didSearchComplete(results: [RestaurantModel])
    func didUpdateLocation(_ location: CLLocation)
    func didChangeAuthorization(_ status: CLAuthorizationStatus)
}

protocol ViewModelProtocol: AnyObject {
    var restaurants: [RestaurantModel] { get }
    var delegate: ViewModalDelegate? { get set }
    func searchFood(_ searchString: String, _ region: MKCoordinateRegion) -> Void
    func setRestaurants(_ locations: [RestaurantModel]) -> Void
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
    
    private(set) var restaurants: [RestaurantModel] = []
    
    public func setRestaurants(_ restaurants: [RestaurantModel]) {
        self.restaurants = restaurants
    }
    
    public func getCoordsFromLocation(at index: Int) -> CLLocationCoordinate2D {
        let restaurant = restaurants[index]
        let coords = restaurant.location
        return CLLocationCoordinate2D(latitude: coords.lat, longitude: coords.long)
    }
    
    public func searchFood(_ searchString: String, _ region: MKCoordinateRegion) {
        AF.request("http://localhost:3000/api/restaurants").response { response in
            debugPrint(response)
        }
        
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
            
            let restaurants = response.mapItems.map(_transform)
            
            self.setRestaurants(restaurants)
            self.didSearchComplete(results: restaurants)
        }
    }
    
    func didUpdateLocation(_ location: CLLocation) {
        delegate?.didUpdateLocation(location)
    }
    
    func didChangeAuthorization(_ status: CLAuthorizationStatus) {
        delegate?.didChangeAuthorization(status)
    }
    
    func didSearchComplete(results: [RestaurantModel]) {
        delegate?.didSearchComplete(results: results)
    }
    
    private func _transform(mapItem: MKMapItem) -> RestaurantModel {
        let name = mapItem.name ?? "Unknown Name"
        
        let location = LocationModel(lat: mapItem.placemark.coordinate.latitude, long: mapItem.placemark.coordinate.longitude)
        
        let address = _formatAddress(from: mapItem.placemark)
        
        return RestaurantModel(name: name, location: location, address: address)
    }

    private func _formatAddress(from placemark: MKPlacemark) -> AddressModel {
        let parts = [
            placemark.subThoroughfare,
            placemark.thoroughfare,
            placemark.locality,
            placemark.administrativeArea,
            placemark.postalCode,
            placemark.country
        ]
        
        return AddressModel(
            country: placemark.country ?? "Unknown Country",
            street: placemark.thoroughfare ?? "Unknown Street",
            city: placemark.locality ?? "Unknown City",
            state: placemark.administrativeArea ?? "Unknown State",
            zipCode: placemark.postalCode ?? "Unknown Zip Code"
        )
    }
}

//
//  ViewControler-ViewModel.swift
//  Food
//
//  Created by Mathias on 06/04/25.
//

import Foundation
import MapKit
import Alamofire

protocol HomeViewModelDelegate: AnyObject {
    func didSearchComplete(results: [RestaurantModel], error: Error?)
    func didUpdateLocation(_ location: CLLocation)
    func didChangeAuthorization(_ status: CLAuthorizationStatus)
}

protocol HomeViewModelProtocol: AnyObject {
    var restaurants: [RestaurantModel] { get }
    var delegate: HomeViewModelDelegate? { get set }
    func searchFood(_ searchString: String, _ region: MKCoordinateRegion) -> Void
    func getRecents() -> [String]
    func setRestaurants(_ locations: [RestaurantModel]) -> Void
    func getCoordsFromLocation(at index: Int) -> CLLocationCoordinate2D
}

class HomeViewModel: HomeViewModelProtocol, LocationManagerDelegate {
    
    // This weak reference allow the ViewModal and ViewController to be deallocated when the screen is hidden
    weak var delegate: HomeViewModelDelegate?
    
    private let locationManager: LocationManagerProtocol
    private let httpClient: HttpClientProtocol
    private let recentRepository: RecentRepository
    private var userLocation: CLLocation?
    
    init(locationManager: LocationManagerProtocol, httpClient: HttpClientProtocol, recentRepository: RecentRepository) {
        self.httpClient = httpClient
        self.recentRepository = recentRepository
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
        recentRepository.create(value: searchString)
        struct Params: Encodable {
            let search: String;
            let lat: Double;
            let long: Double
            let range: Int
        }
        if let location = userLocation {
            let lat = location.coordinate.latitude
            let long = location.coordinate.longitude
            let range = 10000
            httpClient.get(path: "/restaurants", params: Params(search: searchString, lat: lat, long: long, range: range), completion: {
                result in switch result {
                    case .success(let data):
                        if let data = data {
                            do {
                                let restaurants = try JSONDecoder().decode([RestaurantModel].self, from: data)
                                self.setRestaurants(restaurants)
                                self.didSearchComplete(results: restaurants)
                            } catch {
                                self.setRestaurants([])
                                self.didSearchComplete(results: [], error: error)
                            }
                        } else {
                            self.setRestaurants([])
                            self.didSearchComplete(results: [])
                        }
                    case .failure(let error):
                        self.setRestaurants([])
                        self.didSearchComplete(results: [], error: error)
                    }
            })
        }
    }
    
    public func getRecents() -> [String] {
        return self.recentRepository.get()
    }
    
    func didUpdateLocation(_ location: CLLocation) {
        self.userLocation = location
        delegate?.didUpdateLocation(location)
    }
    
    func didChangeAuthorization(_ status: CLAuthorizationStatus) {
        delegate?.didChangeAuthorization(status)
    }
    
    func didSearchComplete(results: [RestaurantModel], error: Error? = nil) {
        delegate?.didSearchComplete(results: results, error: error)
    }
}

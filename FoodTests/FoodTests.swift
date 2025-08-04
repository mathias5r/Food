//
//  FoodTests.swift
//  FoodTests
//
//  Created by Mathias da Rosa on 17/06/25.
//

import Testing
@testable import Food
import Foundation
import Alamofire

struct FoodTests {
    
    class MockedLocationManager: LocationManagerProtocol {
        var delegate: (any Food.LocationManagerDelegate)?
        
        func requestPermission() {
        }
        
        func requestLocation() {
        }
    }
    
    class MockedHttpClient: HttpClientProtocol {
        func get(path: String, params: any Encodable, completion: @escaping (Result<Data?, Alamofire.AFError>) -> Void) {
            completion(.success(Data()))
        }
        
        func get(path: String, completion: @escaping (Result<Data?, Alamofire.AFError>) -> Void) {
            completion(.success(Data()))
        }
    }
    
    @Test func example() async throws {
        let mockedLocationManager = MockedLocationManager()
        let mockedHttpClient = MockedHttpClient()
        let viewModel = ViewModel(locationManager: mockedLocationManager, httpClient: mockedHttpClient)
        let location: LocationModel = LocationModel(lat: 0, long: 0);
        let address: AddressModel = AddressModel(country: "test", street: "test", city: "test", state: "test", zipCode: "test")
    
        let restaurant: RestaurantModel = RestaurantModel(name: "test", location: location, address: address, image: "", phone: "", rating: 1.0, cuisine: "")
        let restaurants = [restaurant]
        viewModel.setRestaurants(restaurants)
        #expect(viewModel.restaurants.contains(where: { $0.name == "test" }))
    }

}

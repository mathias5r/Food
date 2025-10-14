//
//  FoodTests.swift
//  FoodTests
//
//  Created by Mathias da Rosa on 17/06/25.
//

import Alamofire
@testable import Food
import Foundation
import Testing

struct FoodTests {
    class MockedLocationManager: LocationManagerProtocol {
        var delegate: (any Food.LocationManagerDelegate)?

        func requestPermission() {}

        func requestLocation() {}
    }

    class MockedHttpClient: HttpClientProtocol {
        func get(
            path _: String,
            params _: any Encodable,
            completion: @escaping (Result<Data?, Alamofire.AFError>) -> Void
        ) {
            completion(.success(Data()))
        }

        func get(path _: String, completion: @escaping (Result<Data?, Alamofire.AFError>) -> Void) {
            completion(.success(Data()))
        }
    }

    @Test func example() async throws {
        let mockedLocationManager = MockedLocationManager()
        let mockedHttpClient = MockedHttpClient()
        let viewModel = HomeViewModel(
            locationManager: mockedLocationManager,
            httpClient: mockedHttpClient
        )
        let location = LocationModel(lat: 0, long: 0)
        let address = AddressModel(
            country: "test",
            street: "test",
            city: "test",
            state: "test",
            zipCode: "test"
        )

        let restaurant = RestaurantModel(
            name: "test",
            location: location,
            address: address,
            image: "",
            phone: "",
            rating: 1.0,
            cuisine: ""
        )
        let restaurants = [restaurant]
        viewModel.setRestaurants(restaurants)
        #expect(viewModel.restaurants.contains(where: { $0.name == "test" }))
    }
}

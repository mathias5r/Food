//
//  RestaurantDTO.swift
//  Food
//
//  Created by Mathias da Rosa on 20/08/25.
//

import Foundation
import RealmSwift

class RestaurantDTO: Object {
    @Persisted(primaryKey: true) var _id: String
    @Persisted var name: String
    @Persisted var location: LocationDTO?
    @Persisted var address: AddressDTO?
    @Persisted var image: String
    @Persisted var phone: String
    @Persisted var rating: Double
    @Persisted var cuisine: String
    @Persisted var visits: Int
    
    convenience init(from restaurant: RestaurantModel) {
        self.init()
        self._id = restaurant._id
        self.name = restaurant.name
        self.location = LocationDTO(from: restaurant.location)
        self.address = AddressDTO(from: restaurant.address)
        self.image = restaurant.image
        self.phone = restaurant.phone
        self.rating = restaurant.rating
        self.cuisine = restaurant.cuisine
    }
    
    func toRestaurant() -> RestaurantModel {
        guard let location = self.location else {
            fatalError("[RestaurantDTO]: Location is not defined")
        }
        guard let address = self.address else {
            fatalError("[RestaurantDTO]: Address is not defined")
        }
        return RestaurantModel(
            _id: self._id,
            name: self.name,
            location: location.toLocation(),
            address: address.toAddress(),
            image: self.image,
            phone: self.phone,
            rating: self.rating,
            cuisine: self.cuisine
        )
    }
}

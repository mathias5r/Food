//
//  LocationModel.swift
//  Food
//
//  Created by Mathias da Rosa on 30/05/25.
//

import Foundation

struct RestaurantModel: Codable {
    let name: String
    let location: LocationModel
    let address: AddressModel
    let image: String
    let phone: String
    let rating: Double
    let cuisine: String
}

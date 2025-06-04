//
//  LocationModel.swift
//  Food
//
//  Created by Mathias da Rosa on 30/05/25.
//

import Foundation

struct RestaurantModel: Decodable {
    let name: String
    let location: LocationModel
    let address: AddressModel
}

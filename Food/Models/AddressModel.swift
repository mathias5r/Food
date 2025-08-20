//
//  AddressModel.swift
//  Food
//
//  Created by Mathias da Rosa on 30/05/25.
//

import Foundation

struct AddressModel: Codable {
    let country: String
    let street: String
    let city: String
    let state: String
    let zipCode: String
}

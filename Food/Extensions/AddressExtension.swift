//
//  AddressExtension.swift
//  Food
//
//  Created by Mathias da Rosa on 11/06/25.
//

extension AddressModel {
    func toString() -> String {
        return "\(street), \(city), \(state), \(zipCode)"
    }
}

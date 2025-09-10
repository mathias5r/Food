//
//  AddressDTO.swift
//  Food
//
//  Created by Mathias da Rosa on 20/08/25.
//

import RealmSwift
import Foundation

class AddressDTO: Object {
    @Persisted var country: String
    @Persisted var street: String
    @Persisted var city: String
    @Persisted var state: String
    @Persisted var zipCode: String
    
    convenience init(from address: AddressModel) {
        self.init()
        self.country = address.country
        self.street = address.street
        self.city = address.city
        self.state = address.state
        self.zipCode = address.zipCode
    }
    
    func toAddress() -> AddressModel {
        return AddressModel(country: self.country, street: self.street, city: self.city, state: self.state, zipCode: self.zipCode)
    }
}

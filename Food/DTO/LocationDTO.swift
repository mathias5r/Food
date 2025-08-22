//
//  LocationDTO.swift
//  Food
//
//  Created by Mathias da Rosa on 20/08/25.
//

import Foundation
import RealmSwift

class LocationDTO: Object {
    @Persisted var lat: Double
    @Persisted var long: Double
    
    convenience init(from location: LocationModel) {
        self.init()
        self.lat = location.lat
        self.long = location.long
    }
    
    func toLocation() -> LocationModel {
        return LocationModel(lat: self.lat, long: self.long )
    }
}

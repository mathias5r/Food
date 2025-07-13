//
//  LocationModel.swift
//  Food
//
//  Created by Mathias da Rosa on 30/05/25.
//

import Foundation

struct LocationModel: Decodable {
    let lat: Double
    let long: Double
    
    private enum CodingKeys: String, CodingKey {
        case coordinates
    }
    
    init(lat: Double, long: Double) {
        self.lat = lat
        self.long = long
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let coordinates = try container.decode([Double].self, forKey: .coordinates)

        guard coordinates.count == 2 else {
            throw DecodingError.dataCorruptedError(forKey: .coordinates,
                in: container,
                debugDescription: "Coordinates array must contain exactly 2 elements.")
        }

        self.long = coordinates[0]
        self.lat = coordinates[1]
    }
}

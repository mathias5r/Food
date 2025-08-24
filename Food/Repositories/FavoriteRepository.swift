//
//  RecentRepository.swift
//  Food
//
//  Created by Mathias da Rosa on 11/08/25.
//

import Foundation
import RealmSwift

protocol FavouriteRepositoryProtocal {
    func get() -> [RestaurantModel]
    func create(from restaurant: RestaurantModel)
}

class FavouriteRepository: FavouriteRepositoryProtocal {
    func get() -> [RestaurantModel] {
        do {
            let realm = try Realm()
            
            let restaurants = realm.objects(RestaurantDTO.self).sorted(byKeyPath: "visits", ascending: false)
            
            if(restaurants.count > 0) {
                return restaurants.map { $0.toRestaurant() }
            } else {
                print("[FavouriteRepository]: No recent was found")
                return []
            }
        } catch {
            print("[FavouriteRepository]: get operation failed: \(error.localizedDescription)")
            return []
        }
    }
    
    func create(from restaurant: RestaurantModel) {
        do {
            let realm = try Realm()
            
            let favorite = realm.object(ofType: RestaurantDTO.self, forPrimaryKey: restaurant._id)
            
            if let item = favorite {
                try realm.write {
                    item.visits+=1
                }
            } else {
                let newFavorite = RestaurantDTO(from: restaurant)
                try realm.write {
                    realm.add(newFavorite)
                }
            }
        } catch {
            print("[FavouriteRepository]: create operation failed: \(error.localizedDescription)")
        }
    }
}

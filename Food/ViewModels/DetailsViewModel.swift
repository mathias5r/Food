//
//  DetailsViewModel.swift
//  Food
//
//  Created by Mathias da Rosa on 22/08/25.
//

import FoodData
import FoodDomain
import Foundation

protocol DetailsViewModelProtocol {
    func favoriteRestaurant(_ restaurant: RestaurantModel)
    func getFavorites() -> [RestaurantModel]
}

class DetailsViewModel: DetailsViewModelProtocol {
    private let favoriteRepository: FavouriteRepositoryProtocal

    init(favoriteRepository: FavouriteRepositoryProtocal) {
        self.favoriteRepository = favoriteRepository
    }

    func favoriteRestaurant(_ restaurant: RestaurantModel) {
        favoriteRepository.create(from: restaurant)
    }

    func getFavorites() -> [RestaurantModel] {
        favoriteRepository.get()
    }
}

//
//  DetailsViewModel.swift
//  Food
//
//  Created by Mathias da Rosa on 22/08/25.
//

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
        self.favoriteRepository.create(from: restaurant)
    }
    
    func getFavorites() -> [RestaurantModel] {
        return self.favoriteRepository.get()
    }
}

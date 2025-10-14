//
//  DetailsFactory.swift
//  Food
//
//  Created by Mathias da Rosa on 12/06/25.
//

import FoodData
import FoodDomain
import SwiftUI
import UIKit

class DetailsFactory {
    static func view(restaurant: RestaurantModel, onClose: @escaping () -> Void)
        -> some View
    {
        let favoriteRepository = FavouriteRepository()
        let viewModel = DetailsViewModel(favoriteRepository: favoriteRepository)
        return DetailsView(
            restaurant: restaurant, viewModel: viewModel, onClose: onClose
        )
    }
}

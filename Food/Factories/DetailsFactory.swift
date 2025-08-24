//
//  DetailsFactory.swift
//  Food
//
//  Created by Mathias da Rosa on 12/06/25.
//

import UIKit
import SwiftUI

class DetailsFactory {
    static func view(restaurant: RestaurantModel) -> some View {
        let favoriteRepository = FavouriteRepository()
        let viewModel = DetailsViewModel(favoriteRepository: favoriteRepository)
        return DetailsView(restaurant: restaurant, viewModel: viewModel)
    }
}


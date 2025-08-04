//
//  DetailsFactory.swift
//  Food
//
//  Created by Mathias da Rosa on 12/06/25.
//

import UIKit
import SwiftUI

protocol DetailsFactoryProtocol {
   static func viewController(restaurant: RestaurantModel) -> UIViewController
}

class DetailsFactory: DetailsFactoryProtocol {
    static func viewController(restaurant: RestaurantModel) -> UIViewController {
        let viewController = DetailsViewController()
        viewController.restaurant = restaurant
        return viewController;
    }
    
    static func viewUIController(restaurant: RestaurantModel) -> UIViewController {
        var view = DetailsViewControllerSwiftUI(restaurant: restaurant)
        let hostingController = UIHostingController(rootView: view)
        return hostingController
    }
}


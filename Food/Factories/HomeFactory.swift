//
//  HomeFactory.swift
//  Food
//
//  Created by Mathias da Rosa on 25/04/25.
//

import UIKit

protocol HomeFactoryProtocol {
   static func viewController() -> UIViewController
}

class HomeFactory: HomeFactoryProtocol {
    static func viewController() -> UIViewController {
        let locationManager = LocationManager.shared
        let viewModel = ViewModel(locationManager: locationManager)
        let viewController = ViewController(viewModel: viewModel)
        return viewController;
    }
}


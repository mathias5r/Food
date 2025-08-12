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
        let httpClient = HttpClient.shared
        let recentsRepository = RecentRepository()
        let viewModel = HomeViewModel(locationManager: locationManager, httpClient: httpClient, recentRepository: recentsRepository)
        let viewController = HomeViewController(viewModel: viewModel)
        return viewController;
    }
}


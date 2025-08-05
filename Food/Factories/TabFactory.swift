//
//  DetailsFactory.swift
//  Food
//
//  Created by Mathias da Rosa on 12/06/25.
//

import UIKit
import SwiftUI

protocol TabFactoryProtocol {
   static func viewController() -> UIViewController
}

class TabFactory: TabFactoryProtocol {
    static func viewController() -> UIViewController {
        var view = TabsView()
        let hostingController = UIHostingController(rootView: view)
        return hostingController
    }
}



//
//  TabFactory.swift
//  Food
//
//  Created by Mathias da Rosa on 12/06/25.
//

import SwiftUI
import UIKit

protocol TabFactoryProtocol {
    static func viewController() -> UIViewController
}

class TabFactory: TabFactoryProtocol {
    static func viewController() -> UIViewController {
        let view = TabsView()
        let hostingController = UIHostingController(rootView: view)
        return hostingController
    }
}

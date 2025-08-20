//
//  ProfileFactory.swift
//  Food
//
//  Created by Mathias da Rosa on 06/08/25.
//

import UIKit
import SwiftUI


class ProfileFactory {
    static func view() ->  some View {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {
            fatalError()
        }
        let userRepository = UserRepository(context: context)
        let viewModel = ProfileViewModel(userRepository: userRepository)
        return ProfileView(viewModel: viewModel)
    }
}



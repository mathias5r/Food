//
//  ProfileFactory.swift
//  Food
//
//  Created by Mathias da Rosa on 06/08/25.
//

import FoodData
import SwiftUI
import UIKit

class ProfileFactory {
    static func view() -> some View {
        let userRepository = UserRepository()
        let viewModel = ProfileViewModel(userRepository: userRepository)
        return ProfileView(viewModel: viewModel)
    }
}

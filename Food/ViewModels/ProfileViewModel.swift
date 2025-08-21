//
//  ProfileViewModel.swift
//  Food
//
//  Created by Mathias da Rosa on 07/08/25.
//

import Foundation

protocol ProfileViewModelProtocol {
    func saveProfile(name: String, lastname: String, email: String)
    func getProfile() -> UserModel?
}

class ProfileViewModel: ProfileViewModelProtocol {
    private let userRepository: UserRepositoryProtocol
    
    init(userRepository: UserRepositoryProtocol) {
        self.userRepository = userRepository
    }
    
    public func saveProfile(name: String, lastname: String, email: String) {
        if userRepository.get() != nil {
            userRepository.update(from: UserModel(name: name, lastname: lastname, email: email)) { completed in
                print("User updated: \(completed)")
            }
        } else {
            userRepository.create(from: UserModel(name: name, lastname: lastname, email: email)) { completed in
                print("User created: \(completed)")
            }
        }
    }
    
    public func getProfile() -> UserModel? {
        if let user = userRepository.get() {
            return user
        }
        return nil
    }
}

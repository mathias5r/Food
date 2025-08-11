//
//  ProfileViewModel.swift
//  Food
//
//  Created by Mathias da Rosa on 07/08/25.
//

import Foundation

protocol ProfileViewModelProtocol {
    func saveProfile(profile: ProfileModel)
    func getProfile() -> ProfileModel?
}

class ProfileViewModel: ProfileViewModelProtocol {
    private let userRepository: UserRepository?
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    public func saveProfile(profile: ProfileModel) {
        guard let repository = self.userRepository else {
            print("User repository not defined")
            return
        }
        
        if (repository.get() != nil) {
            repository.update(name: profile.name, lastname: profile.lastname, email: profile.email) { completed in
                print("User updated: \(completed)")
            }
            return
        }
        
        repository.create(name: profile.name, lastname: profile.lastname, email: profile.email) { completed in
            print("User created: \(completed)")
        }
    }
    
    public func getProfile() -> ProfileModel? {
        guard let repository = self.userRepository else {
            print("User repository not defined")
            return nil
        }
        if let user = repository.get() {
            print(user.name)
            return ProfileModel(name: user.name, lastname: user.lastname, email: user.email)
        }
        return nil
    }
}

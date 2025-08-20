//
//  ProfileView.swift
//  Food
//
//  Created by Mathias da Rosa on 06/08/25.
//

import SwiftUI

struct ProfileView: View {
    @State var name: String = ""
    @State var lastname: String = ""
    @State var email: String = ""
    
    var viewModel: ProfileViewModelProtocol
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                Input(text: $name, placeholder: "Name", label: "Name")
                Input(text: $lastname, placeholder: "Lastname", label: "Lastname")
                Input(text: $email, placeholder: "Email", label: "Email").textInputAutocapitalization(.never)
                Spacer()
                PrimaryButton(title: "Save", action: {
                    let profile = ProfileModel(name: name, lastname: lastname, email: email)
                    viewModel.saveProfile(profile: profile)
                })
            }.padding(32)
        }.onAppear(perform: {
            let profile = viewModel.getProfile()
            name = profile?.name ?? ""
            lastname = profile?.lastname ?? ""
            email = profile?.email ?? ""
        })
    }
}

private class EmptyUserRepository: UserRepositoryProtocol {
    func get() -> User? {
        return nil
    }
    
    func create(name: String, lastname: String, email: String, completion: @escaping (Bool) -> Void) {}
    
    func delete(completion: @escaping (Bool) -> Void) {}
    
    func update(name: String?, lastname: String?, email: String?, completion: @escaping (Bool) -> Void) {}
    
    
}

struct ProfileView_Preview: PreviewProvider {
    static var previews: some View {
        let userRepository = EmptyUserRepository()
        let viewModel = ProfileViewModel(userRepository: userRepository)
        ProfileView(viewModel: viewModel)
    }
}

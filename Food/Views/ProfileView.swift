//
//  ProfileView.swift
//  Food
//
//  Created by Mathias da Rosa on 06/08/25.
//

import FoodData
import FoodDomain
import FoodUI
import SwiftUI

struct ProfileView: View {
    @State var name: String = ""
    @State var lastname: String = ""
    @State var email: String = ""

    var viewModel: ProfileViewModelProtocol

    var body: some View {
        GeometryReader { _ in
            VStack(alignment: .leading) {
                Input(text: $name, placeholder: "Name", label: "Name")
                Input(text: $lastname, placeholder: "Lastname", label: "Lastname")
                Input(text: $email, placeholder: "Email", label: "Email")
                    .textInputAutocapitalization(.never)
                Spacer()
                PrimaryButton(title: "Save", action: {
                    viewModel.saveProfile(name: name, lastname: lastname, email: email)
                })
            }.padding(32)
        }.onAppear(perform: {
            if let user = viewModel.getProfile() {
                name = user.name
                lastname = user.lastname
                email = user.email
            }
        })
    }
}

private class EmptyUserRepository: UserRepositoryProtocol {
    func get() -> UserModel? {
        nil
    }

    func create(from _: UserModel, completion _: @escaping (Bool) -> Void) {}

    func delete(completion _: @escaping (Bool) -> Void) {}

    func update(from _: UserModel, completion _: @escaping (Bool) -> Void) {}
}

struct ProfileViewPreview: PreviewProvider {
    static var previews: some View {
        let userRepository = EmptyUserRepository()
        let viewModel = ProfileViewModel(userRepository: userRepository)
        ProfileView(viewModel: viewModel)
    }
}

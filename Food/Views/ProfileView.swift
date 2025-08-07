//
//  ProfileView.swift
//  Food
//
//  Created by Mathias da Rosa on 06/08/25.
//

import SwiftUI

struct ProfileView: View {
    @State var text: String = ""
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                Input(text: text, placeholder: "Name", label: "Name")
                Input(text: text, placeholder: "Lastname", label: "Lastname")
                Input(text: text, placeholder: "Email", label: "Email")
                Spacer()
                PrimaryButton(title: "Save", action: { print("Save")})
            }.padding(32)
        }
    }
}

struct ProfileView_Preview: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}

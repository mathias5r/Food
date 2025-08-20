//
//  Button.swift
//  Food
//
//  Created by Mathias da Rosa on 06/08/25.
//
import SwiftUI

struct PrimaryButton: View {
    var title: String
    var action: () -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            Button(action: action) {
                Text(title).frame(maxWidth: .infinity).tint(Color.white)
            }
            .padding(16)
            .background(Color.secondary)
            .cornerRadius(16)
        }
    }
}

struct Button_Preview: PreviewProvider {
    static var previews: some View {
        VStack {
            PrimaryButton(title: "Button", action: { print("Button Pressed")})
        }
        .padding(32)
        .border(.black, width: 1)
    }
}



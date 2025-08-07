//
//  Input.swift
//  Food
//
//  Created by Mathias da Rosa on 06/08/25.
//

import SwiftUI

struct Input: View {
    @State var text: String
    var placeholder: String
    var label: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(label).font(.system(size: 16))
            TextField(placeholder, text: $text)
                .padding(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                      .stroke(lineWidth: 1)
                      .foregroundColor(.gray)
                )
        }.padding(EdgeInsets(top: 0.0, leading: 0.0, bottom: 4, trailing: 0.0))
    }
}

struct Input_Preview: PreviewProvider {
    @State static var text: String = ""
    
    static var previews: some View {
        VStack {
            Input(text: text, placeholder: "Placeholder", label: "Label")
        }.padding(0).border(.black)
    }
}


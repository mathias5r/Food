//
//  SeparatorView.swift
//  Food
//
//  Created by Mathias da Rosa on 13/07/25.
//

import SwiftUI

struct SeparatorView: View {
    var body: some View {
        Rectangle()
            .fill(.gray)
            .frame(height: 1)
            .frame(maxWidth: .infinity)
    }
}


//
//  RatingStarsView.swift
//  Food
//
//  Created by Mathias da Rosa on 13/07/25.
//

import SwiftUI

struct StarRatingView: View {
    var rating: Int // e.g. 3
    var maximumRating: Int = 5

    var body: some View {
        HStack(spacing: 4) {
            ForEach(1...maximumRating, id: \.self) { index in
                Image(systemName: index <= rating ? "star.fill" : "star")
                    .foregroundColor(.yellow)
            }
        }
    }
}

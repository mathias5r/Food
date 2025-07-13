//
//  RatingStars.swift
//  Food
//
//  Created by Mathias da Rosa on 11/06/25.
//

import UIKit

class RatingStars {
    
    private let filledStar: UIImage
    private let halfStar: UIImage
    private let emptyStart: UIImage
    
    private let count: Int

    init(count: Int = 5) {
        self.count = count
        let color = UIColor(red: 1.00, green: 0.74, blue: 0.18, alpha: 1.00)
        self.filledStar = UIImage(systemName: "star.fill")!.withTintColor(color, renderingMode: .alwaysOriginal)
        self.halfStar = UIImage(systemName: "star.leadinghalf.filled")!.withTintColor(color, renderingMode: .alwaysOriginal)
        self.emptyStart = UIImage(systemName: "star")!.withTintColor(color, renderingMode: .alwaysOriginal)
    }
    
    func getStars(for rating: Double) -> [UIImageView] {
        var stars: [UIImageView] = []
        var remainingRating = rating
        
        for _ in 0..<count {
            let imageView = UIImageView()
            imageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
            if remainingRating >= 1 {
                imageView.image = filledStar
                stars.append(imageView)
                remainingRating -= 1
            } else if remainingRating > 0 {
                imageView.image = halfStar
                stars.append(imageView)
            } else {
                imageView.image = emptyStart
                stars.append(imageView)
            }
        }
        
        return stars
    }
}

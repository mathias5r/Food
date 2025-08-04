//
//  UIImageViewExtension.swift
//  Food
//
//  Created by Mathias da Rosa on 11/06/25.
//

import UIKit

extension UIImageView {
    func load(from urlString: String) {
        
        let url = URL(string: urlString)
        guard let url = url else {
            print("Invalid image URL")
            return
        }
        
        DispatchQueue.global().async { [weak self] in
            do {
                let data = try Data(contentsOf: url)
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            } catch {
                print("Error loading image: \(error)")
            }
        }
    }
}

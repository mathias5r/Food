//
//  DetailsViewController.swift
//  Food
//
//  Created by Mathias da Rosa on 09/06/25.
//

import UIKit

class DetailsViewController: UIViewController {
    
    var restaurant: RestaurantModel?
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let name: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        view.backgroundColor = .white
        
        guard let restaurant = self.restaurant else {
            return
        }
    
        imageView.load(from: restaurant.image)
        view.addSubview(imageView)
        imageView.frame = CGRect(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.height * 0.3)
        imageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        name.text = restaurant.name
        view.addSubview(name)
        name.translatesAutoresizingMaskIntoConstraints = false
        name.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16).isActive = true
        name.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
 
    
    }
}

extension UIImageView {
    func load(from urlString: String) {
        
        let url = URL(string: urlString)
        guard let url = url else {
            print("Invalid image URL")
            return
        }
        
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

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
    
    let closeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    let name: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    let address: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textColor = .gray
        return label
    }()
    
    let cuisine: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .gray
        label.textAlignment = .right
        return label
    }()
    
    let separator: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view;
    }()
    
    let rating: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .gray
        return label
    }()
    
    let phoneButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "phone.fill"), for: .normal)
        button.tintColor = .blue
        return button
    }()
    
    let phone: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .gray
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
        
        view.addSubview(closeButton)
        closeButton.translatesAutoresizingMaskIntoConstraints = false;
        closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 16).isActive = true
        closeButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        closeButton.addTarget(self, action: #selector(self.onClose), for: .touchUpInside)
        
        name.text = restaurant.name
        view.addSubview(name)
        name.translatesAutoresizingMaskIntoConstraints = false
        name.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16).isActive = true
        name.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
 
        address.text = restaurant.address.toString()
        view.addSubview(address)
        address.translatesAutoresizingMaskIntoConstraints = false
        address.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 8).isActive = true
        address.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        address.rightAnchor.constraint(lessThanOrEqualTo: view.rightAnchor, constant: -16).isActive = true
        address.lineBreakMode = .byTruncatingTail
        address.adjustsFontSizeToFitWidth = true
        address.minimumScaleFactor = 0.7
        address.numberOfLines = 1
        
        cuisine.text = restaurant.cuisine
        view.addSubview(cuisine)
        cuisine.translatesAutoresizingMaskIntoConstraints = false
        cuisine.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16).isActive = true
        cuisine.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        
        view.addSubview(separator)
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        separator.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        separator.topAnchor.constraint(equalTo: address.bottomAnchor, constant: 16).isActive = true
        
        rating.text = "Rating:"
        view.addSubview(rating)
        rating.translatesAutoresizingMaskIntoConstraints = false
        rating.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 16).isActive = true
        rating.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        
        phone.text = "Phone: \(Phone.format(restaurant.phone))"
        view.addSubview(phone)
        phone.translatesAutoresizingMaskIntoConstraints = false
        phone.topAnchor.constraint(equalTo: rating.bottomAnchor, constant: 16).isActive = true
        phone.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        
        view.addSubview(phoneButton)
        phoneButton.translatesAutoresizingMaskIntoConstraints = false
        phoneButton.topAnchor.constraint(equalTo: rating.bottomAnchor, constant: 16).isActive = true
        phoneButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        phoneButton.addTarget(self, action: #selector(self.onCall), for: .touchUpInside)
        
        let ratingStars = RatingStars(count: 5)
        let stars = ratingStars.getStars(for: restaurant.rating)
        var startLeftOffeset = 8
        stars.forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 12).isActive = true
            $0.leftAnchor.constraint(equalTo: rating.rightAnchor, constant: CGFloat(startLeftOffeset)).isActive = true
            startLeftOffeset += 24
        }
    }
    
    @objc func onClose() {
        dismiss(animated: true)
    }
    
    @objc func onCall() {
        if let phone = restaurant?.phone {
            guard let url = URL(string: "tel://\(Phone.format(phone))") else { return }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

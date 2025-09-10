//
//  ViewController.swift
//  Food
//
//  Created by Mathias da Rosa on 13/03/25.
//

import UIKit
import MapKit
import Combine
import SwiftUI

class HomeViewController: UIViewController  {
    var safeAreaInsets: UIEdgeInsets?
    var isLoading: Bool = false
    var cancellables = Set<AnyCancellable>()
    var viewModel: HomeViewModelProtocol!
    var recentsHeightAnchor: NSLayoutConstraint?
    
    required init(viewModel: HomeViewModelProtocol) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // lazy is being used here to initialize mapView only once
    lazy var mapView: MKMapView = {
        let map = MKMapView()
        map.showsUserLocation = true
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    lazy var searchTextField: UITextField = {
        let searchTextField = UITextField()
        searchTextField.layer.cornerRadius = 16
        searchTextField.clipsToBounds = true // Subview are clippled by the bounds of view
        searchTextField.placeholder = "Search for Foods"
        searchTextField.backgroundColor = UIColor.white
        searchTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        searchTextField.leftViewMode = .always
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        
        return searchTextField
    }()
    
    lazy var recentsView: SelfSizingUITableView = {
        let tableView = SelfSizingUITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.cornerRadius = 16
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 48
        tableView.isHidden = true
        return tableView
    }()
    
    lazy var restaurantsView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.cornerRadius = 16
        return tableView
    }()
    
    lazy var loading: UIActivityIndicatorView = {
        let loading = UIActivityIndicatorView(style: .large)
        loading.translatesAutoresizingMaskIntoConstraints = false
        loading.hidesWhenStopped = true
        return loading
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // initialize view model
        viewModel.delegate = self
        
        // initialize search input
        searchTextField.delegate = self
        
        restaurantsView.delegate = self
        restaurantsView.dataSource = self
        restaurantsView.register(UITableViewCell.self, forCellReuseIdentifier: "locationCell")
        
        recentsView.delegate = self
        recentsView.dataSource = self
        recentsView.register(UITableViewCell.self, forCellReuseIdentifier: "recentCell")
        
        self._setEmptyTableView()
        
        searchTextField.textPublisher
          .receive(on: RunLoop.main)
          .debounce(for: 0.5, scheduler: DispatchQueue.main)
          .sink(receiveValue: { value in
              if let search = value {
                  if !search.isEmpty {
                      self.loading.startAnimating()
                      self.viewModel.searchFood(value ?? "", self.mapView.region)
                      self.recentsView.reloadData()
                  }
              }
          })
          .store(in: &cancellables)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        safeAreaInsets = view.safeAreaInsets
        setupUI();
    }
    
    private func setupUI() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissRecents))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    
        view.addSubview(mapView)
        
        mapView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        mapView.heightAnchor.constraint(equalToConstant: view.bounds.size.height/2).isActive = true
        mapView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        
        view.addSubview(searchTextField)
        
        searchTextField.heightAnchor.constraint(equalToConstant: 48).isActive = true
        searchTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        searchTextField.widthAnchor.constraint(equalToConstant: view.bounds.size.width/1.2).isActive = true
        searchTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 60).isActive = true
        searchTextField.returnKeyType = .go
        
        view.addSubview(recentsView)
        
        recentsView.tag = 1
        recentsView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        recentsView.widthAnchor.constraint(equalToConstant: view.bounds.size.width/1.2).isActive = true;
        recentsView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 16).isActive = true
        recentsView.separatorStyle = .none
        
        view.addSubview(restaurantsView)

        restaurantsView.tag = 2
        restaurantsView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true;
        restaurantsView.heightAnchor.constraint(equalToConstant: view.bounds.size.height / 2 + view.safeAreaInsets.top).isActive = true
        restaurantsView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        restaurantsView.separatorStyle = .none
        
        view.addSubview(loading)
        
        loading.centerXAnchor.constraint(equalTo: restaurantsView.centerXAnchor).isActive = true
        loading.centerYAnchor.constraint(equalTo: restaurantsView.centerYAnchor).isActive = true
    }
    
    @objc func dismissRecents() {
        self.view.endEditing(true)
    }
    
    func _setEmptyTableView() {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: restaurantsView.bounds.size.width, height: restaurantsView.bounds.size.height))
        messageLabel.text = "No Locations.\n Please, use the search input above!"
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.sizeToFit()
        restaurantsView.backgroundView = messageLabel
    }
}

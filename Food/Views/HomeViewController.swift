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

// MARK: - HomeViewController

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
    
    lazy var recentsView: UITableView = {
        let tableView = UITableView()
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
        
        self.setEmptyTableView()
        
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
    
    private func setEmptyTableView() {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: restaurantsView.bounds.size.width, height: restaurantsView.bounds.size.height))
        messageLabel.text = "No Locations.\n Please, use the search input above!"
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.sizeToFit()
        
        restaurantsView.backgroundView = messageLabel
    }
    
    private func setErrorTableView() {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: restaurantsView.bounds.size.width, height: restaurantsView.bounds.size.height))
        messageLabel.text = "Could not get restaurants.\n Please, try again later!"
        messageLabel.textColor = .red
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.sizeToFit()
        
        restaurantsView.backgroundView = messageLabel
    }
    
    private func setAnnotations(_ items: [RestaurantModel]) {
        self.mapView.removeAnnotations(self.mapView.annotations)
        for item in items {
            let coordinate = item.location;            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: coordinate.lat, longitude: coordinate.long)
            annotation.title = item.name
            self.mapView.addAnnotation(annotation)
        }
    }
    
    private func updateRecentsHeight(_ factor: Int) {
        self.recentsHeightAnchor?.isActive = false
        self.recentsHeightAnchor = recentsView.heightAnchor.constraint(equalToConstant: CGFloat(44 * ([factor, 3].min() ?? 0)))
        self.recentsHeightAnchor?.isActive = true
    }
}

// MARK: - Search TextFieldDelegate methods

extension HomeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let recents = viewModel.getRecents().count
        if recents > 0 {
            self.updateRecentsHeight(recents)
            self.recentsView.isHidden = false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.recentsView.isHidden = true
        }
    }
}

// MARK: - Restaurant TableViewDelegate methods

extension HomeViewController: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView.tag == 1 {
            return 1
        }
        
        let favoriteCount = viewModel.getFavorites().count
        if favoriteCount > 0 {
            return 2
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView.tag == 1) {
            if(viewModel.getRecents().count > 3) {
                return 3
            } else {
                return viewModel.getRecents().count
            }
        }
        
        let favorites = viewModel.getFavorites().count
        if favorites > 0 && section == 0 {
           return favorites
        }
        
        return viewModel.restaurants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(tableView.tag == 1) {
            let tableCell = tableView.dequeueReusableCell(withIdentifier: "recentCell")
            guard let cell = tableCell else { return UITableViewCell() }
            var content = cell.defaultContentConfiguration()
            content.text = viewModel.getRecents()[indexPath.row]
            content.image = UIImage(systemName: "clock")
            cell.contentConfiguration = content
            return cell
        }
        
        let tableCell = tableView.dequeueReusableCell(withIdentifier: "locationCell")
        guard let cell = tableCell else { return UITableViewCell() }
        var content = cell.defaultContentConfiguration()
        
        let favorites = viewModel.getFavorites()
        if(favorites.count > 0 && indexPath.section == 0){
            content.text = favorites[indexPath.row].name
            let address = favorites[indexPath.row].address
            let seecondaryText = address.toString()
            content.secondaryText = seecondaryText
            cell.contentConfiguration = content
            return cell
        }
        
        content.text = viewModel.restaurants[indexPath.row].name
        let address = viewModel.restaurants[indexPath.row].address
        let seecondaryText = address.toString()
        content.secondaryText = seecondaryText
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(tableView.tag == 1) {
            let searchString = viewModel.getRecents()[indexPath.row]
            viewModel.searchFood(searchString, self.mapView.region)
            self.recentsView.reloadData()
            self.searchTextField.text = searchString
            return
        }
        
        let favorites = viewModel.getFavorites()
        if(tableView.tag == 2 && indexPath.section == 0 && favorites.count > 0) {
            let selectedRestaurant = favorites[indexPath.row]
            let detailsView = DetailsFactory.view(restaurant: selectedRestaurant, onClose: {
                self.restaurantsView.reloadData()
                self.dismiss(animated: true)
            })
            let detailsController = UIHostingController(rootView: detailsView)
            present(detailsController, animated: true)
            return;
        }
        
        let selectedRestaurant = viewModel.restaurants[indexPath.row]
        let detailsView = DetailsFactory.view(restaurant: selectedRestaurant, onClose: {
            self.restaurantsView.reloadData()
            self.dismiss(animated: true)
        })
        let detailsController = UIHostingController(rootView: detailsView)
        present(detailsController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView.tag == 1 {
            return ""
        }
        
        let favorites = viewModel.getFavorites().count
        if favorites > 0 && section == 0 {
           return "Your favorite restaurants"
        }
        if favorites > 0 && section == 1 {
           return "Search results"
        }
        return ""
    }
}

extension HomeViewController: UITableViewDataSource {}

// MARK: - HomeViewDelegate Methods

extension HomeViewController: HomeViewModelDelegate {
    func didUpdateLocation(_ location: CLLocation) {
        let coords = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: coords, latitudinalMeters: 10000, longitudinalMeters: 10000)
        mapView.setRegion(region, animated: true)
    }
    
    func didChangeAuthorization(_ status: CLAuthorizationStatus) {
        switch status {
            case .authorizedAlways, .authorizedWhenInUse:
                print("location authorized")
            case .denied:
                print("location access denied")
            case .notDetermined, .restricted:
                print("location is not determined")
            default:
                print("status not recognized")
            }
        }
    
    func didSearchComplete(results: [RestaurantModel], error: Error?) {
        if(error != nil) {
            self.loading.stopAnimating()
            self.setErrorTableView()
            return
        }
        
        self.restaurantsView.backgroundView = nil
        self.restaurantsView.reloadData()
        self.loading.stopAnimating()
        
        if(results.count > 0) {
            setAnnotations(results)
        } else {
            self.setEmptyTableView()
        }
        
        let recents = viewModel.getRecents().count
        if(recents > 0) {
            self.updateRecentsHeight(recents)
            self.recentsView.reloadData()
        }
    }
}

//
//  ViewController.swift
//  Food
//
//  Created by Mathias da Rosa on 13/03/25.
//

import UIKit
import MapKit
import Combine

// TODO: apply MVVM to this controller

class ViewController: UIViewController {
    
    var locationManager: CLLocationManager?
    
    var locations: [MKMapItem] = []
    
    var safeAreaInsets: UIEdgeInsets?
    
    var isLoading: Bool = false
    
    var cancellables = Set<AnyCancellable>()
    
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
    
    lazy var tableView: UITableView = {
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
        
        // initialize search input
        searchTextField.delegate = self
        
        // initialize location manager
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.requestLocation()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "locationCell")
        
        searchTextField.textPublisher
          .receive(on: RunLoop.main)
          .sink(receiveValue: { value in
              if let search = value {
                  if !search.isEmpty {
                      self.loading.startAnimating()
                      self.searchFood(value ?? "")
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
        
        view.addSubview(tableView)

        tableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true;
        tableView.heightAnchor.constraint(equalToConstant: view.bounds.size.height / 2 + view.safeAreaInsets.top).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        setEmptyTableView()
        
        view.addSubview(loading)
        
        loading.centerXAnchor.constraint(equalTo: tableView.centerXAnchor).isActive = true
        loading.centerYAnchor.constraint(equalTo: tableView.centerYAnchor).isActive = true
    }
    
    private func checkLocationPermission() {
        guard let locationManager = locationManager,
              let location = locationManager.location else { return }
        
        switch locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            // How to center my location in the upper area of the phone?
            let coords = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: coords, latitudinalMeters: 1000, longitudinalMeters: 1000)
            mapView.setRegion(region, animated: true)
        case .denied:
            print("location access denied")
        case .notDetermined, .restricted:
            print("location is not determined")
        default:
            print("status not recognized")
        }
    }
    
    private func setEmptyTableView() {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
        messageLabel.text = "No Locations.\n Please, use the search input above!"
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.sizeToFit()
        
        tableView.backgroundView = messageLabel
    }
    
    private func searchFood(_ searchString: String) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = searchString
        searchRequest.region = mapView.region
        searchRequest.pointOfInterestFilter = .init(including: [.foodMarket, .restaurant])
        
        let search = MKLocalSearch(request: searchRequest)
        search.start { response, error in
            guard let response = response else {
                print("Error: \(error?.localizedDescription ?? "Unknown error").")
                return
            }
            
            if(response.mapItems.count > 0) {
                self.setAnnotations(response.mapItems)
                self.locations = response.mapItems
                self.tableView.backgroundView = nil
                self.tableView.reloadData()
                self.loading.stopAnimating()
            } else {
                self.setEmptyTableView()
            }
        }
    }
    
    private func setAnnotations(_ items: [MKMapItem]) {
        for item in items {
            let coordinate = item.placemark.coordinate
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = item.name
            self.mapView.addAnnotation(annotation)
        }
    }
}

// The extention permits to isolate the logic of an specific delegate interface
extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationPermission()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print(error)
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.resignFirstResponder()
        return true
    }
}

// TODO: separte delegate and source
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCell(withIdentifier: "locationCell")
        
        guard let cell = tableCell else { return UITableViewCell() }
        
        var content = cell.defaultContentConfiguration()
        content.text = locations[indexPath.row].name
        content.secondaryText = locations[indexPath.row].placemark.title
        cell.contentConfiguration = content

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let location = locations[indexPath.row]
        let locationCoordinates = location.placemark.coordinate
        let coords = CLLocationCoordinate2D(latitude:locationCoordinates.latitude, longitude: locationCoordinates.longitude)
        mapView.setCenter(coords, animated: true)
    }
}

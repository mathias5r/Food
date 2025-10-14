//
//  HomeView+ViewModelDelegate.swift
//  Food
//
//  Created by Mathias da Rosa on 28/08/25.
//

import Combine
import FoodDomain
import MapKit
import SwiftUI
import UIKit

extension HomeViewController: HomeViewModelDelegate {
    func didUpdateLocation(_ location: CLLocation) {
        let coords = CLLocationCoordinate2D(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude
        )
        let region = MKCoordinateRegion(
            center: coords,
            latitudinalMeters: 10000,
            longitudinalMeters: 10000
        )
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
        if error != nil {
            loading.stopAnimating()
            setErrorTableView()
            return
        }

        restaurantsView.backgroundView = nil
        restaurantsView.reloadData()
        loading.stopAnimating()

        if results.count > 0 {
            setAnnotations(results)
        } else {
            setEmptyTableView()
        }

        let recents = viewModel.getRecents().count
        if recents > 0 {
            recentsView.reloadData()
        }
    }

    func setAnnotations(_ items: [RestaurantModel]) {
        mapView.removeAnnotations(mapView.annotations)
        for item in items {
            let coordinate = item.location; let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(
                latitude: coordinate.lat,
                longitude: coordinate.long
            )
            annotation.title = item.name
            mapView.addAnnotation(annotation)
        }
    }

    func setErrorTableView() {
        let messageLabel = UILabel(
            frame: CGRect(
                x: 0,
                y: 0,
                width: restaurantsView.bounds.size.width,
                height: restaurantsView.bounds.size.height
            )
        )
        messageLabel.text = "Could not get restaurants.\n Please, try again later!"
        messageLabel.textColor = .red
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.sizeToFit()

        restaurantsView.backgroundView = messageLabel
    }
}

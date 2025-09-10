//
//  HomeView+Restaurants.swift
//  Food
//
//  Created by Mathias da Rosa on 28/08/25.
//

import UIKit
import SwiftUI

extension HomeViewController: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        if(tableView.tag == 2) {
            let favoriteCount = viewModel.getFavorites().count
            if favoriteCount > 0 {
                return 2
            }
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
        var address: AddressModel
        
        if(favorites.count > 0 && indexPath.section == 0){
            content.text = favorites[indexPath.row].name
            address = favorites[indexPath.row].address
        } else {
            content.text = viewModel.restaurants[indexPath.row].name
            address = viewModel.restaurants[indexPath.row].address
        }
        
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
        var selectedRestaurant: RestaurantModel
        
        if(tableView.tag == 2 && indexPath.section == 0 && favorites.count > 0) {
            selectedRestaurant = favorites[indexPath.row]
        } else {
            selectedRestaurant = viewModel.restaurants[indexPath.row]
        }
        
        let detailsView = DetailsFactory.view(restaurant: selectedRestaurant, onClose: {
            self.restaurantsView.reloadData()
            self.dismiss(animated: true)
        })
        let detailsController = UIHostingController(rootView: detailsView)
        present(detailsController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(tableView.tag == 2) {
            let favorites = viewModel.getFavorites().count
            if favorites > 0 && section == 0 {
               return "Your favorite restaurants"
            }
            if favorites > 0 && section == 1 {
               return "Search results"
            }
        }
        return ""
    }
}

extension HomeViewController: UITableViewDataSource {}

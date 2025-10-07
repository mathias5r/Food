//
//  HomeView+Search.swift
//  Food
//
//  Created by Mathias da Rosa on 28/08/25.
//

import UIKit

extension HomeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let recents = viewModel.getRecents().count
        if recents > 0 {
            self.recentsTopAnchor?.isActive = false
            self.recentsTopAnchor = self.recentsView.topAnchor.constraint(equalTo: self.searchTextField.bottomAnchor, constant: 16)
            self.recentsTopAnchor?.isActive = true
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.recentsTopAnchor?.isActive = false
            self.recentsTopAnchor = self.recentsView.topAnchor.constraint(equalTo: self.searchTextField.bottomAnchor, constant: -500)
            self.recentsTopAnchor?.isActive = true
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
}

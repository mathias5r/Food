//
//  Phone.swift
//  Food
//
//  Created by Mathias da Rosa on 13/07/25.
//

import Foundation
import UIKit

class Phone {
    static func format(_ phone: String) -> String {
        return phone.replacingOccurrences(of: "-", with: "", options: .literal, range: nil)
    }
    
    static func openDialler(_ phone: String) -> Void {
        guard let url = URL(string: "tel://\(Phone.format(phone))") else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

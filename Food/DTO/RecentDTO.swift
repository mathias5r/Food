//
//  RecentDTO.swift
//  Food
//
//  Created by Mathias da Rosa on 20/08/25.
//

import Foundation
import RealmSwift

class RecentDTO: Object {
    @Persisted var value: String
    @Persisted var date: Date = Date()
    
    convenience init(value: String) {
        self.init()
        self.value = value
    }
    
    public func toString() -> String {
        return self.value
    }
}

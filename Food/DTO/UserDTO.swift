//
//  ProfileDTO.swift
//  Food
//
//  Created by Mathias da Rosa on 20/08/25.
//

import Foundation
import RealmSwift

class UserDTO: Object {
    @Persisted(primaryKey: true) var _id = UUID().uuidString
    @Persisted private var name: String
    @Persisted private var lastname: String
    @Persisted private var email: String
    @Persisted private var createdAt: Date = Date()
    @Persisted private var updatedAt: Date = Date()
    
    convenience init(from user: UserModel) {
        self.init()
        self.name = user.name
        self.lastname = user.lastname
        self.email = user.email
    }
    
    public func update(from user: UserModel) {
        self.updatedAt = Date()
        self.name = user.name
        self.lastname = user.lastname
        self.email = user.email
    }
    
    public func toUser() -> UserModel {
        return UserModel(
            name: self.name,
            lastname: self.lastname,
            email: self.email
        )
    }
}

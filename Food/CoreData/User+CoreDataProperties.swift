//
//  User+CoreDataProperties.swift
//  Food
//
//  Created by Mathias da Rosa on 07/08/25.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var name: String
    @NSManaged public var lastname: String
    @NSManaged public var email: String
    @NSManaged public var id: UUID
    @NSManaged public var createdAt: Date
    @NSManaged public var updatedAt: Date

}

extension User : Identifiable {

}

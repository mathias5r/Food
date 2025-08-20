//
//  Recents+CoreDataProperties.swift
//  Food
//
//  Created by Mathias da Rosa on 11/08/25.
//
//

import Foundation
import CoreData


extension Recents {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Recents> {
        return NSFetchRequest<Recents>(entityName: "Recents")
    }

    @NSManaged public var list: [String]?

}

extension Recents : Identifiable {

}

//
//  RecentRepository.swift
//  Food
//
//  Created by Mathias da Rosa on 11/08/25.
//

import Foundation
import CoreData
import UIKit

class RecentRepository {
    func get() -> [String] {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {
            return []
        }
        
        let fetchRequest: NSFetchRequest<Recents> = Recents.fetchRequest()
        
        do {
            let existingRecords = try context.fetch(fetchRequest)
            
            if(existingRecords.count > 0) {
                let recents = existingRecords.first
                return recents?.list ?? []
            } else {
                print("No user was found")
                return []
            }
        } catch {
            print("Core Data get operation failed: \(error.localizedDescription)")
            return []
        }
    }
    
    func create(items: [String]) {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {
            return
        }
        
        let fetchRequest: NSFetchRequest<Recents> = Recents.fetchRequest()
        
        do {
            let existingRecords = try context.fetch(fetchRequest)
            
            if(existingRecords.count > 0) {
                if let recents = existingRecords.first {
                    let list = recents.list
                    let newList = items + (list ?? [])
                    var seenItems = Set<String>()
                    let uniqueList = newList.filter { seenItems.insert($0).inserted }
                    recents.list = uniqueList
                    try context.save()
                }
            } else {
                let recent = Recents(context: context)
                recent.list = items
                try context.save()
            }
        } catch {
            print("Core Data get operation failed: \(error.localizedDescription)")
        }
    }
}

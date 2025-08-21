//
//  RecentRepository.swift
//  Food
//
//  Created by Mathias da Rosa on 11/08/25.
//

import Foundation
import RealmSwift

protocol RecentRepositoryProtocal {
    func get() -> [String]
    func create(value: String)
}

class RecentRepository: RecentRepositoryProtocal {
    func get() -> [String] {
        do {
            let realm = try Realm()
            
            let recents = realm.objects(RecentDTO.self).sorted(byKeyPath: "date", ascending: false)
            
            if(recents.count > 0) {
                return recents.map { $0.toString() }
            } else {
                print("[RecentRepository]: No recent was found")
                return []
            }
        } catch {
            print("[RecentRepository]: get operation failed: \(error.localizedDescription)")
            return []
        }
    }
    
    func create(value: String) {
        do {
            let realm = try Realm()
            
            let recent = realm.objects(RecentDTO.self).filter("value == '\(value)'").first
            
            if let item = recent {
                try realm.write {
                    item.value = value
                    item.date = Date()
                }
            } else {
                let newRecent = RecentDTO(value: value)
                try realm.write {
                    realm.add(newRecent)
                }
            }
        } catch {
            print("[RecentRepository]: create operation failed: \(error.localizedDescription)")
        }
    }
}

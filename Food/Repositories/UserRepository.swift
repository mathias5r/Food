//
//  UserRepository.swift
//  Food
//
//  Created by Mathias da Rosa on 07/08/25.
//

import Foundation
import RealmSwift

protocol UserRepositoryProtocol {
    func get() -> UserModel?
    func create(from user: UserModel, completion: @escaping (Bool) -> Void)
    func delete(completion: @escaping (Bool) -> Void)
    func update(from user: UserModel, completion: @escaping (Bool) -> Void)
}

class UserRepository: UserRepositoryProtocol {
    
    func get() -> UserModel? {
        do {
            let realm = try Realm()
            
            let users = realm.objects(UserDTO.self)
            
            if(users.count > 0) {
                let user = users.first
                return user?.toUser()
            } else {
                print("No user was found")
                return nil
            }
        } catch {
            print("[UserRepository]: get operation failed: \(error.localizedDescription)")
            return nil
        }
    }
    
    
    func create(from user: UserModel, completion: @escaping (Bool) -> Void) {
        do {
            let realm = try! Realm()
            
            let item = UserDTO(from: user)
            
            try realm.write {
                realm.add(item)
            }
            
            completion(true)
         } catch {
             print("[UserRepository]: create operation failed: \(error.localizedDescription)")
             completion(false)
         }
    }
    
    func delete(completion: @escaping (Bool) -> Void) {
        do {
            let realm = try! Realm()
            
            let users = realm.objects(UserDTO.self)
            
            if(users.count > 0) {
                if let user = users.first {
                    try realm.write {
                        realm.delete(user)
                    }
                    completion(true)
                } else {
                    completion(false)
                }
            } else {
                print("[UserRepository]: No user was found")
                completion(false)
            }
        } catch {
            print("[UserRepository]: delete operation failed: \(error.localizedDescription)")
            completion(false)
        }
    }
    
    func update(from user: UserModel, completion: @escaping (Bool) -> Void) {
        do {
            let realm = try! Realm()
            
            let users = realm.objects(UserDTO.self)
            
             if(users.count > 0) {
                 if let item = users.first {
                     try realm.write {
                         item.update(from: user)
                     }
                     completion(true)
                 } else {
                     completion(false)
                 }
             } else {
                 print("[UserRepository]: No user was found")
                 completion(false)
             }
    
         } catch {
             print("[UserRepository]: update operation failed: \(error.localizedDescription)")
             completion(false)
         }
    }
    
}

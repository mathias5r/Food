//
//  UserRepository.swift
//  Food
//
//  Created by Mathias da Rosa on 07/08/25.
//

import Foundation
import CoreData
import UIKit

protocol UserRepositoryProtocol {
    func get() -> User?
    func create(name: String, lastname: String, email: String, completion: @escaping (Bool) -> Void)
    func delete(completion: @escaping (Bool) -> Void)
    func update(name: String?, lastname: String?, email: String?, completion: @escaping (Bool) -> Void)
}

class UserRepository: UserRepositoryProtocol {
    
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func get() -> User? {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        
        do {
            let existingRecords = try context.fetch(fetchRequest)
            
            if(existingRecords.count > 0) {
                let user = existingRecords.first
                return user
            } else {
                print("No user was found")
                return nil
            }
        } catch {
            print("Core Data get operation failed: \(error.localizedDescription)")
            return nil
        }
    }
    
    
    func create(name: String, lastname: String, email: String, completion: @escaping (Bool) -> Void) {
        do {
             let user = User(context: context)
             user.name = name
             user.lastname = lastname
             user.email = email
             user.id = UUID()
             user.createdAt = Date()
             user.updatedAt = Date()
             
             try context.save()
             completion(true)
         } catch {
             print("Core Data create operation failed: \(error.localizedDescription)")
             completion(false)
         }
    }
    
    func delete(completion: @escaping (Bool) -> Void) {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        
        do {
            let existingRecords = try context.fetch(fetchRequest)
            
            if(existingRecords.count > 0) {
                if let user = existingRecords.first {
                    context.delete(user)
                    completion(true)
                } else {
                    completion(false)
                }
            } else {
                print("No user was found")
                completion(false)
            }
        } catch {
            print("Core Data delete operation failed: \(error.localizedDescription)")
            completion(false)
        }
    }
    
    func update(name: String?, lastname: String?, email: String?, completion: @escaping (Bool) -> Void) {        
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        
        do {
            let existingRecords = try context.fetch(fetchRequest)
            
             if(existingRecords.count > 0) {
                 if let user = existingRecords.first {
                     if let userName = name {
                         user.name = userName
                     }
                     if let userLastname = lastname {
                         user.lastname = userLastname
                     }
                     if let userEmail = email {
                         user.email = userEmail
                     }
                     try context.save()
                     completion(true)
                 } else {
                     completion(false)
                 }
             } else {
                 print("No user was found")
                 completion(false)
             }
    
         } catch {
             print("Core Data update operation failed: \(error.localizedDescription)")
             completion(false)
         }
    }
    
}

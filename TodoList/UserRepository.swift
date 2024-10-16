//
//  UserRepository.swift
//  TodoList
//
//  Created by POYART Lucas on 16/10/2024.
//

import Foundation
import CoreData

class UserRepository {
    let context: NSManagedObjectContext
    
    init(_ controller: DataController) {
        self.context = controller.context
    }
    
    func create(_ username: String, _ password: String) -> User? {
        let user = User(context: context)
        
        user.id = UUID()
        user.username = username
        user.password = password
        
        do {
            try context.save()
            
            return user
        } catch {
            print("")
        }
        
        return nil
    }
        
    func getByName(_ username: String) -> User? {
        let request: NSFetchRequest<User> = User.fetchRequest()
        
        request.predicate = NSPredicate(format: "username == %@", username)
        
        do {
            let users = try context.fetch(request)
            
            if let user = users.first {
                return user
            }
        } catch {
            print("")
        }
        
        return nil
    }
}

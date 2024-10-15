//
//  DataContainer.swift
//  TodoList
//
//  Created by POYART Lucas on 15/10/2024.
//

import CoreData
import Foundation

typealias UserEntity = User

class DataController: ObservableObject {
    static var shared: DataController = .init()
        
    let container = NSPersistentContainer(name: "Storage")
    
    var viewContext: NSManagedObjectContext {
        return container.viewContext
    }
    
    private init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
    
    func createUser(_ name: String, _ password: String) -> User? {
        let user = User(context: viewContext)
        
        user.id = UUID()
        user.name = name
        user.password = password
        
        do {
            try viewContext.save()
            
            return user
        } catch {
            print("Impossible de créer un utilisateur")
            return nil
        }
    }
}

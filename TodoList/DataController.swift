//
//  DataContainer.swift
//  TodoList
//
//  Created by POYART Lucas on 15/10/2024.
//

import CoreData
import Foundation

class DataController {
    let container: NSPersistentContainer = .init(name: "Storage")
    
    var context: NSManagedObjectContext {
        return container.viewContext
    }
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
}

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
    static var shared = DataController()
        
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
    
//    func saveStudent(name: String) {
//        let registeredStudent = Student(context: viewContext)
//        registeredStudent.name = name
//        registeredStudent.id = UUID()
//
//        do {
//            try viewContext.save()
//        } catch {
//            print("Je n'ai pas réussi à sauvegarder les données: \(error)")
//        }
//    }
}

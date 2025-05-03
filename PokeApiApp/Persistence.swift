//
//  Persistence.swift
//  PokeApiApp
//
//  Created by Nahum Martinez on 29/4/25.
//
import CoreData
import Foundation

class PersistenceController: ObservableObject {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    var viewContext: NSManagedObjectContext {
           container.viewContext
       }
    
    //MARK: CONTEXT PARA TRABAJAR EN SEGUNDO PLANO
    var backgroundContext: NSManagedObjectContext {
           container.newBackgroundContext()
       }
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Pokemon")
        if inMemory {
            let description = NSPersistentStoreDescription()
            description.type = NSInMemoryStoreType
            container.persistentStoreDescriptions = [description]
        }

        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                print("Store load failed: \(error.localizedDescription), \(error.userInfo)")
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
    func saveContext() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

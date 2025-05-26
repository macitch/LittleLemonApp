/*
*  File: Persistence.swift
*  Project: LittleLemonApp
*  Author: macitch.(@https://www.github.com/macitch)
*  Created: on 23.05.2025.
*  Copyright (C) 2025. macitch.
*/

import CoreData
import Foundation

struct PersistenceController {
    
    static let shared = PersistenceController()
    static var preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)
        let viewContext = controller.container.viewContext

        for _ in 0..<10 {
            let dish = Dish(context: viewContext)
            dish.title = "Greek Salad"
            dish.descriptionDish = "The famous Greek salad of crispy lettuce, peppers, olives, our Chicago twist."
            dish.price = "10"
            dish.category = "starters"
            dish.image = "https://github.com/Meta-Mobile-Developer-PC/Working-With-Data-API/blob/main/images/greekSalad.jpg?raw=true"
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error saving preview data: \(nsError), \(nsError.userInfo)")
        }
        return controller
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "ExampleDatabase")

        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { description, error in
            if let error = error as NSError? {
    
                fatalError("Unresolved error loading persistent store \(description): \(error), \(error.userInfo)")
            }
        }

        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }

    func clear(entityName: String) throws {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        deleteRequest.resultType = .resultTypeObjectIDs

        let result = try container.persistentStoreCoordinator.execute(deleteRequest,
                                                                      with: container.viewContext) as? NSBatchDeleteResult

        if let objectIDs = result?.result as? [NSManagedObjectID] {
            let changes: [AnyHashable: Any] = [
                NSDeletedObjectsKey: objectIDs
            ]
            
            NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes,
                                                into: [container.viewContext])
        }
    }
}

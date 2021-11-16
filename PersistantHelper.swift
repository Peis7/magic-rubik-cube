//
//  PersistantHelper.swift
//  BudgetPro
//
//  Created by Pedro Luis Cabrera Acosta on 12/5/18.
//  Copyright © 2018 Pedro Luis Cabrera Acosta. All rights reserved.
//

import UIKit
import CoreData

class PersistanctHelper: NSObject {
    // MARK: - Core Data stack
    static var context:NSManagedObjectContext{
        return self.persistentContainer.viewContext
    }
    private override init(){}
    static var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "RubikCubePaint")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    static func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

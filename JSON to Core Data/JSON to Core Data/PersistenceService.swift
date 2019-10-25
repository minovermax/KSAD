//
//  PersistenceService.swift
//  JSON to Core Data
//
//  Created by 이성민 on 10/14/19.
//  Copyright © 2019 KSAD. All rights reserved.
//

import Foundation
import CoreData

class PersistenceService {
    
    private init() {}
    static let shared = PersistenceService()
    
    var context: NSManagedObjectContext { return persistentContainer.viewContext }
    
    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "JSON_to_Core_Data")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {

                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()



    func save () {
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

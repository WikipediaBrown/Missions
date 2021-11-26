//
//  MissionsPersistentContainer.swift
//  Missions
//
//  Created by nonplus on 11/21/21.
//

import CoreData

class PersistentContainer: NSPersistentContainer {
    
    override init(name: String, managedObjectModel model: NSManagedObjectModel) {
        super.init(name: name, managedObjectModel: model)
        loadPersistentStores { [weak self] desctiption, error in
            if let error = error {
                print(error.localizedDescription)
            }
            self?.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        }
    }
}

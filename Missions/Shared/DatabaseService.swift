//
//  DatabaseService.swift
//  Missions
//
//  Created by nonplus on 11/19/21.
//

import Combine
import CoreData
import UIKit

protocol DatabaseServicing {
    var context: NSManagedObjectContext { get }
    
    func getFetchedResultsController(from request: NSFetchRequest<NSFetchRequestResult>, sectionNameKeyPath: String?) -> CurrentValueSubject<[NSFetchRequestResult], Error>
    func save() throws
    func deleteData() throws
    func delete(fetchRequest: NSFetchRequest<NSFetchRequestResult>) throws
    func delete(object: NSManagedObject) throws
}

class DatabaseService: NSObject, DatabaseServicing {
    
    let context: NSManagedObjectContext
    let managedObjectModel: NSManagedObjectModel
    
    private var subjectDictionary: [NSFetchedResultsController<NSFetchRequestResult>: CurrentValueSubject<[NSFetchRequestResult], Error>] = [:]

    init(context: NSManagedObjectContext, managedObjectModel: NSManagedObjectModel) {
        self.managedObjectModel = managedObjectModel
        self.context = context
    }
    
    // MARK: - DatabaseServicing

    func save() throws {
        try context.save()
    }
    
    func delete(fetchRequest: NSFetchRequest<NSFetchRequestResult>) throws {
        let objects = try context.fetch(fetchRequest).compactMap { $0 as? NSManagedObject }
        objects.forEach { context.delete($0) }
        try save()
    }
    
    func delete(object: NSManagedObject) throws {
        context.delete(object)
        try save()
    }
        
    func getFetchedResultsController(from request: NSFetchRequest<NSFetchRequestResult>, sectionNameKeyPath: String?) -> CurrentValueSubject<[NSFetchRequestResult], Error> {
        let subject =  CurrentValueSubject<[NSFetchRequestResult], Error>([])
        let controller = NSFetchedResultsController(fetchRequest: request,
                                                    managedObjectContext: context,
                                                    sectionNameKeyPath: sectionNameKeyPath,
                                                    cacheName: nil)
        controller.delegate = self
        
        subjectDictionary[controller] = subject
        
        do {
            try controller.performFetch()
            subject.send(controller.fetchedObjects ?? [])
        } catch let error {
            subject.send(completion: .failure(error))
        }
        
        return subject
    }
    
    func removeFetchedResultsController(with subject: CurrentValueSubject<[NSFetchRequestResult], Error>) {
        subjectDictionary = subjectDictionary.filter {$0.value === subject}
    }
    
    
    func deleteData() throws {
        let entities = managedObjectModel.entities
        try entities.compactMap({ $0.name }).forEach(clearDeepObjectEntity)
    }

    private func clearDeepObjectEntity(_ entity: String) throws {
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)

        try context.execute(deleteRequest)
        try context.save()
    }
    
}

extension DatabaseService: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        subjectDictionary[controller]?.send(controller.fetchedObjects ?? [])
    }
    
}

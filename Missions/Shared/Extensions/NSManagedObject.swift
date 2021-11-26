//
//  NSManagedObject.swift
//  Missions
//
//  Created by nonplus on 11/19/21.
//

import CoreData

extension NSManagedObject {
    
    // MARK: - Static Variables
    
    /// This is used to get the `NSFetchRequest` after changes to the CoreData API that made overriding the `fetchRequest` method cause a build issue.
    static var fetchRequest: NSFetchRequest<NSFetchRequestResult> { NSFetchRequest<NSFetchRequestResult>(entityName: typeName) }
    /// This is used to get the string name describing this type.
    static var typeName: String { String(describing: self) }
    
}

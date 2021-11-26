//
//  MissionObjective.swift
//  Missions
//
//  Created by nonplus on 11/25/21.
//

import CoreData

@objc(MissionObjective)
class MissionObjective: NSManagedObject, Identifiable {
    
    //  MARK: - Properties

    @NSManaged var content: String
    @NSManaged var creationDate: Date
    @NSManaged var uuid: UUID
    @NSManaged var mission: Mission?
    @NSManaged var objectives: NSSet
}

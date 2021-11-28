//
//  Mission.swift
//  Missions
//
//  Created by nonplus on 11/19/21.
//

import CoreData

@objc(Mission)
class Mission: NSManagedObject, Identifiable {
    
    // MARK: - Properties
    
    @NSManaged var title: String
    @NSManaged var summary: String
    @NSManaged var creationDate: Date
    @NSManaged var imageData: Data
    @NSManaged var lastUpdatedDate: Date
    @NSManaged var missionState: MissionState
    @NSManaged var uuid: UUID
    @NSManaged var objectives: NSMutableOrderedSet 
}

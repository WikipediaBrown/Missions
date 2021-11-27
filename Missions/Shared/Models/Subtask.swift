//
//  Subtask.swift
//  Missions
//
//  Created by nonplus on 11/25/21.
//

import CoreData

@objc(Subtask)
class Subtask: NSManagedObject, Identifiable {

    //  MARK: - Properties
    
    @NSManaged var missionObjective: MissionObjective?
    @NSManaged var text: String
    @NSManaged var uuid: UUID
}

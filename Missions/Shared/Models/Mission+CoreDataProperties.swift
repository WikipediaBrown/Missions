////
////  Mission+CoreDataProperties.swift
////  Missions
////
////  Created by nonplus on 11/24/21.
////
////
//
//import Foundation
//import CoreData
//
//
//extension Mission {
//
//    @nonobjc public class func fetchRequest() -> NSFetchRequest<Mission> {
//        return NSFetchRequest<Mission>(entityName: "Mission")
//    }
//
//    @NSManaged public var creationDate: Date?
//    @NSManaged public var imageData: Data?
//    @NSManaged public var lastUpdatedDate: Date?
//    @NSManaged public var missionState: Int16
//    @NSManaged public var name: String?
//    @NSManaged public var uuid: UUID?
//    @NSManaged public var objectives: NSSet?
//
//}
//
//// MARK: Generated accessors for objectives
//extension Mission {
//
//    @objc(addObjectivesObject:)
//    @NSManaged public func addToObjectives(_ value: MissionObjective)
//
//    @objc(removeObjectivesObject:)
//    @NSManaged public func removeFromObjectives(_ value: MissionObjective)
//
//    @objc(addObjectives:)
//    @NSManaged public func addToObjectives(_ values: NSSet)
//
//    @objc(removeObjectives:)
//    @NSManaged public func removeFromObjectives(_ values: NSSet)
//
//}
//
//extension Mission : Identifiable {
//
//}

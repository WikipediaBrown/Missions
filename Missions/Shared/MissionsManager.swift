//
//  MissionsManager.swift
//  Missions
//
//  Created by nonplus on 11/19/21.
//

import Foundation
import Combine
import CoreData

// MARK: - MissionsManaging

protocol MissionsManaging {
    var missionPublishers: [MissionState: AnyPublisher<[Mission], Error>] { get }
    
    func create(name: String) throws
    func read(uuid: UUID) -> AnyPublisher<Mission, Error>
    func update() throws
    func delete(uuid: UUID) -> AnyPublisher<(), Error>
}

// MARK: - MissionsManager

class MissionsManager: MissionsManaging {
    
    // MARK: - Public Constants

    let missionPublishers: [MissionState: AnyPublisher<[Mission], Error>]
        
    // MARK: - Private Constants

    private let databaseService: DatabaseServicing
    
    // MARK: - Initialization

    init(databaseService: DatabaseServicing) {
        var publishers: [MissionState: AnyPublisher<[Mission], Error>] = [:]
        
        for state in MissionState.allCases {
            let request = MissionsManager.currentMissionsRequest(missionState: state)
            
            let publisher = databaseService
                .getFetchedResultsController(from: request, sectionNameKeyPath: nil)
                .compactMap { $0 as? [Mission] }
                .eraseToAnyPublisher()
            publishers[state] = publisher
        }
        
        self.databaseService = databaseService
        self.missionPublishers = publishers
    }
    
    // MARK: - Public Methods
    
    func create(name: String) throws {
        guard let entity = NSEntityDescription.entity(forEntityName: Mission.typeName, in: databaseService.context)
        else { throw CoreDataError.entityDescriptionError }
    
        let mission = Mission.init(entity: entity, insertInto: databaseService.context)
        mission.name = name
        mission.uuid = UUID()
        mission.creationDate = Date()
        mission.lastUpdatedDate = Date()
        mission.missionState = .backlog
        mission.imageData = Data()
        
        try databaseService.save()
    }
    
    func read(uuid: UUID) -> AnyPublisher<Mission, Error> {
        let predicate = NSPredicate(format: "%K == %@", #keyPath(Mission.uuid), uuid as NSUUID)
        let request = MissionsManager.missionsRequest(predicate: predicate)
        return databaseService
            .getFetchedResultsController(from: request, sectionNameKeyPath: nil)
            .compactMap { $0.first as? Mission }
            .eraseToAnyPublisher()
    }
    
    func update() throws {
        try databaseService.save()
    }
    
    func delete(uuid: UUID) -> AnyPublisher<(), Error> {
        read(uuid: uuid)
            .tryMap {
                try self.databaseService.delete(object: $0)
            }
            .eraseToAnyPublisher()
    }

    // MARK: - Static Methods
    
    static func missionsRequest(predicate: NSPredicate? = nil) -> NSFetchRequest<NSFetchRequestResult> {
        let request = Mission.fetchRequest
        request.sortDescriptors = [NSSortDescriptor(key: "lastUpdatedDate", ascending: true)]
        request.predicate = predicate
        return request
    }

    static func currentMissionsRequest(missionState: MissionState) -> NSFetchRequest<NSFetchRequestResult> {
        let request = Mission.fetchRequest
        request.sortDescriptors = [NSSortDescriptor(key: "lastUpdatedDate", ascending: true)]
        request.predicate = NSPredicate(format: "missionState == %d", missionState.rawValue)
        return request
    }
}

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
    
    func create(title: String, summary: String, objectives: [AddObjectiveView.ViewModel]) throws
    func readMission(uuid: UUID) -> AnyPublisher<Mission, Error>
    func readMissionObjective(uuid: UUID) -> AnyPublisher<MissionObjective, Error>
    func readSubtask(uuid: UUID) -> AnyPublisher<Subtask, Error>
    func update() throws
    func deleteMission(uuid: UUID) -> AnyPublisher<(), Error>
    func deleteMissionObjective(uuid: UUID) -> AnyPublisher<(), Error>
    func deleteSubtask(uuid: UUID) -> AnyPublisher<(), Error>
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
            let request = MissionsManager.currentMissionsQuery(missionState: state)
            
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
    
    func create(title: String, summary: String, objectives: [AddObjectiveView.ViewModel]) throws {
        guard let entity = NSEntityDescription.entity(forEntityName: Mission.typeName, in: databaseService.context)
        else { throw CoreDataError.entityDescriptionError }
    
        let mission = Mission.init(entity: entity, insertInto: databaseService.context)
        mission.title = title
        mission.summary = summary
        mission.objectives = toObjectives(mission: mission, objectives: objectives)

        mission.uuid = UUID()
        mission.creationDate = Date()
        mission.lastUpdatedDate = Date()
        mission.missionState = .backlog
        mission.imageData = Data()
        
        try databaseService.save()
    }
    
    func readMission(uuid: UUID) -> AnyPublisher<Mission, Error> {
        let predicate = NSPredicate(format: "%K == %@", #keyPath(Mission.uuid), uuid as NSUUID)
        let request = MissionsManager.missionsQuery(predicate: predicate)
        return databaseService
            .getFetchedResultsController(from: request, sectionNameKeyPath: nil)
            .compactMap { $0.first as? Mission }
            .eraseToAnyPublisher()
    }
    
    func readMissionObjective(uuid: UUID) -> AnyPublisher<MissionObjective, Error> {
        let request = MissionObjective.fetchRequest
        request.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(MissionObjective.uuid), uuid as NSUUID)
        
        return databaseService
            .getFetchedResultsController(from: request, sectionNameKeyPath: nil)
            .compactMap { $0.first as? MissionObjective }
            .eraseToAnyPublisher()
    }
    
    func readSubtask(uuid: UUID) -> AnyPublisher<Subtask, Error> {
        let request = Subtask.fetchRequest
        request.sortDescriptors = [NSSortDescriptor(key: "text", ascending: true)]
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(Subtask.uuid), uuid as NSUUID)
        return databaseService
            .getFetchedResultsController(from: request, sectionNameKeyPath: nil)
            .compactMap { $0.first as? Subtask }
            .eraseToAnyPublisher()
    }
    
    func update() throws {
        try databaseService.save()
    }
    
    func deleteMission(uuid: UUID) -> AnyPublisher<(), Error> {
        readMission(uuid: uuid)
            .tryMap {
                try self.databaseService.delete(object: $0)
            }
            .eraseToAnyPublisher()
    }
    
    func deleteMissionObjective(uuid: UUID) -> AnyPublisher<(), Error> {
        readMissionObjective(uuid: uuid)
            .tryMap {
                try self.databaseService.delete(object: $0)
            }
            .eraseToAnyPublisher()
    }
    
    func deleteSubtask(uuid: UUID) -> AnyPublisher<(), Error> {
        readSubtask(uuid: uuid)
            .tryMap {
                try self.databaseService.delete(object: $0)
            }
            .eraseToAnyPublisher()
    }
    
    // MARK: - Private Methods

    private func toObjectives(mission: Mission, objectives: [AddObjectiveView.ViewModel]) -> NSMutableOrderedSet {
        let models = objectives.compactMap { viewModel -> MissionObjective? in
            guard let entity = NSEntityDescription.entity(forEntityName: MissionObjective.typeName, in: databaseService.context)
            else { return nil }
            
            let objective = MissionObjective(entity: entity, insertInto: databaseService.context)
            objective.content = viewModel.title
            objective.subtasks = toSubtasks(objective: objective, subtasks: viewModel.subtasks)
            objective.creationDate = Date()
            objective.scheduledDate = viewModel.date
            objective.mission = mission
            objective.uuid = UUID()
            return objective
        }
        return NSMutableOrderedSet(array: models)
    }
    
    private func toSubtasks(objective: MissionObjective, subtasks: [String]) -> NSMutableOrderedSet {
        let models = subtasks.compactMap { string -> Subtask? in
            guard let entity = NSEntityDescription.entity(forEntityName: Subtask.typeName, in: databaseService.context)
            else { return nil }
            
            let subtask = Subtask(entity: entity, insertInto: databaseService.context)
            subtask.text = string
            subtask.missionObjective = objective
            subtask.uuid = UUID()
            return subtask
        }
        return NSMutableOrderedSet(array: models)
    }

    
    // MARK: - Static Methods
    
    static func missionsQuery(predicate: NSPredicate? = nil) -> NSFetchRequest<NSFetchRequestResult> {
        let request = Mission.fetchRequest
        request.sortDescriptors = [NSSortDescriptor(key: "lastUpdatedDate", ascending: false)]
        request.predicate = predicate
        return request
    }

    static func currentMissionsQuery(missionState: MissionState) -> NSFetchRequest<NSFetchRequestResult> {
        let request = Mission.fetchRequest
        request.sortDescriptors = [NSSortDescriptor(key: "lastUpdatedDate", ascending: false)]
        request.predicate = NSPredicate(format: "missionState == %d", missionState.rawValue)
        return request
    }
    
}

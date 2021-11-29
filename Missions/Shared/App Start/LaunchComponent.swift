//
//  LaunchComponent.swift
//  Missions
//
//  Created by nonplus on 7/20/21.
//

import UIKit
import napkin
import CoreData

class LaunchComponent: Component<EmptyDependency>, MissionListDependency {
    
    let databaseService: DatabaseServicing
    let missionManager: MissionsManaging

    init(with presentingWindow: UIWindow) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
        else { fatalError("Cannot reference App Delegate")}
        
        let context = appDelegate.managedObjectContext
        let model = appDelegate.managedObjectModel
        
        databaseService = DatabaseService(context: context, managedObjectModel: model)
        missionManager = MissionsManager(databaseService: databaseService)
        
        super.init(dependency: EmptyComponent())
    }
}

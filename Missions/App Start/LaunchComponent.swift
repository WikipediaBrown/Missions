//
//  LaunchComponent.swift
//  Missions
//
//  Created by nonplus on 7/20/21.
//

import CoreData
import Firebase
import napkin
import UIKit

class LaunchComponent: Component<EmptyDependency>, MissionListDependency {
    
    let authenticationManager: AuthenticationManaging
    let databaseService: DatabaseServicing
    let missionManager: MissionsManaging
    let window: UIWindow

    init(with presentingWindow: UIWindow) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
        else { fatalError("Cannot reference App Delegate")}
        
        FirebaseApp.configure()
        
        let context = appDelegate.managedObjectContext
        let model = appDelegate.managedObjectModel
        
        authenticationManager = AuthenticationManager(window: presentingWindow)
        databaseService = DatabaseService(context: context, managedObjectModel: model)
        missionManager = MissionsManager(databaseService: databaseService)
        window = presentingWindow
        
        super.init(dependency: EmptyComponent())
    }
}

//
//  AddMissionBuilder.swift
//  Missions
//
//  Created by nonplus on 7/20/21.
//

import napkin

protocol AddMissionDependency: Dependency {
    var missionManager: MissionsManaging { get }
}

final class AddMissionComponent: Component<AddMissionDependency> {
    var missionManager: MissionsManaging { dependency.missionManager }
}

// MARK: - Builder

protocol AddMissionBuildable: Buildable {
    func build(withListener listener: AddMissionListener) -> AddMissionRouting
}

final class AddMissionBuilder: Builder<AddMissionDependency>, AddMissionBuildable {

    override init(dependency: AddMissionDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: AddMissionListener) -> AddMissionRouting {
        let component = AddMissionComponent(dependency: dependency)
        let viewController = AddMissionViewController()
        let interactor = AddMissionInteractor(presenter: viewController, missionManager: component.missionManager)
        interactor.listener = listener
        return AddMissionRouter(interactor: interactor, viewController: viewController)
    }
}

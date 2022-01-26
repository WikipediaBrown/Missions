//
//  MissionListBuilder.swift
//  Missions
//
//  Created by nonplus on 7/20/21.
//

import napkin

protocol MissionListDependency: Dependency {
    var authenticationManager: AuthenticationManaging { get }
    var missionManager: MissionsManaging { get }
}

final class MissionListComponent: Component<MissionListDependency>, AddMissionDependency {
    var authenticationManager: AuthenticationManaging { dependency.authenticationManager }
    var missionManager: MissionsManaging { dependency.missionManager }
}

// MARK: - Builder

protocol MissionListBuildable: Buildable {
    func build(withListener listener: MissionListListener) -> MissionListRouting
}

final class MissionListBuilder: Builder<MissionListDependency>, MissionListBuildable {

    override init(dependency: MissionListDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: MissionListListener) -> MissionListRouting {
        let component = MissionListComponent(dependency: dependency)
        let viewController = MissionListViewController()
        let interactor = MissionListInteractor(presenter: viewController,
                                               authenticationManager: component.authenticationManager,
                                               missionManager: component.missionManager)
        interactor.listener = listener
        return MissionListRouter(interactor: interactor, viewController: viewController, component: component)
    }
}

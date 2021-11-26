//
//  MissionListRouter.swift
//  Missions
//
//  Created by nonplus on 7/20/21.
//

import napkin
import UIKit

protocol MissionListInteractable: Interactable {
    var router: MissionListRouting? { get set }
    var listener: MissionListListener? { get set }
}

protocol MissionListViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
    func presentAddMission(viewController: UIViewController)
    func dismissAddMission()
}

final class MissionListRouter: LaunchRouter<MissionListInteractable, MissionListViewControllable>, MissionListRouting {

    private let component: MissionListComponent
    // TODO: Constructor inject child builder protocols to allow building children.
    init(interactor: MissionListInteractable, viewController: MissionListViewControllable, component: MissionListComponent) {
        self.component = component
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func routeToAddMission(with listener: AddMissionListener) {
        routeFromEverything()
        let router = AddMissionBuilder(dependency: component).build(withListener: listener)
        viewController.presentAddMission(viewController: router.viewControllable.uiviewController)
        attachChild(router)
    }
    
    func routeFromAddMission() {
        routeFromEverything()
    }
    
    private func routeFromEverything() {
        children.forEach { detachChild($0) }
        viewController.dismissAddMission()
    }
}

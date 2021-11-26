//
//  AddMissionRouter.swift
//  Missions
//
//  Created by nonplus on 7/20/21.
//

import napkin

protocol AddMissionInteractable: Interactable {
    var router: AddMissionRouting? { get set }
    var listener: AddMissionListener? { get set }
}

protocol AddMissionViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class AddMissionRouter: ViewableRouter<AddMissionInteractable, AddMissionViewControllable>, AddMissionRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: AddMissionInteractable, viewController: AddMissionViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}

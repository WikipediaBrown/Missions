//
//  AddMissionInteractor.swift
//  Missions
//
//  Created by nonplus on 7/20/21.
//

import napkin
import Combine

protocol AddMissionRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol AddMissionPresentable: Presentable, ErrorHandling {
    var listener: AddMissionPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol AddMissionListener: AnyObject {
    func endAddMission()
}

final class AddMissionInteractor: PresentableInteractor<AddMissionPresentable>, AddMissionInteractable, AddMissionPresentableListener {

    weak var router: AddMissionRouting?
    weak var listener: AddMissionListener?

    private let missionManager: MissionsManaging
    
    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(presenter: AddMissionPresentable, missionManager: MissionsManaging) {
        self.missionManager = missionManager
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func onAddMission(title: String, summary: String, objectives: [AddObjectiveView.ViewModel]) {
        do {
            try missionManager.create(title: title, summary: summary, objectives: objectives)
            listener?.endAddMission()
        } catch let error {
            presenter.presentError(error: error)
        }
    }
    
    func onDismissAddMission() {
        listener?.endAddMission()
    }
}

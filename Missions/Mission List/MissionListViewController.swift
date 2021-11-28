//
//  MissionListViewController.swift
//  Missions
//
//  Created by nonplus on 7/20/21.
//

import napkin
import Combine
import SwiftUI

protocol MissionListPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
    func onAddMission()
    func onDeleteMission(uuid: UUID)
    func onDeleteMissionObjective(uuid: UUID)
    func onDeleteSubtask(uuid: UUID)
    func onUpdateMission(mission: Mission)
    func onSave()
}

final class MissionListViewController: UIHostingController<MissionListView>, MissionListPresentable, MissionListViewControllable {

    let currentMissions = PassthroughSubject<[Mission], Never>()
    let backlogMissions = PassthroughSubject<[Mission], Never>()
    let startedMissions = PassthroughSubject<[Mission], Never>()
    let completeMissions = PassthroughSubject<[Mission], Never>()
    let removedMissions = PassthroughSubject<[Mission], Never>()
    
    weak var listener: MissionListPresentableListener?
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        super.init(rootView: MissionListView())
        
        rootView
            .tapSubject
            .sink { [weak self] tap in
                switch tap {
                case .addMission: self?.listener?.onAddMission()
                case .deleteMission(uuid: let uuid): self?.listener?.onDeleteMission(uuid: uuid)
                case .update(mission: let mission): self?.listener?.onUpdateMission(mission: mission)
                case .deleteMissionObjective(uuid: let uuid): self?.listener?.onDeleteMissionObjective(uuid: uuid)
                case .deleteSubtask(uuid: let uuid): self?.listener?.onDeleteSubtask(uuid: uuid)
                case .save: self?.listener?.onSave()
                }
            }
            .store(in: &cancellables)
        
        currentMissions
            .receive(on: DispatchQueue.main)
            .assign(to: \.viewModel.currentMissions, on: rootView)
            .store(in:&cancellables)
        
        backlogMissions
            .receive(on: DispatchQueue.main)
            .assign(to: \.viewModel.backlogMissions, on: rootView)
            .store(in:&cancellables)
        
        startedMissions
            .receive(on: DispatchQueue.main)
            .assign(to: \.viewModel.startedMissions, on: rootView)
            .store(in:&cancellables)
        
        completeMissions
            .receive(on: DispatchQueue.main)
            .assign(to: \.viewModel.completeMissions, on: rootView)
            .store(in:&cancellables)
        
        removedMissions
            .receive(on: DispatchQueue.main)
            .assign(to: \.viewModel.removedMissions, on: rootView)
            .store(in:&cancellables)
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    
    
    // MARK: - MissionListViewControllable
    
    func presentAddMission(viewController: UIViewController) {
        present(viewController, animated: true)
    }
    
    func dismissAddMission() {
        children.forEach { $0.dismiss(animated: true) }
    }
}

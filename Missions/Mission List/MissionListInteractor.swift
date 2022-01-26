//
//  MissionListInteractor.swift
//  Missions
//
//  Created by nonplus on 7/20/21.
//

import Combine
import FirebaseAuth
import napkin

protocol MissionListRouting: LaunchRouting {
    func routeToAddMission(with listener: AddMissionListener)
    func routeFromAddMission()
}

protocol MissionListPresentable: Presentable, ErrorHandling {
    var listener: MissionListPresentableListener? { get set }
    var currentMissions: PassthroughSubject<[Mission], Never> { get }
    var backlogMissions: PassthroughSubject<[Mission], Never> { get }
    var startedMissions: PassthroughSubject<[Mission], Never> { get }
    var completeMissions: PassthroughSubject<[Mission], Never> { get }
    var removedMissions: PassthroughSubject<[Mission], Never> { get }
    var user: PassthroughSubject<User?, Never> { get }
}

protocol MissionListListener: AnyObject {
}

final class MissionListInteractor: PresentableInteractor<MissionListPresentable>, MissionListInteractable {
    
    weak var router: MissionListRouting?
    weak var listener: MissionListListener?
    
    private let authenticationManager: AuthenticationManaging
    private let missionManager: MissionsManaging

    private var cancellables: Set<AnyCancellable> = []

    init(presenter: MissionListPresentable, authenticationManager: AuthenticationManaging, missionManager: MissionsManaging) {
        self.authenticationManager = authenticationManager
        self.missionManager = missionManager
        super.init(presenter: presenter)
        presenter.listener = self
        
//        self.setupMissionLists(missionManager: missionManager)
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        setupMissionLists(missionManager: missionManager)
        
        authenticationManager
            .userSubject
            .catch { [weak self] error -> Just<User?> in
                self?.presenter.presentError(error: error)
                return Just(nil)
            }
            .subscribe(presenter.user)
            .store(in: &cancellables)
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    // MARK: - Private Methods
    
    private func setupMissionLists(missionManager: MissionsManaging) {
        missionManager
            .missionPublishers[.current]?
            .catch { [weak self] error -> Just<[Mission]> in
                self?.presenter.presentError(error: error)
                return Just([])
            }
            .subscribe(presenter.currentMissions)
            .store(in: &cancellables)
        
        missionManager
            .missionPublishers[.backlog]?
            .catch { [weak self] error -> Just<[Mission]> in
                self?.presenter.presentError(error: error)
                return Just([])
            }
            .subscribe(presenter.backlogMissions)
            .store(in: &cancellables)
        
        missionManager
            .missionPublishers[.started]?
            .catch { [weak self] error -> Just<[Mission]> in
                self?.presenter.presentError(error: error)
                return Just([])
            }
            .subscribe(presenter.startedMissions)
            .store(in: &cancellables)
        
        missionManager
            .missionPublishers[.complete]?
            .catch { [weak self] error -> Just<[Mission]> in
                self?.presenter.presentError(error: error)
                return Just([])
            }
            .subscribe(presenter.completeMissions)
            .store(in: &cancellables)
        
        missionManager
            .missionPublishers[.removed]?
            .catch { [weak self] error -> Just<[Mission]> in
                self?.presenter.presentError(error: error)
                return Just([])
            }
            .subscribe(presenter.removedMissions)
            .store(in: &cancellables)
    }
}

extension MissionListInteractor: AddMissionListener {
    func endAddMission() {
        router?.routeFromAddMission()
    }
}

extension MissionListInteractor: MissionListPresentableListener {
    func onAddMission() {
        router?.routeToAddMission(with: self)
    }
    
    func onDeleteMission(uuid: UUID) {
        missionManager.deleteMission(uuid: uuid)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error): self.presenter.presentError(error: error)
                    case .finished: break
                    }
                },
                receiveValue: {}
            )
            .store(in: &cancellables)
    }
    
    func onDeleteMissionObjective(uuid: UUID) {
        missionManager.deleteMissionObjective(uuid: uuid)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error): self.presenter.presentError(error: error)
                    case .finished: break
                    }
                },
                receiveValue: {}
            )
            .store(in: &cancellables)
    }
    
    func onDeleteSubtask(uuid: UUID) {
        missionManager.deleteSubtask(uuid: uuid)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error): self.presenter.presentError(error: error)
                    case .finished: break
                    }
                },
                receiveValue: {}
            )
            .store(in: &cancellables)
    }
    
    func onUpdateMission(mission: Mission) {
        do {
            try missionManager.update()
            self.setupMissionLists(missionManager: missionManager)
        } catch let error {
            presenter.presentError(error: error)
        }
    }
    
    func onSave() {
        do {
            try missionManager.update()
            self.setupMissionLists(missionManager: missionManager)
        } catch let error {
            presenter.presentError(error: error)
        }
    }
    
    // MARK: - Authentication
    
    func onSignIn() {
        authenticationManager.signIn()
    }
    
    func onSignOut() {
        authenticationManager.signOut()
    }
}

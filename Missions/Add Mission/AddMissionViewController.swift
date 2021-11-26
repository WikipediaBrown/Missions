//
//  AddMissionViewController.swift
//  Missions
//
//  Created by nonplus on 7/20/21.
//

import napkin
import Combine
import SwiftUI

protocol AddMissionPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
    func onAddMission(name: String)
    func onDismissAddMission()
}

final class AddMissionViewController: UIHostingController<AddMissionView>, AddMissionPresentable, AddMissionViewControllable {
    

    weak var listener: AddMissionPresentableListener?
    
    private var cancellables: Set<AnyCancellable> = []

    init() {
        super.init(rootView: AddMissionView())
        presentationController?.delegate = self

        rootView
            .tapSubject
            .sink { [weak self] tap in
                switch tap {
                case .addMission(let name): self?.listener?.onAddMission(name: name)
                case .dismiss: self?.listener?.onDismissAddMission()
                }
            }
            .store(in: &cancellables)
        
        lifeCycleSubject
            .sink { [weak self] event in
                switch event {
                case .didDismiss(presentationController: _): self?.listener?.onDismissAddMission()
                default: break
                }
            }
            .store(in: &cancellables)

    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    
    
    // MARK: - AddMissionViewControllable
    
    func presentAddMission(viewController: UIViewController) {
        present(viewController, animated: true)
    }
    
    func dismissAddMission() {
        children.forEach { $0.dismiss(animated: true) }
    }
    
    
    // MARK: - MissionViewController
    
    var lifeCycleSubject = PassthroughSubject<PresentationLifeCycle, Never>()
    var shouldDismiss = true
    
}

extension AddMissionViewController: UIAdaptivePresentationControllerDelegate {
    func presentationController(_ presentationController: UIPresentationController, willPresentWithAdaptiveStyle style: UIModalPresentationStyle, transitionCoordinator: UIViewControllerTransitionCoordinator?) {
        lifeCycleSubject.send(.willPresentWithAdaptiveStyle(presentationController: presentationController, style: style, transitionCoordinator: transitionCoordinator))
    }
    
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        lifeCycleSubject.send(.didAttemptToDismiss(presentationController: presentationController))
    }
    
    func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
        lifeCycleSubject.send(.willDismiss(presentationController: presentationController))
    }

    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        return shouldDismiss
    }
    
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        lifeCycleSubject.send(.didDismiss(presentationController: presentationController))
    }
}

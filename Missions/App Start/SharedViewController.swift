//
//  SharedViewController.swift
//  Missions
//
//  Created by nonplus on 7/21/21.
//

import Combine
import UIKit

class SharedViewController: UIViewController {
    var lifeCycleSubject = PassthroughSubject<PresentationLifeCycle, Never>()
    var shouldDismiss = true
}

extension SharedViewController: UIAdaptivePresentationControllerDelegate {
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

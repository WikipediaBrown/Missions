//
//  PresentationLifeCycle.swift
//  Missions
//
//  Created by nonplus on 7/21/21.
//

import UIKit

enum PresentationLifeCycle {
    case willPresentWithAdaptiveStyle(presentationController: UIPresentationController, style: UIModalPresentationStyle, transitionCoordinator: UIViewControllerTransitionCoordinator?)
    case didAttemptToDismiss(presentationController: UIPresentationController)
    case willDismiss(presentationController: UIPresentationController)
    case didDismiss(presentationController: UIPresentationController)
}

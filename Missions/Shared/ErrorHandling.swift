//
//  ErrorHandling.swift
//  Missions
//
//  Created by nonplus on 11/21/21.
//

import UIKit

protocol ErrorHandling: AnyObject {
    func present(_ viewControllerToPresent: UIViewController, animated: Bool, completion: (() -> Void)?)
}

extension ErrorHandling {
    func presentError(error: Error) {
        let title = "Error"
        let message = error.localizedDescription
        let style = UIAlertController.Style.alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        let dismissAction = UIAlertAction(title: "dismiss", style: .cancel, handler: nil)
        
        alert.addAction(dismissAction)
        DispatchQueue.main.async { [weak self] in
            self?.present(alert, animated: true, completion: nil)
        }
    }
}
